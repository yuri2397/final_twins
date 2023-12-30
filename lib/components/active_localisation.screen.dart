import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twinz/controllers/active_location.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class ActiveLocationScreen extends GetView<ActiveLocationController> {
  const ActiveLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "${lang?.allowLocationAccess}",
            style: const TextStyle(
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
            "${lang?.locationPermissionMessage}",
            style:const TextStyle(
                color: DARK_COLOR,
                fontSize: 16,
                fontFamily: "Haylard",
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () => controller.activeLocation(),
            child: Text("${lang?.enableLocation}",
                style: const TextStyle(color: MAIN_COLOR)),
          ),
        ],
      ).marginSymmetric(horizontal: 20)),
    );
  }
}
