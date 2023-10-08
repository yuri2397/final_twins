import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twins/components/ui.dart';
import 'package:twins/core/services/profile.service.dart';
import 'package:twins/core/utils/utils.dart';
import 'package:twins/routes/router.dart';
import 'package:twins/shared/utils/colors.dart';

class ProfileController extends GetxController {
  final user = localStorage.getUser().obs;
  final settingStatus = false.obs;
  final logoutLoad = false.obs;
  final addPhotoLoad = false.obs;
  final updateLoad = false.obs;
  final existingFiles = <XFile>[].obs;
  final settings = localStorage.getSettings().obs;
  final updateSettingsLoad = false.obs;
  final nameCrtl = TextEditingController();
  final emailCrtl = TextEditingController();
  final phoneCrtl = TextEditingController();
  final bioCrtl = TextEditingController();
  final addressCrtl = TextEditingController();
  final birthdayCrtl = TextEditingController();
  final sexCrtl = TextEditingController();
  final passwordCrtl = TextEditingController();

  /// FILES

  final files = <Rx<XFile>>[
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
    XFile("").obs,
  ];

  final _profileService = Get.find<ProfileService>();

  @override
  void onInit() {
    super.onInit();
    determinePosition().then((value) {
      var user = localStorage.getUser();
      user?.lat = "${value.latitude}";
      user?.lng = "${value.longitude}";
      localStorage.user = user;
      settingStatus.value = true;
      _profileService.profileUpdate(data: user!).then((value) => {});
    });
    profile();
    photos();
  }

  Future<void> updateProfilePhoto(XFile file) async {
    await _profileService.updateProfilePhoto(file).then((value) {
      user.value = value;
      user.refresh();
      localStorage.user = value;
      settingStatus.value = true;
    }).catchError((e) {
      print("$e");
      errorMessage(title: "DEBUG", content: "$e");
    });
  }

  Future<void> profile() async {
    await _profileService.profile().then((value) {
      user.value = value;
      user.refresh();
      localStorage.user = value;
      settings.value = value.settings;
      settings.refresh();
    }).catchError((e) {
      print(e);
    });
  }

  void save() {
    updateLoad.value = true;

    _profileService.profileUpdate(data: user.toJson()).then((value) {
      user.value = value;
      user.refresh();
      updateLoad.value = false;
    }).catchError((e) {
      updateLoad.value = false;
      errorMessage(title: "Oups !", content: "$e");
    });
  }

  updateSettings() async {
    updateSettingsLoad.value = true;
    await _profileService.updateSettings(settings.value!).then((value) =>
        successMessage(
            title: "Félicitation",
            content: "Paramètres sont maintenant à jour."));
    updateSettingsLoad.value = false;
  }

  addPhotos() {
    addPhotoLoad.value = true;
    var finalFiles = files
        .map((e) => e.value)
        .where((e) => (existingFiles
                .firstWhere((p0) => p0.path == e.path,
                    orElse: () => XFile("path"))
                .path ==
            "path"))
        .where((e) => e.path.isNotEmpty)
        .toList();

    _profileService.addPhotos(finalFiles).then((value) {
      addPhotoLoad.value = false;
      successMessage(
          title: "Félicitations",
          content: "Votre album photo est mise à jour.");
    }).catchError((e) {
      addPhotoLoad.value = false;
    });
  }

  Future<void> photos() async {
    await _profileService.getPhotos().then((value) async {
      int i = 0;
      existingFiles.value = [];
      for (var e in value) {
        var p = await getImageXFileByUrl(e.url!);
        existingFiles.add(p);
        files[i] = (p).obs;
        i++;
      }
    });
  }

  deletePhotos(XFile file) async {}

  logout() async {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Déconnexion",
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 10,
          ),
          const Text("Continuer la déconnexion? ",
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    logoutLoad.value = false;
                    _profileService.logout().then((value) {
                      logoutLoad.value = false;
                      localStorage.clear();
                      Get.offAllNamed(Goo.onboardingScreen);
                    }).catchError((e) {
                      logoutLoad.value = false;
                    });
                  },
                  child: const Text("Oui")),
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: DARK_COLOR,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Annuler")),
            ],
          )
        ],
      ),
    ));
  }

  disabledAccount() async {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
              "La désactivation de votre compte est temporaire, votre profil sera masqué jusqu’à ce que vous le réactiviez en vous connectant à nouveau sur Twinz.",
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                    _confirmDisableAccount();
                  },
                  child: const Text("Je confirme")),
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: DARK_COLOR,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Annuler")),
            ],
          )
        ],
      ),
    ));
  }

  removeAccount() async {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Déconnexion",
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 10,
          ),
          const Text("Continuer la déconnexion? ",
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    logoutLoad.value = false;
                    _profileService.logout().then((value) {
                      logoutLoad.value = false;
                      localStorage.clear();
                      Get.offAllNamed(Goo.onboardingScreen);
                    }).catchError((e) {
                      logoutLoad.value = false;
                    });
                  },
                  child: const Text("Oui")),
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: DARK_COLOR,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Annuler")),
            ],
          )
        ],
      ),
    ));
  }

  void _confirmDisableAccount() {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Confirmez la désactivation temporaire du compte.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
          const Text(
              "Vous êtes sur le point de désactiver temporairement votre compte. Vous pouvez le réactiver à tout moment en vous connectant à votre compte Twinz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: TextButton.styleFrom(
                  backgroundColor: MAIN_COLOR,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              onPressed: () {},
              child: const Text("Désactiver le compte")),
          ElevatedButton(
              style: TextButton.styleFrom(
                  foregroundColor: DARK_COLOR,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              onPressed: () {
                Get.back();
              },
              child: const Text("Annuler")),
        ],
      ),
    ));
  }

  changeGender(String s) {
    settings.value?.gender = s;
    settings.refresh();
  }
}
