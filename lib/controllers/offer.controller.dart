import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
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

  @override
  Future<void> onInit() async {
    super.onInit();
    getOffers();
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

  void buy(Plan plan) {
    Navigator.push(Get.context!, MaterialPageRoute(builder: (_) => IOSPayment(plan: plan)));
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
