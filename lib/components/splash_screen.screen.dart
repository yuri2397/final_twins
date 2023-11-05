import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:twinz/controllers/chat.controller.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/core/model/chat.dart';
import 'package:twinz/core/services/local_storage.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () {
      var haveChatId = localStorage.box.read("chat_id");
      if (haveChatId != null) {
        localStorage.box.remove('chat_id');
        Get.find<ChatController>()
            .detailsChat(Chat(id: int.tryParse(haveChatId)));
      } else if (isAuth &&
          localStorage.getUser()?.emailVerified != null &&
          localStorage.getUser()?.emailVerified == false) {
        Get.offAllNamed(Goo.activeAccountScreen);
      } else if (localStorage.getToken() != null) {
        Get.offAllNamed(Goo.homeScreen);
      } else {
        Get.offAllNamed(Goo.onboardingScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAIN_COLOR,
      body: Center(
          child: Image.asset(
        Env.whiteLogo,
        width: 100,
      )),
    );
  }
}
