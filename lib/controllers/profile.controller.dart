import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/core/services/profile.service.dart';
import 'package:twinz/core/services/user.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/controllers/search.controller.dart' as sc;

class ProfileController extends GetxController {
  final user = localStorage.getUser().obs;
  final settingStatus = false.obs;
  final logoutLoad = false.obs;
  final addPhotoLoad = false.obs;
  final updateLoad = false.obs;
  final existingFiles = <XFile>[].obs;
  final settings = localStorage.getUser()?.settings.obs;
  final updateSettingsLoad = false.obs;
  final nameCrtl = TextEditingController();
  final emailCrtl = TextEditingController();
  final phoneCrtl = TextEditingController();
  final bioCrtl = TextEditingController(text: localStorage.getUser()?.bio);
  final addressCrtl = TextEditingController();
  final birthdayCrtl = TextEditingController();
  final sexCrtl = TextEditingController();
  final passwordCrtl = TextEditingController();

  final logoutLoading = false.obs;

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
  final _userService = Get.find<UserService>();

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
  }

  Future<void> updateProfilePhoto(XFile file) async {
    await _profileService.updateProfilePhoto(file).then((value) {
      user.value = value;
      user.refresh();
      localStorage.user = value;
      settingStatus.value = true;
    }).catchError((e) {
      print("$e");
    });
  }

  Future<void> profile() async {
    await _profileService.profile().then((value) {
      photos();
      user.value = value;
      user.refresh();
      localStorage.user = value;
      settings?.value = value.settings;
      settings?.refresh();
    }).catchError((e) {
      print(e);
    });
  }

  void save() {
    updateLoad.value = true;
    user.value?.bio = bioCrtl.text;
    _userService.updateUser(user.value!).then((value) {
      user.value = value;
      profile();
      updateLoad.value = false;
      successMessage(
          title: "${lang?.notification}",
          content: "${lang?.yourAccountIsUpdate}");
      Get.back();
    }).catchError((e) {
      updateLoad.value = false;
      errorMessage(title: "${lang?.oups}", content: "$e");
    });
  }

  updateSettings() async {
    updateSettingsLoad.value = true;
    await _profileService.updateSettings(settings!.value!).then((value) =>
        successMessage(
            title: "${lang?.notification}",
            content: "${lang?.yourSettingIsUpdate}"));

    updateSettingsLoad.value = false;
    Get.find<sc.SearchController>().getMatchings();
    Get.toNamed(Goo.homeScreen);
  }

  addPhotos() {
    addPhotoLoad.value = true;
    var data =
        files.map((e) => e.value).where((e) => e.path.isNotEmpty).toList();
    print("$data");
    _profileService.addPhotos(data).then((value) {
      photos();
      successMessage(
          title: "${lang?.notification}",
          content: "${lang?.yourAlbumIsUpdate}");
      addPhotoLoad.value = false;
    }).catchError((e) {
      addPhotoLoad.value = false;
    });
  }

  Future<void> photos() async {
    await _profileService.getPhotos().then((value) async {
      for (var i = 0; i < 6; i++) {
        if (value.length > i) {
          var p = await getImageXFileByUrl(value[i].url!);
          files[i] = (p).obs;
        } else {
          files[i] = XFile("").obs;
        }
      }
    });
  }

  deletePhotos(XFile file) async {
    await _profileService.removePhoto(file).then((value) {}).catchError((e) {});
  }

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
          Text("${lang?.logout}",
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 10,
          ),
          Text("${lang?.continueLogout}",
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
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
                      foregroundColor: DARK_COLOR,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                    logoutLoad.value = true;
                    _profileService.logout().then((value) {
                      logoutLoad.value = false;
                      localStorage.clear();
                      Get.offAllNamed(Goo.onboardingScreen);
                    }).catchError((e) {
                      logoutLoad.value = false;
                      localStorage.clear();
                      Get.offAllNamed(Goo.onboardingScreen);
                    });
                  },
                  child: Text("${lang?.yes}")),
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("${lang?.cancel}")),
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
          Text("${lang?.disableAccountMessage}",
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
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
                  child: Text("${lang?.iConfirm}")),
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
                  child: Text("${lang?.cancel}")),
            ],
          )
        ],
      ),
    ));
  }

  removeAccount() async {
    logoutLoad.value = false;
    logoutLoad.refresh();
    print("${logoutLoad.value}");
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
          Text("${lang?.deleteAccount}",
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 10,
          ),
          Text("${lang?.deleteAccountMessage}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => !logoutLoad.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.pink,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          onPressed: () async {
                            logoutLoad.value = true;
                            logoutLoad.refresh();
                            var value =
                                await Get.find<UserService>().deleteAccount();
                            logoutLoad.value = true;
                            logoutLoad.refresh();
                            if (value) {
                              localStorage.clear();
                              Get.offAllNamed(Goo.onboardingScreen);
                            }
                          },
                          child: Text("${lang?.iConfirm}")),
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
                          child: Text("${lang?.cancel}")),
                    ],
                  )
                : const CircularProgressIndicator(
                    color: MAIN_COLOR,
                  ),
          ),
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
          Text("${lang?.disableAccountConfirmMessage}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
           Text("${lang?.disableAccountConfirmMessage1}",
              textAlign: TextAlign.center,
              style:const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
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
              onPressed: () async {
                await Get.find<UserService>().disableAccount().then((value) {
                  successMessage(
                      title: "${lang?.notification}",
                      content: "${lang?.disableAccountSuccessMessage}");
                  localStorage.clear();
                  Get.offAndToNamed(Goo.onboardingScreen);
                });
              },
              child:  Text("${lang?.disableAccount}")),
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
              child:  Text("${lang?.cancel}")),
        ],
      ),
    ));
  }

  changeGender(String s) {
    settings?.value?.gender = s;
    settings?.refresh();
  }
}
