import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/controllers/register.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class AddEmailScreen extends GetView<RegisterController> {
  AddEmailScreen({super.key});

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
                      "${lang?.tapYourEmail}",
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
                      child: TextFormField(
                          autofocus: true,
                          controller: controller.emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: DARK_COLOR,
                          validator: (value) {
                            if (value == null) {
                              return "${lang?.emailRequired}";
                            }

                            if (!value.isEmail) {
                              return "${lang?.emailInvalid}";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 16),
                              color: DARK_COLOR),
                          decoration: decoration("${lang?.emailAddress}")),
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
                    onPressed: controller.checkEmailLoad.value
                        ? null
                        : () {
                            if (_form.currentState!.validate()) {
                              controller.checkEmail(
                                  email: controller.emailCtrl.text);
                            }
                          },
                    child: controller.checkEmailLoad.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: MAIN_COLOR),
                          )
                        :  Text("${lang?.next}", style:const TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ).paddingAll(20),
          ),
        ));
  }
}
