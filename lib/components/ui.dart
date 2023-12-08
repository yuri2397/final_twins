import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:twinz/components/ios_payment.screen.dart';
import 'package:twinz/controllers/home.controller.dart';
import 'package:twinz/core/model/user.dart';
import 'package:twinz/core/services/firebase_message.service.dart';
import 'package:twinz/core/services/payment.service.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/core/config/env.dart';

errorMessage(
    {required String title,
    required String content,
    SnackPosition? position,
    Duration? duration}) {
  Get.snackbar(title, content,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      snackPosition: position ?? SnackPosition.TOP,
      borderRadius: 20,
      duration: duration ?? const Duration(seconds: 3),
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10));
}

successMessage(
    {required String title, required String content, SnackPosition? position}) {
  Get.snackbar(title, content,
      colorText: Colors.white,
      backgroundColor: Colors.green,
      snackPosition: position ?? SnackPosition.TOP,
      borderRadius: 20,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10));
}

infoMessage({required String title, required String content}) {}

warningMessage({required String title, required String content}) {}

itemIcon(IconData icon, {Color? backgroundColor, Color? color, double? size}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 20,
          offset: const Offset(2, 3), // changes position of shadow
        ),
      ],
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    child: Icon(
      icon,
      color: color ?? MAIN_COLOR,
      size: size ?? 25,
    ),
  );
}

Widget hr() {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.all(20),
    height: 8,
    width: Get.width * .2,
    decoration: BoxDecoration(
        color: NEUTRAL_COLOR, borderRadius: BorderRadius.circular(20)),
  );
}

showUserDetails(User user) {
  Get.bottomSheet(Container(
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: hr()),
        Row(
          children: [
            Text(
              "${user.fullName}, ${user.age} ans",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 30,
            ),
            const Icon(
              CupertinoIcons.check_mark_circled,
              color: MAIN_COLOR,
            ),
          ],
        ).marginOnly(bottom: 10, left: 20, top: 8),
        Row(
          children: [
            itemIcon(Icons.map_rounded),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Dakar • 24km",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            )
          ],
        ).marginOnly(bottom: 10, left: 20),
        const Divider(
          color: NEUTRAL_COLOR,
          height: 2,
        ).marginAll(20),
        SizedBox(
          height: 130,
          width: Get.width,
          child: Skeletonizer(
            enabled: true,
            ignoreContainers: true,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                detailUserPhotoItem(
                  "https://img.freepik.com/free-photo/portrait-young-businesswoman-holding-eyeglasses-hand-against-gray-backdrop_23-2148029483.jpg?w=740&t=st=1695565814~exp=1695566414~hmac=586f96c0ddffa502148f29cc2c29f896fbdea68863e1b18ff06b44a2f8923713",
                ),
                detailUserPhotoItem(
                  "https://img.freepik.com/free-photo/portrait-young-businesswoman-holding-eyeglasses-hand-against-gray-backdrop_23-2148029483.jpg?w=740&t=st=1695565814~exp=1695566414~hmac=586f96c0ddffa502148f29cc2c29f896fbdea68863e1b18ff06b44a2f8923713",
                ),
                detailUserPhotoItem(
                  "https://img.freepik.com/free-photo/portrait-young-businesswoman-holding-eyeglasses-hand-against-gray-backdrop_23-2148029483.jpg?w=740&t=st=1695565814~exp=1695566414~hmac=586f96c0ddffa502148f29cc2c29f896fbdea68863e1b18ff06b44a2f8923713",
                ),
                detailUserPhotoItem(
                  "https://img.freepik.com/free-photo/portrait-young-businesswoman-holding-eyeglasses-hand-against-gray-backdrop_23-2148029483.jpg?w=740&t=st=1695565814~exp=1695566414~hmac=586f96c0ddffa502148f29cc2c29f896fbdea68863e1b18ff06b44a2f8923713",
                ),
                detailUserPhotoItem(
                  "https://img.freepik.com/free-photo/portrait-young-businesswoman-holding-eyeglasses-hand-against-gray-backdrop_23-2148029483.jpg?w=740&t=st=1695565814~exp=1695566414~hmac=586f96c0ddffa502148f29cc2c29f896fbdea68863e1b18ff06b44a2f8923713",
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(
                  Icons.close,
                  color: DARK_COLOR,
                  size: 50,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        )
      ],
    ),
  ));
}

drawer({drawerKey, scaffoldKey}) {
  return Drawer(
    key: drawerKey,
    child: ListView(
      children: [
        ListTile(
          leading: itemIcon(Icons.close, color: MAIN_COLOR),
          title: const Text("Menu",
              style: TextStyle(
                  fontSize: 20, color: MAIN_COLOR, fontFamily: "Haylard")),
          onTap: () => scaffoldKey.currentState?.closeDrawer(),
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: NEUTRAL_COLOR,
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          onTap: () => Get.find<HomeController>().currentIndex.value = 3,
          leading: itemIcon(Icons.person_outline_rounded, color: MAIN_COLOR),
          title: const Text("Profil",
              style: TextStyle(
                  fontSize: 20, color: MAIN_COLOR, fontFamily: "Haylard")),
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          onTap: () {
            Platform.isIOS
                ? Navigator.push(Get.context!,
                    MaterialPageRoute(builder: (_) => IOSPayment()))
                : Get.toNamed(Goo.offerScreen);
          },
          leading: itemIcon(Icons.payment_outlined, color: MAIN_COLOR),
          title: const Text("Twinz Premium",
              style: TextStyle(
                  fontSize: 20, color: MAIN_COLOR, fontFamily: "Haylard")),
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          onTap: () => Get.toNamed(Goo.settingScreen),
          leading: itemIcon(Icons.settings_outlined, color: MAIN_COLOR),
          title: const Text("Réglages",
              style: TextStyle(
                  fontSize: 20, color: MAIN_COLOR, fontFamily: "Haylard")),
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          onTap: () => lunchWebURL(
              "https://www.findyourtwinz.com/legal#confidentialit%C3%A9"),
          leading: itemIcon(Icons.security_outlined, color: MAIN_COLOR),
          title: const Text("Confidentialité",
              style: TextStyle(
                  fontSize: 20, color: MAIN_COLOR, fontFamily: "Haylard")),
        )
      ],
    ).paddingSymmetric(vertical: 40, horizontal: 20),
  );
}

Widget detailUserPhotoItem(String url) {
  return Container(
    height: 100,
    width: 120,
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: NEUTRAL_COLOR,
          spreadRadius: .1,
          blurRadius: 1,
          offset: Offset(2, 2), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(20),
    ),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        )),
  );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
