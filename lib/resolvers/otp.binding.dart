import 'package:get/get.dart';
import 'package:twins/controllers/register.controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController(), fenix: true);
  }
}
