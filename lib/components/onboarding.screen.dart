import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/controllers/onboarding.controller.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/core/services/firebase_message.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                      Text("${lang?.welcome}",
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
                        text: "${lang?.cgu1} ",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        children: [
                          TextSpan(
                            text: "${lang?.cgu2}",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => lunchWebURL(
                                  "https://www.findyourtwinz.com/legal#conditions"),
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${lang?.cgu3} ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "${lang?.cgu4}",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => lunchWebURL(Env.policiesUrl),
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " ${lang?.cgu5} ",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "${lang?.cgu6}",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => lunchWebURL(Env.cookiesUrl),
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " ${lang?.cgu7}",
                            style: const TextStyle(
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
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Checkbox(
                            value: controller.conditionsAccepted.value,
                            activeColor: Colors.white,
                            checkColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              controller.conditionsAccepted.value =
                                  !controller.conditionsAccepted.value;
                            },
                          ),
                          Text(
                            "${lang?.cgu8}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                lunchWebURL(
                                    "https://www.findyourtwinz.com/legal#conditions");
                              },
                              child: Text(
                                "${lang?.cgu9}",
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: Get.width,
                        child: ElevatedButton(
                            onPressed: () {
                              //if (controller.conditionsAccepted.value) {
                              Get.toNamed(Goo.loginScreen);
                              /*} else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Veuillez accepter les conditions d'utilisation svp!"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 3),
                                ));
                              }*/
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: MAIN_COLOR,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text("${lang?.signIn}")),
                      ).marginOnly(bottom: 10),
                      SizedBox(
                        width: Get.width,
                        child: ElevatedButton(
                            onPressed: () {
                              if (controller.conditionsAccepted.value) {
                                Get.toNamed(Goo.registerScreen);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("${lang?.cgu10}"),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 3),
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                foregroundColor: MAIN_COLOR,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text("${lang?.signup}")),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
