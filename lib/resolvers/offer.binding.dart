import 'package:get/get.dart';
import 'package:twinz/controllers/offer.controller.dart';
import 'package:twinz/core/services/payment.service.dart';

class OfferBindinge extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => PaymentService());
    Get.lazyPut(() => OfferController(), fenix: true);
  }
}
