import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/register.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class AddBirthDayScreen extends GetView<RegisterController> {
  AddBirthDayScreen({super.key});

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
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${lang?.addYourDateOfBirth}",
                    style: const TextStyle(
                        color: DARK_COLOR,
                        fontSize: 30,
                        fontFamily: "Haylard",
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _form,
                    child: SizedBox(
                      width: Get.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: TextFormField(
                                autofocus: true,
                                controller: controller.bd1Ctrl,
                                inputFormatters: [
                                  controller.dayMask,
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.,]+'))
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return "JJ";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "JJ";
                                  }
                                  if (int.tryParse(value)! < 1 ||
                                      int.tryParse(value)! > 31) {
                                    return "JJ";
                                  }
                                  if (value.length != 2) {
                                    return "JJ";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.white,
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 20),
                                    color: Colors.white),
                                decoration: _decoration("JJ")),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: TextFormField(
                                controller: controller.bd2Ctrl,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.white,
                                inputFormatters: [
                                  controller.dayMask,
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.,]+'))
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return "MM";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "MM";
                                  }
                                  if (int.tryParse(value)! < 1 ||
                                      int.tryParse(value)! > 12) {
                                    return "MM";
                                  }
                                  if (value.length != 2) {
                                    return "MM";
                                  }
                                  return null;
                                },
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 20),
                                    color: Colors.white),
                                decoration: _decoration("MM")),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                                controller: controller.bd3Ctrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  controller.yearMask,
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.,]+'))
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return "AAAA";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "AAAA";
                                  }
                                  if (int.tryParse(value)! <
                                          (DateTime.now().year - 80) ||
                                      int.tryParse(value)! >
                                          (DateTime.now().year - 18)) {
                                    return "AAAA";
                                  }
                                  if (value.length != 4) {
                                    return "AAAA";
                                  }
                                  return null;
                                },
                                cursorColor: Colors.white,
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 20),
                                    color: Colors.white),
                                decoration: _decoration("AAAA")),
                          ),
                        ],
                      ),
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
                      try {
                        controller.parseDate();
                      } catch (e) {
                        errorMessage(title: "${lang?.error}", content: '$e');
                      }
                    }
                  },
                  child: Text("${lang?.next}",
                      style: const TextStyle(fontSize: 18)),
                ),
              )
            ],
          ).marginAll(20),
        ));
  }

  _decoration(String text) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintText: text,
      hintStyle: const TextStyle(color: Colors.white, fontFamily: "Haylard"),
      fillColor: MAIN_COLOR,
      filled: true,
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
