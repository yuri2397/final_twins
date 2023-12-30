import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twinz/controllers/notification.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class NotificationDetailsScreen extends GetView<NotificationController> {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title:  Text("${lang?.requestChat}"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: controller.detailsLoad.value
              ? const Center(
                  child: CircularProgressIndicator(color: MAIN_COLOR),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: Get.height * .55,
                        width: Get.width,
                        child: Image.network(
                          "${controller.visibleUser.value.profilePhoto}",
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${controller.visibleUser.value.fullName}, ${controller.visibleUser.value.age}"
                              .capitalizeFirst ??
                          "",
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: MAIN_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: Text(
                          DateFormat.MMMMd(Localizations.localeOf(Get.context!)
                              .languageCode).format(
                              controller.visibleUser.value.birthDate ??
                                  DateTime.now()),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(controller.visibleUser.value.bio ?? 'Bio',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                            color: DARK_COLOR,
                            fontSize: 18,
                            fontFamily: "Haylard")),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.pink,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6))),
                            onPressed: controller.rejectLoad.value
                                ? null
                                : () => controller.rejectRequest(int.tryParse(
                                        "${controller.selectedNotification.value.data?.data?.requestId}") ??
                                    -1,controller.selectedNotification.value.id ?? ""   ),
                            child: controller.rejectLoad.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  )
                                :  Text("${lang?.reject}")),
                        ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: MAIN_COLOR,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6))),
                            onPressed: controller.acceptLoad.value
                                ? null
                                : () => controller.acceptRequest(int.tryParse(
                                        "${controller.selectedNotification.value.data?.data?.requestId}") ??
                                    -1, controller.selectedNotification.value.id ?? ""   ),
                            child: controller.acceptLoad.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white,),
                                  )
                                :  Text("${lang?.acceptRequest}")),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
