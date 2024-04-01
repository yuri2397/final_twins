// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/model/plan.dart';
import 'package:twinz/core/services/payment.service.dart';
import 'package:twinz/core/services/profile.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/controllers/search.controller.dart' as sc;

import 'consumable_store.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'dash_consumable_2k_15';
const String _kUpgradeId = 'dash_consumable_2k_30';
const String _kSilverSubscriptionId = 'dash_consumable_2k_7';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId
];

class IOSPayment extends StatefulWidget {
  const IOSPayment({
    super.key,
  });

  @override
  State<IOSPayment> createState() => _IOSPaymentState();
}

class _IOSPaymentState extends State<IOSPayment> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  final user = localStorage.getUser().obs;
  final offers = <Plan>[].obs;
  final offerLoad = true.obs;
  final _service = Get.find<PaymentService>();

  @override
  void initState() {
    _service.index().then((value) {
      offers.value = value;
      offers.refresh();
      offerLoad.value = false;
    }).catchError((e) {
      offerLoad.value = false;
    });
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
      Get.back();
    }, onError: (Object error) {
      // handle error here.
      errorMessage(title: "${lang?.oups}", content: "${lang?.errorOccurred}");
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            //_buildConnectionCheckTile(),
            _buildProductList(),
            //_buildConsumableBox(),
            //_buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        const Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(
                color: MAIN_COLOR,
              ),
            ),
          ],
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white)),
        ),
        body: Stack(
          children: stack,
        ),
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return Card(child: ListTile(title: Text('${lang?.tryingToConnect}...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable
              ? Colors.green
              : ThemeData.light().colorScheme.error),
      title:
          Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll(<Widget>[
        const Divider(),
        ListTile(
          title: Text("${lang?.notConnected}",
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: Text("${lang?.unableToConnect}"),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!_isAvailable) {
      return const Card();
    }
    ListTile productHeader = ListTile(title: Text("${lang?.productsForSale}"));
    final List<Widget> productList = <Widget>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: Text("${lang?.specialConfigurationRequired}")));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        final PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return GestureDetector(
          onTap: () {
            late PurchaseParam purchaseParam;

            if (Platform.isAndroid) {
              // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
              // verify the latest status of you your subscription by using server side receipt validation
              // and update the UI accordingly. The subscription purchase status shown
              // inside the app may not be accurate.
            } else {
              purchaseParam = PurchaseParam(
                productDetails: productDetails,
              );
            }

            if (productDetails.id == _kConsumableId) {
              _inAppPurchase.buyConsumable(
                  purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
            } else {
              _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
            }
          },
          child: Container(
            width: Get.width * .3,
            height: 170,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MAIN_COLOR, width: 2),
            ),
            child: Column(
              children: [
                Text(
                    "${offers[_offerIndex(productDetails.id)].duration} ${lang?.days}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20)),
                Text("${offers[_offerIndex(productDetails.id)].description}",
                    textAlign: TextAlign.center),
                Text(
                  productDetails.price,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                )
              ],
            ),
          ),
        );
      },
    ));

    return Obx(
      () => Column(children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Text(
          "${lang?.subscription}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: MAIN_COLOR,
              fontSize: 30,
              fontFamily: "Haylard",
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "${lang?.purchaseInfo}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: DARK_COLOR, fontFamily: "Haylard", fontSize: 16),
        ),
        const SizedBox(
          height: 40,
        ),
        if (user.value!.isPremium == true)
          Text(
            "${lang?.alreadyPremium}",
            style: const TextStyle(
                color: MAIN_COLOR,
                fontSize: 20,
                fontFamily: "Haylard",
                fontWeight: FontWeight.w500),
          ),
        if (user.value!.isPremium == true)
          Text(
            "${lang?.expirationDate} : ${DateFormat.yMMMd(Localizations.localeOf(Get.context!).languageCode).format(user.value!.subscriptionExpiryDate!)}",
            style: const TextStyle(
                color: DARK_COLOR,
                fontSize: 18,
                fontFamily: "Haylard",
                fontWeight: FontWeight.w500),
          ).marginOnly(top: 20),
        if (user.value!.isPremium == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: productList,
          )
      ]),
    );
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...')));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return const Card();
    }
    const ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: const Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      const Divider(),
      GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: tokens,
      )
    ]));
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void _showSuccessMessage() async {
    Get.find<ProfileService>().profile().then((value) {
      localStorage.user = value;
      user.value = value;
      user.refresh();
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
          Text("${lang?.notification}",
              style: const TextStyle(color: DARK_COLOR, fontSize: 20)),
          Text("${lang?.paymentValidated}")
        ],
      ),
    ));
    Get.toNamed(Goo.homeScreen);
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    // check if purchase is valid

    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final List<String> consumables = await ConsumableStore.load();
          await _service
              .saveUserSubscription(
                  planId: purchaseDetails.productID,
                  transactionId: purchaseDetails.purchaseID!)
              .then((value) {
            if (value) {
              setState(() {
                _purchasePending = false;
                _consumables = consumables;
              });
              Get.toNamed(Goo.homeScreen);
              successMessage(
                  title: "${lang?.notification}",
                  content: "${lang?.paymentValidated}");
            } else {
              errorMessage(title: "Oups", content: "${lang?.errorOccurred}");
            }
          }).catchError((e) {
            errorMessage(title: "Oups", content: "${lang?.errorOccurred}");
          });
          _showSuccessMessage();
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _purchasePending = false;
          });
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    // Price changes for Android are not handled by the application, but are
    // instead handled by the Play Store. See
    // https://developer.android.com/google/play/billing/price-changes for more
    // information on price changes on Android.
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  _offerIndex(String id) {
    switch (id) {
      case "dash_consumable_2k_7":
        var o = offers.firstWhere((element) => element.duration == "7");
        return offers.indexOf(o);
      case "dash_consumable_2k_15":
        var o = offers.firstWhere((element) => element.duration == "15");
        return offers.indexOf(o);
      case "dash_consumable_2k_30":
        var o = offers.firstWhere((element) => element.duration == "30");
        return offers.indexOf(o);
    }
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
