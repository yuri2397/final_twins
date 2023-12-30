import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:twinz/controllers/active_account.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class ActiveAccountScreen extends GetView<ActiveAccountController> {
  const ActiveAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: NEUTRAL_COLOR,
          body: Container(
            height: Get.height,
            width: Get.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                       Text(
                        "${lang?.welcomeToTwinz}",
                        style:const TextStyle(
                            color: MAIN_COLOR,
                            fontSize: 30,
                            fontFamily: "Haylard",
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                       Text(
                        "${lang?.verifyYourEmail}",
                        style: const TextStyle(
                            color: DARK_COLOR,
                            fontSize: 16,
                            fontFamily: "Haylard",
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => controller.refreshStatus(),
                        child:  Text("${lang?.emailAlreadyVerify}",
                            style:const TextStyle(color: MAIN_COLOR)),
                      ),
                      if (controller.activeAccountLoad.value)
                        const CircularProgressIndicator(color: MAIN_COLOR)
                            .marginSymmetric(vertical: 20),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MAIN_COLOR,
                        foregroundColor: Colors.white),
                    onPressed: () => controller.resendLink(),
                    child: controller.resendLoad.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : Text("${lang?.requestNewCode}"),
                  ),
                ),
              ],
            ).paddingAll(20),
          )),
    );
  }
}
