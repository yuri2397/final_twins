import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/register.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class AddBioScreen extends GetView<RegisterController> {
  AddBioScreen({super.key});
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
        body: Obx(
          () => Container(
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
                    const Text(
                      "Ajoutez une bio",
                      style: TextStyle(
                          color: DARK_COLOR,
                          fontSize: 30,
                          fontFamily: "Haylard",
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: _form,
                      child: SizedBox(
                        width: Get.width,
                        child: TextFormField(
                          autofocus: true,
                          controller: controller.bioCtrl,
                          keyboardType: TextInputType.multiline,
                          inputFormatters:[
                            UpperCaseTextFormatter()
                          ],
                          cursorColor: DARK_COLOR,
                          obscureText: false,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null) {
                              return "Veuillez saissir votre bio.";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 16),
                              color: DARK_COLOR),
                          decoration: decoration("Ecrire"),
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
                        controller.save();
                      }
                    },
                    child: controller.loading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : const Text("C'est parti",
                            style: TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ).paddingAll(20),
          ),
        ));
  }
}
