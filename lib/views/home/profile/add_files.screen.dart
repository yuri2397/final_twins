import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinz/components/choose_files.widget.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class AddFilesScreen extends GetView<ProfileController> {
  const AddFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MAIN_COLOR,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          color: MAIN_COLOR,
          onRefresh: () => Future.sync(() async => controller.photos()),
          child: SingleChildScrollView(
            child: Container(
              height: Get.height,
              width: Get.width,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "${lang?.addPhotos}",
                            style:const TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 30,
                                fontFamily: "Haylard",
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            childAspectRatio: 14 / 20,
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            children: controller.files
                                .map((element) => _buildItem(element))
                                .toList(),
                          )
                        ],
                      )),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: Get.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: MAIN_COLOR,
                            foregroundColor: Colors.white),
                        onPressed: () => controller.addPhotos(),
                        child: controller.addPhotoLoad.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            :  Text("${lang?.save}"),
                      ),
                    ),
                  )
                ],
              ).paddingAll(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Rx<XFile> file) {
    return Obx(
      () => Container(
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
                          child:
                              Icon(Icons.edit, color: Colors.white, size: 15),
                        ),
                      ),
              )
            ],
          )),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      Get.back();
                      file.value = await takeImage() ?? XFile("");
                      file.refresh();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: MAIN_COLOR,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    label:  Text("${lang?.update}"),
                  ).marginOnly(right: 10),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    label:  Text("${lang?.delete}"),
                  ),
                ],
              )
            ],
          ),
        ),
        isScrollControlled: true);
  }
}
