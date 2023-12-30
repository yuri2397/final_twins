import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinz/components/choose_files.widget.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/controllers/register.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class AddFilesRegisterScreen extends GetView<RegisterController> {
  const AddFilesRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Container(
            height: Get.height,
            width: Get.width,
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${lang?.addPhotos}",
                          style: const TextStyle(
                              color: DARK_COLOR,
                              fontSize: 30,
                              fontFamily: "Haylard",
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          childAspectRatio: 14 / 20,
                          children: controller.files
                              .map((element) => _buildItem(element))
                              .toList(),
                        )
                      ],
                    )),
                SizedBox(
                  width: Get.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MAIN_COLOR,
                        foregroundColor: Colors.white),
                    onPressed: controller.files
                                .firstWhere((e) => e.value.path.isNotEmpty,
                                    orElse: () => XFile("").obs)
                                .value
                                .path
                                .isEmpty ==
                            true
                        ? null
                        : () => Get.toNamed(Goo.addBioScreen),
                    child: Text("${lang?.next}",
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ).paddingAll(20),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Rx<XFile> file) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: GRAY_COLOR, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white),
        child: Stack(
          children: [
            file.value.path.isNotEmpty
                ? Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(file.value.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    color: GRAY_COLOR,
                  ),
            Positioned(
              bottom: 5,
              right: 5,
              child: file.value.path.isEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (controller.showFilesMessage.value) {
                          await showGeneralDialog(
                            context: Get.context!,
                            barrierLabel: "Barrier",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            pageBuilder: (_, __, ___) {
                              return Center(
                                child: Container(
                                  height: 240,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: SizedBox.expand(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.back(),
                                        child: itemIcon(Icons.close,
                                            color: Colors.pink),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                       Text(
                                          "${lang?.addPhotoMark}",
                                          textAlign: TextAlign.center,
                                          style:const TextStyle(
                                              color: DARK_COLOR,
                                              fontSize: 22,
                                              fontFamily: "Haylard",
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ).paddingAll(10)),
                                ),
                              );
                            },
                          );
                          controller.showFilesMessage.value = false;
                          controller.showFilesMessage.refresh();
                        }
                        file.value = await takeImage() ?? XFile("");
                        file.refresh();
                      },
                      child: const CircleAvatar(
                        backgroundColor: MAIN_COLOR,
                        radius: 14,
                        child: Icon(Icons.add, color: Colors.white, size: 15),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => _editFile(file),
                      child: const CircleAvatar(
                        backgroundColor: MAIN_COLOR,
                        radius: 14,
                        child: Icon(Icons.edit, color: Colors.white, size: 15),
                      ),
                    ),
            )
          ],
        ));
  }

  _editFile(Rx<XFile> file) {
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: Get.height * .5,
                  child: Image.file(
                    File(file.value.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  file.value = XFile("");
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.pink,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                label:  Text("${lang?.delete}"),
              ),
            ],
          ),
        ),
        isScrollControlled: true);
  }
}
