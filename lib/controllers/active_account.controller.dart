import 'package:get/get.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/core/services/profile.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';

class ActiveAccountController extends GetxController {
  final resendLoad = false.obs;
  final activeAccountLoad = false.obs;
  final _profileService = Get.find<ProfileService>();

  resendLink() {
    resendLoad.value = true;
    _profileService
        .resendLink()
        .then((value) => {
              resendLoad.value = false,
              successMessage(
                  title:"${lang?.notification}",
                  content:
                      "${lang?.weSendYouEmailForVerification}")
            })
        .catchError((e) {
      resendLoad.value = false;
      successMessage(
          title: "${lang?.oups}",
          content: "${lang?.errorWhenSend}");
    });
  }

  refreshStatus() async {
    activeAccountLoad.value = true;
    var service = Get.find<ProfileService>();
    service.profile().then((value) {
      if (value.emailVerified != null && value.emailVerified == true) {
        Get.offAndToNamed(Goo.homeScreen);
      } else {
        errorMessage(
            title: "${lang?.error}",
            content: "${lang?.yourAccountIsNotActive}");
      }
      activeAccountLoad.value = false;
    }).catchError((e) {
      activeAccountLoad.value = false;
      errorMessage(
          title: "${lang?.oups}", content: "${lang?.yourAccountIsNotActive}");
    });
  }
}
