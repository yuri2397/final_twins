import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:twinz/components/ios_payment.screen.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/model/init_payment.dart';
import 'package:twinz/core/model/plan.dart';
import 'package:twinz/core/services/payment.service.dart';
import 'package:twinz/core/services/profile.service.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/controllers/search.controller.dart' as sc;

class OfferController extends GetxController {
  final load = false.obs;
  final _service = Get.find<PaymentService>();
  final offers = <Plan>[].obs;
  final offerLoad = true.obs;
  final lastInitPayment = InitPayment().obs;
  final currentOffer = Plan().obs;
  final user = localStorage.getUser().obs;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<dynamic> _streamSubscription;
  final List<ProductDetails> _products = [];
  final _variant = {
    "id1",
    "id2",
  };

  @override
  Future<void> onInit() async {
    getOffers();

    super.onInit();
    Stream purchaseUpdated = _inAppPurchase.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      print(error);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text('Something went wrong')));
    });

    initStore();
  }

  selectOffer(Plan plan) {
    offers.forEach((e) {
      if (plan.id == e.id) {
        e.selected = true;
      } else {
        e.selected = false;
      }
    });
    offers.refresh();
  }

  Future<void> getOffers() async {
    offerLoad.value = true;
    _service.index().then((value) {
      offers.value = value;
      offers.refresh();
      offerLoad.value = false;
    }).catchError((e) {
      offerLoad.value = false;
    });
  }

  Future<void> choosePlan(Plan p) async {
    selectOffer(p);
    load.value = true;
    if (GetPlatform.isIOS) {
      buy(p);
    } else {
      _service.initPayment(p.id.toString()).then((value) async {
        lastInitPayment.value = value;
        print("PAYEMENT/:::::::::::::::::::: ${value.toJson().toString()}");

        var stripeval = await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                    paymentIntentClientSecret: value.clientSecret,
                    merchantDisplayName: 'Twinz'))
            .then((value) {});
        load.value = false;
        print("Stripe value is:---> $stripeval");
        _displayPaymentSheet(value);
      }).catchError((e) {
        load.value = false;
        print("Error is:---> $e");
      });
    }
  }

  Future<void> _displayPaymentSheet(InitPayment value) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((v) {
        _checkPayment(value);
      }).onError((error, stackTrace) {
        print(error);
        stackTrace.printError();
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
    } catch (e) {
      print('$e');
    }
  }

  void initStore() async {
    ProductDetailsResponse productDetailResponse =
        await InAppPurchase.instance.queryProductDetails(_variant);
    // if error
    if (productDetailResponse.error != null) {
      print("Error is:---> ${productDetailResponse.error!.message}");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Something went wrong :)')));
      return;
    }
    if (productDetailResponse.notFoundIDs.isNotEmpty) {
      print("Not found");
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text('Not found')));
    }
    productDetailResponse.productDetails
        .forEach((ProductDetails productDetails) {
      _products.add(productDetails);
    });
  }

  void buy(Plan plan) {
    // go to ios payment
    Navigator.push(Get.context!, MaterialPageRoute(builder: (_) => IOSPayment(plan: plan)));
    /*final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: _products[0]);
    _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: false);*/
  }

  void _checkPayment(InitPayment value) async {
    load.value = true;
    _service.paymentSuccess("${value.id}").then((value) async {
      print("$value");
      if (value) {
        Get.find<ProfileService>().profile().then((value) {
          localStorage.user = value;
          user.value = value;
          user.refresh();
          load.value = false;
        });

        await Get.find<sc.SearchController>().getMatchings();
        Get.find<sc.SearchController>().user.value?.isPremium = true;
        Get.find<sc.SearchController>().user.refresh();
        Get.find<ProfileController>().profile();

        await Get.bottomSheet(Container(
          padding: const EdgeInsets.only(bottom: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              hr(),
              const SizedBox(
                height: 10,
              ),
              const Icon(
                Icons.check,
                color: Colors.green,
                size: 50,
              ),
              const Text("Félicitation",
                  style: TextStyle(color: DARK_COLOR, fontSize: 20)),
              const Text("Votre paiement est validé.")
            ],
          ),
        ));
        load.value = false;
        Get.toNamed(Goo.homeScreen);
      }
    }).catchError((e) {
      print("$e");
      load.value = false;
    });
  }
}

void _listenToPurchaseUpdated(purchaseDetailsList) async {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(const SnackBar(content: Text('Purchase is pending.')));
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        errorMessage(title: "Oups !!!", content: "Une erreur est survenue");
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        print("Purchased");
        _verifyPurchase(purchaseDetails);
      }
    }
  });
}

void _verifyPurchase(PurchaseDetails purchaseDetails) {}
