import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

final ImagePicker _picker = ImagePicker();

Future<XFile?> imageFromGallery() async {
  return await _picker.pickImage(source: ImageSource.gallery);
}

Future<XFile?> imageFromCamera() async {
  return await _picker.pickImage(source: ImageSource.camera);
}

Future<XFile?> takeImage() async {
  XFile? file;
  await Get.bottomSheet(Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            file = await imageFromCamera();
            Get.back();
          },
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: MAIN_COLOR,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ).marginOnly(right: 10),
               Text(
                "${lang?.takeNewPhotoFromCamera}",
                style:const TextStyle(
                    fontFamily: "Haylard",
                    fontSize: 18,
                    color: DARK_COLOR,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            file = await imageFromGallery();
            Get.back();
          },
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: MAIN_COLOR,
                child: Icon(Icons.image, color: Colors.white),
              ).marginOnly(right: 10),
               Text(
                "${lang?.takeNewPhotoFromGallery}",
                style: const TextStyle(
                    fontFamily: "Haylard",
                    fontSize: 18,
                    color: DARK_COLOR,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        )
      ],
    ),
  ));

  return file;
}
