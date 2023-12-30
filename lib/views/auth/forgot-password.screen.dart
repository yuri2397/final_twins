import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twinz/components/input.widget.dart';
import 'package:twinz/controllers/forgot_password.controller.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: MAIN_COLOR,
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Image.asset(
                Env.whiteLogo,
                width: 120,
              ),
            ).marginOnly(bottom: 100),
             Text("${lang?.resetPassword}",
                    style:const TextStyle(
                        fontFamily: "Haylard",
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white))
                .marginOnly(bottom: 20),
            TwinsInput(
              label: "${lang?.resetPassword}",
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => controller.email.value = value,
              validator: (value) {
                if (value == null) {
                  return "${lang?.passwordRequired}";
                }
                if (!value.isEmail) {
                  return "Adresse email incorrect";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: MAIN_COLOR,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () => controller.resetPassword(),
                child: controller.loadingRequest.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MAIN_COLOR,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    :  Text(
                        "${lang?.save}",
                        style:const TextStyle(fontFamily: "Haylard"),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ).paddingAll(20),
      ),
    );
  }
}
