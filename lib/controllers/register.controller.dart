import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/core/model/zodiaque.dart';
import 'package:twinz/core/services/firebase_message.service.dart';
import 'package:twinz/core/services/register.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';

class RegisterController extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final bd1Ctrl = TextEditingController();
  final bd2Ctrl = TextEditingController();
  final bd3Ctrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  final showFilesMessage = true.obs;
  final gender = 'male'.obs;

  var dayMask = MaskTextInputFormatter(
      mask: '##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var yearMask = MaskTextInputFormatter(
      mask: '####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final avatarFile = XFile("").obs;
  final sex = "male".obs;
  final signe = SigneZodiaque("", "", "").obs;
  final checkEmailLoad = false.obs;
  final obscureText = true.obs;
  final loading = false.obs;

  final _registerService = Get.find<RegisterService>();

  final files = <Rx<XFile>>[
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
  ];
  final lat = "".obs;
  final lng = "".obs;

  @override
  void onInit() async {
    super.onInit();
    determinePosition().then((value) {
      lat.value = "${value.latitude}";
      lng.value = "${value.longitude}";
    }).catchError((e) {
      Get.offAndToNamed(Goo.activeLocationScree);
    });
  }

  parseDate() {
    bool isValidDate = validDate(
        bd1Ctrl.text.trim(), bd2Ctrl.text.trim(), bd3Ctrl.text.trim());

    if (!isValidDate) {
      errorMessage(
          title: "Oups !!!", content: "Veuillez choissir une date valide.");
      return;
    }
    // birthdayCtrl.text =
    //     "${bd3Ctrl.text.trim()}/${bd2Ctrl.text.trim()}/${bd1Ctrl.text.trim()}";

    DateTime date = DateTime.parse(
        "${bd3Ctrl.text.trim()}-${bd2Ctrl.text.trim()}-${bd1Ctrl.text.trim()}");

    signe.value = determinerSigne(date);
    birthdayCtrl.text = "$date";
    Get.toNamed(Goo.addSigneScreen);
  }

  // check email
  Future<void> checkEmail({required String email}) async {
    print("check email");
    try {
      checkEmailLoad.value = true;
      _registerService.checkEmail(email: email).then((value) {
        if (value) {
          Get.toNamed(Goo.addPasswordScreen);
        }
        checkEmailLoad.value = false;
      }).catchError((e) {
        checkEmailLoad.value = false;
      });
    } catch (e) {
      rethrow;
    }
  }

  save() async {
    loading.value = true;

    var finalFiles =
        files.map((e) => e.value).where((e) => e.path.isNotEmpty).toList();

    try {
      var deviceToken =
          await Get.find<FireBaseMessagingService>().getDeviceToken();

      Map<String, dynamic> data = {
        "full_name": nameCtrl.text.trim(),
        "gender": sex.value,
        "birth_date": birthdayCtrl.text,
        "email": emailCtrl.text.trim(),
        "bio": bioCtrl.text,
        "password": passwordCtrl.text,
        "lat": lat.value,
        "lng": lng.value,
        "password_confirmation": passwordCtrl.text,
        "device_name": await deviceName,
        "device_id": await deviceId,
        "device_token": deviceToken
      };
      _registerService.register(data: data, files: finalFiles).then((value) {
        loading.value = false;
        successMessage(
            title: "Félicitations", content: "Votre compte a bien été créé.");
        Get.offAllNamed(Goo.activeAccountScreen);
      }).catchError((e, s) {
        print(e);
        print(s);
        loading.value = false;
        loading.refresh();
      });
    } catch (e) {
      loading.value = false;
      loading.refresh();
    }
  }
}
