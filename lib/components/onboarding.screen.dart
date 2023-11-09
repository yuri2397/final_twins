import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/controllers/onboarding.controller.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/core/services/firebase_message.service.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAIN_COLOR,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Stack(
          children: [
            Positioned(
                left: 10,
                right: 10,
                top: 50,
                child: Column(
                  children: [
                    Text("Bienvenue sur ",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w800))),
                    Image.asset(
                      Env.whiteLogo,
                      width: 120,
                    )
                  ],
                )),
            Positioned(
              top: Get.height * .4,
              width: Get.width - 60,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "En utilisant nos services, vous acceptez nos ",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      children: [
                        TextSpan(
                          text: "conditions d'utilisation",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => lunchWebURL("https://www.findyourtwinz.com/legal#conditions"),
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: ". Consultez notre ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: "politique de confidentialité",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => lunchWebURL(Env.policiesUrl),
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: " et ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: "celle relative aux cookies",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => lunchWebURL(Env.cookiesUrl),
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              " pour en savoir plus sur le traitement de vos données.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ])).marginOnly(bottom: 20),
            ),
            Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width,
                      child: ElevatedButton(
                          onPressed: () => Get.toNamed(Goo.loginScreen),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: MAIN_COLOR,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text("Se connecter")),
                    ).marginOnly(bottom: 10),
                    SizedBox(
                      width: Get.width,
                      child: ElevatedButton(
                          onPressed: () => Get.toNamed(Goo.registerScreen),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              foregroundColor: MAIN_COLOR,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text("Créer un compte")),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
