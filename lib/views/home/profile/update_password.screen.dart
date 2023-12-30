import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class PasswordProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
                  style: const TextStyle(color: MAIN_COLOR),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null) {
                      return "${lang?.passwordRequired}";
                    }
                    if (value.isEmpty || value.length < 4) {
                      return "${lang?.yourPasswordIsNotSecure}";
                    }

                    return null;
                  },
                  decoration:
                      _inputDecoration(text: "${lang?.name}", req: true))
              .marginOnly(bottom: 20),
        ],
      ),
    ));
  }

  _inputDecoration({bool? req, required String text}) {
    return InputDecoration(
        label: Text.rich(
          TextSpan(text: text, style: const TextStyle(), children: const [
            TextSpan(text: " *", style: TextStyle(color: Colors.red))
          ]),
        ),
        floatingLabelStyle: const TextStyle(color: DARK_COLOR),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: MAIN_COLOR)));
  }
}
