import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class UpdateProfileScreen extends GetView<ProfileController> {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: NEUTRAL_COLOR,
          appBar: AppBar(
            backgroundColor: NEUTRAL_COLOR,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () => controller.save(),
                child: Center(
                        child: controller.updateLoad.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: MAIN_COLOR,
                                  strokeWidth: 3,
                                ),
                              )
                            :  Text("${lang?.save}",
                                style:
                                const TextStyle(color: MAIN_COLOR, fontSize: 16)))
                    .marginOnly(right: 10),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                   Center(
                      child: Text(
                    "${lang?.updateBio}",
                    style:const TextStyle(
                        color: MAIN_COLOR,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(
                    height: 30,
                  ),

                  const Text("Bio",
                      style: TextStyle(
                        color: MAIN_COLOR,
                      )).marginOnly(bottom: 8),
                  TextFormField(
                      controller: controller.bioCrtl,
                      cursorColor: DARK_COLOR,
                      minLines: 3,
                      maxLines: 3,
                      maxLength: 120,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16),
                          color: DARK_COLOR),
                      decoration: _decoration("${lang?.updateBio}")),

                  const SizedBox(
                    height: 5,
                  ),
                  Text("${controller.bioCrtl.text.length}/120",
                      style: TextStyle(
                          color: controller.bioCrtl.text.length >= 120
                              ? Colors.red
                              : Colors.black))
                  // const Text("Je suis",
                  //     style: TextStyle(
                  //       color: MAIN_COLOR,
                  //     )).marginOnly(bottom: 8),
                  // CheckboxListTile(
                  //   value: controller.user.value?.gender == "male",
                  //   onChanged: (bool? value) =>
                  //       controller.user.value?.gender = "male",
                  //   title: const Text('Un homme'),
                  //   activeColor: MAIN_COLOR,
                  // ),
                  // CheckboxListTile(
                  //   value: controller.user.value?.gender == "female",
                  //   activeColor: MAIN_COLOR,
                  //   onChanged: (bool? value) =>
                  //       controller.user.value?.gender = "female",
                  //   title: const Text('Une femme'),
                  // ),
                ],
              ),
            ),
          )),
    );
  }

  _decoration(String s) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      hintText: s,
      hintStyle: const TextStyle(color: DARK_COLOR, fontFamily: "Haylard"),
      fillColor: Colors.white,
      filled: true,
      errorStyle: const TextStyle(color: Colors.redAccent),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.redAccent)),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: MAIN_COLOR)),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: DARK_COLOR)),
    );
  }
}
