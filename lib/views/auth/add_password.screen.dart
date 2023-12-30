import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/controllers/register.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class AddPasswordScreen extends GetView<RegisterController> {
  AddPasswordScreen({super.key});

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: DARK_COLOR),
          ),
        ),
        body: Obx(
          () => Container(
            height: Get.height,
            width: Get.width,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "${lang?.addYourPassword}",
                      style:const TextStyle(
                          color: DARK_COLOR,
                          fontSize: 30,
                          fontFamily: "Haylard",
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _form,
                      child: SizedBox(
                        height: 60,
                        child: TextFormField(
                            controller: controller.passwordCtrl,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: DARK_COLOR,
                            autofocus: true,
                            validator: (value) {
                              if (value == null) {
                                return "${lang?.passwordRequired}";
                              }

                              if (value.length < 6) {
                                return "${lang?.yourPasswordIsNotSecure}";
                              }
                              return null;
                            },
                            obscureText: controller.obscureText.value,
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(fontSize: 16),
                                color: DARK_COLOR),
                            decoration: decoration("${lang?.password}",
                                suffix: IconButton(
                                  onPressed: () {
                                    controller.obscureText.value =
                                        !controller.obscureText.value;
                                  },
                                  icon: Icon(
                                    controller.obscureText.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: DARK_COLOR,
                                  ),
                                ))),
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  width: Get.width * .4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MAIN_COLOR,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        Get.toNamed(Goo.addBirthDayScreen);
                      }
                    },
                    child:
                         Text("${lang?.next}", style:const TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ).marginAll(20),
          ),
        ));
  }
}
