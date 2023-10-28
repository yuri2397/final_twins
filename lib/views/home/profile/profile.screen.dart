import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("ACTIVE: ${controller.user.value?.active}");
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: MAIN_COLOR,
          onRefresh: () => Future.sync(() async => await controller.profile()),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: Get.width,
                          color: MAIN_COLOR,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: NEUTRAL_COLOR),
                                    borderRadius: BorderRadius.circular(100)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    (controller.user.value?.profilePhoto !=
                                                null &&
                                            controller
                                                    .user.value?.profilePhoto !=
                                                "")
                                        ? controller.user.value!.profilePhoto!
                                        : "https://img.freepik.com/photos-gratuite/jeune-femme-chien-sans-abri-au-parc-photo-haute-qualite_144627-75703.jpg?w=740&t=st=1694874615~exp=1694875215~hmac=eb6804b67c1fc7b677babff8be1caaee8f4b47db541f6cfeb548f472371d555d",
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Get.toNamed(Goo.addFilesScreen),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 16,
                                      child: Icon(Icons.add_a_photo,
                                          color: MAIN_COLOR, size: 18),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${controller.user.value?.fullName}, ${controller.user.value?.age}",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    determinerSigne(
                            controller.user.value?.birthDate ?? DateTime.now())
                        .nom,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.circle, color: MAIN_COLOR, size: 15),
                          const Text("A propos de vous",
                              style: TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 18,
                              )).marginOnly(left: 10),
                        ],
                      ),
                      Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            controller.user.value?.bio ?? 'bio',
                            style: const TextStyle(color: DARK_COLOR),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.circle, color: MAIN_COLOR, size: 15),
                          const Text("Mes infos personnelles",
                              style: TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 18,
                              )).marginOnly(left: 10),
                        ],
                      ),
                      Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text("Email",
                                    style: TextStyle(
                                      color: DARK_COLOR,
                                      fontSize: 18,
                                    )),
                                trailing: Text(
                                  "${controller.user.value?.email}",
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontFamily: "Haylard",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListTile(
                                title: const Text("Ville",
                                    style: TextStyle(
                                      color: DARK_COLOR,
                                      fontSize: 18,
                                    )),
                                trailing: Text(
                                  "${controller.user.value?.address}",
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontFamily: "Haylard",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListTile(
                                title: const Text("Sexe :",
                                    style: TextStyle(
                                      color: DARK_COLOR,
                                      fontSize: 16,
                                    )),
                                trailing: Text(
                                  controller.user.value?.gender == 'male'
                                      ? 'Homme'
                                      : 'Femme',
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontFamily: "Haylard",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListTile(
                                title: const Text("Date de naiss : ",
                                    style: TextStyle(
                                      color: DARK_COLOR,
                                      fontSize: 16,
                                    )),
                                trailing: Text(
                                  DateFormat.yMMMd('fr').format(
                                      controller.user.value?.birthDate ??
                                          DateTime.now()),
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontFamily: "Haylard",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.circle, color: MAIN_COLOR, size: 15),
                          const Text("Mon compte",
                              style: TextStyle(
                                color: MAIN_COLOR,
                                fontSize: 18,
                              )).marginOnly(left: 10),
                        ],
                      ),
                      Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () => controller.logout(),
                                title: const Text("Se déconnecter",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 18,
                                    )),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_sharp),
                              ),
                              if (controller.user.value?.active != "1")
                                ListTile(
                                    onTap: () => controller.disabledAccount(),
                                    title: const Text("Activer le compte",
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 18,
                                        )),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_sharp)),
                              if (controller.user.value?.active == "1")
                                ListTile(
                                    onTap: () => controller.disabledAccount(),
                                    title: const Text("Désactiver le compte",
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 18,
                                        )),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_sharp)),
                              ListTile(
                                  onTap: () => controller.removeAccount(),
                                  title: const Text("Supprimer le compte",
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 18,
                                      )),
                                  trailing: GestureDetector(
                                    child: const Icon(
                                        Icons.arrow_forward_ios_sharp),
                                  )),
                            ],
                          )),
                    ],
                  ).paddingSymmetric(horizontal: 20)
                ],
              ),
            ),
          ),
        ));
  }

  _previewChoosedImage(XFile file) {
    var loader = false.obs;
    Get.bottomSheet(
        Obx(
          () => Container(
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
                      File(file.path),
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
                      icon: const Icon(Icons.check_circle),
                      onPressed: () async {
                        loader.value = true;
                        loader.refresh();
                        await controller.updateProfilePhoto(file);
                        loader.value = false;
                        loader.refresh();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: MAIN_COLOR,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      label: loader.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text("Valider"),
                    ).marginOnly(right: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.pink,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      label: const Text("Annuler"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        isScrollControlled: true,
        isDismissible: false);
  }
}
