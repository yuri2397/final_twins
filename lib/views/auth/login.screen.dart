import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:twinz/components/button.widget.dart';
import 'package:twinz/components/input.widget.dart';
import 'package:twinz/controllers/login.controller.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class LoginScreen extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: MAIN_COLOR,
        body: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              Center(
                child: Image.asset(
                  Env.whiteLogo,
                  width: 120,
                ),
              ).marginOnly(bottom: 100),
              const Text("Connexion",
                      style: TextStyle(
                          fontFamily: "Haylard",
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))
                  .marginOnly(bottom: 20),
              TwinsInput(
                label: "Adresse email",
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.username.value = value,
                validator: (value) {
                  if (value == null) {
                    return "Adresse email obligatoire.";
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
              TwinsInput(
                label: "Mot de passe",
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) => controller.password.value = value,
                validator: (value) {
                  if (value == null) {
                    return "Mot de passe obligatoire.";
                  }
                  return null;
                },
                obscureText: controller.obscureText.value,
                suffix: GestureDetector(
                  onTap: () => controller.obscureText.value =
                      !controller.obscureText.value,
                  child: Icon(
                    controller.obscureText.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
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
                  onPressed: () => controller.login(),
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
                      : const Text(
                          "Se connecter",
                          style: TextStyle(fontFamily: "Haylard"),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                    onTap: () => Get.toNamed(Goo.forgotPasswordScreen),
                    child: const Text(
                      "Mot de passe oublié?",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Haylard",
                          fontSize: 16),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Goo.registerScreen),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: "Vous avez un compte? ",
                        style: TextStyle(
                            color: Color.fromARGB(197, 255, 255, 255))),
                    TextSpan(
                        text: " Créer un compte",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))
                  ])),
                ),
              )
            ],
          ).paddingAll(20),
        ),
      ),
    );
  }
}
