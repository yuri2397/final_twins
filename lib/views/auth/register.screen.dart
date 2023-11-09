import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/register.controller.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class RegisterScreen extends GetView<RegisterController> {
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
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quel est votre prénom?",
                      style: TextStyle(
                          color: DARK_COLOR,
                          fontSize: 30,
                          fontFamily: "Haylard",
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                    ),
                    Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                                  controller: controller.nameCtrl,
                                  cursorColor: DARK_COLOR,
                                  autofocus: true,
                                  keyboardType: TextInputType.name,
                              inputFormatters:[
                                UpperCaseTextFormatter()
                              ],
                                  validator: (value) {
                                    if (value == null) {
                                      return "Votre prénom est obligatoire.";
                                    }

                                    if (value.length < 2) {
                                      return "Tapez votre prénom.";
                                    }
                                    return null;
                                  },
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 16),
                                      color: DARK_COLOR),
                                  decoration: _decoration("Prénom..."))
                              .marginOnly(top: 10),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      Get.toNamed(Goo.addSexScreen);
                    }
                  },
                  child: const Text("Suivant", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ).paddingAll(20),
        ));
  }

  _decoration(String text) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      hintText: text,
      hintStyle: const TextStyle(color: DARK_COLOR, fontFamily: "Haylard"),
      errorStyle: const TextStyle(color: Colors.redAccent),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent)),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: MAIN_COLOR)),
      border:
          const OutlineInputBorder(borderSide: BorderSide(color: DARK_COLOR)),
    );
  }
}

