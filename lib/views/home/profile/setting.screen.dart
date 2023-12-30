import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:twinz/controllers/profile.controller.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';

class SettingScreen extends GetView<ProfileController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "${lang?.settings}",
                style:const TextStyle(
                    color: MAIN_COLOR,
                    fontSize: 30,
                    fontFamily: "Haylard",
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: MAIN_COLOR,
                    size: 20,
                  ),
                   Text(
                    "${lang?.distance}",
                    style:const TextStyle(
                        color: DARK_COLOR,
                        fontSize: 20,
                        fontFamily: "Haylard",
                        fontWeight: FontWeight.bold),
                  ).marginOnly(left: 10),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SfSlider(
                      min: 1,
                      max: 50,
                      value: double.tryParse(
                              "${controller.settings?.value?.distanceInKilometers ?? 50}") ??
                          50,
                      interval: 20,
                      showTicks: false,
                      activeColor: MAIN_COLOR,
                      showLabels: false,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        controller.settings?.value?.distanceInKilometers =
                            value.toInt();
                        controller.settings?.refresh();
                        localStorage.settings = controller.settings?.value;
                      },
                    ),
                  ),
                  Text("${controller.settings?.value?.distanceInKilometers} Km")
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: MAIN_COLOR,
                    size: 20,
                  ),
                   Text(
                    "${lang?.gap}",
                    style:const TextStyle(
                        color: DARK_COLOR,
                        fontSize: 20,
                        fontFamily: "Haylard",
                        fontWeight: FontWeight.bold),
                  ).marginOnly(left: 10),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SfSlider(
                      min: 0,
                      max: 15,
                      value: double.tryParse(
                              "${controller.settings?.value?.differenceInDays ?? 15}") ??
                          15,
                      showTicks: false,
                      activeColor: MAIN_COLOR,
                      showLabels: false,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        if (controller.user.value?.isPremium == null ||
                            controller.user.value?.isPremium == false) {
                          if (value < 2) {
                            value = 2;
                            showChangeOfferBottomSheet();
                            return;
                          }
                        }
                        controller.settings?.value?.differenceInDays =
                            value.toInt();
                        controller.settings?.refresh();
                        localStorage.settings = controller.settings?.value;
                      },
                    ),
                  ),
                  Text("${controller.settings?.value?.differenceInDays} ${lang?.days}")
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: MAIN_COLOR,
                    size: 20,
                  ),
                   Text(
                    "${lang?.ageBetween}",
                    style:const TextStyle(
                        color: DARK_COLOR,
                        fontSize: 20,
                        fontFamily: "Haylard",
                        fontWeight: FontWeight.bold),
                  ).marginOnly(left: 10),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width - 100,
                    child: SfRangeSlider(
                      min: 18,
                      max: 80,
                      interval: 10,
                      showTicks: false,
                      activeColor: MAIN_COLOR,
                      showLabels: false,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (SfRangeValues values) {
                        controller.settings?.value?.ageMin =
                            values.start?.toInt();
                        controller.settings?.value?.ageMax = values.end?.toInt();
                        controller.settings?.refresh();
                        Get.log(
                            "${controller.settings?.value?.toJson().toString()}");
                        localStorage.settings = controller.settings?.value;
                      },
                      values: SfRangeValues(
                          controller.settings?.value?.ageMin ?? 18,
                          controller.settings?.value?.ageMax ?? 80),
                    ),
                  ),
                  Text(
                      "${controller.settings?.value?.ageMin ?? '18'} - ${controller.settings?.value?.ageMax ?? '80'}")
                ],
              ).marginSymmetric(),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: MAIN_COLOR,
                    size: 20,
                  ),
                   Text(
                    "${lang?.sex}",
                    style:const TextStyle(
                        color: DARK_COLOR,
                        fontSize: 20,
                        fontFamily: "Haylard",
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ).marginOnly(left: 10),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              CheckboxListTile(
                value: controller.settings?.value?.gender == "male",
                onChanged: (bool? value) => controller.changeGender("male"),
                title:  Text("${lang?.male}"),
                activeColor: MAIN_COLOR,
              ),
              CheckboxListTile(
                value: controller.settings?.value?.gender == "female",
                activeColor: MAIN_COLOR,
                onChanged: (bool? value) => controller.changeGender("female"),
                title:  Text("${lang?.female}"),
              ),
              CheckboxListTile(
                value: controller.settings?.value?.gender == null || controller.settings?.value?.gender == "both",
                onChanged: (bool? value) => controller.changeGender("both"),
                activeColor: MAIN_COLOR,
                title:  Text("${lang?.maleAndFemale}"),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: MAIN_COLOR,
                      foregroundColor: Colors.white),
                  onPressed: () => controller.updateSettings(),
                  child: controller.updateSettingsLoad.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white))
                      :  Text("${lang?.save}"),
                ),
              )
            ],
          ).paddingAll(20),
        ),
      ),
    );
  }

  void showChangeOfferBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        width: Get.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "${lang?.premiumRequired}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontSize: 20,
                  fontFamily: "Haylard",
                  fontWeight: FontWeight.bold),
            ).marginSymmetric(horizontal: 10),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                // fermer, Twinz Premium
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.white,
                        foregroundColor: MAIN_COLOR),
                    onPressed: () => Get.back(),
                    child:  Text("${lang?.cancel}"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: MAIN_COLOR,
                        foregroundColor: Colors.white),
                    onPressed: () => Get.toNamed(Goo.offerScreen),
                    child: Text("${lang?.twinzPremium}"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
    );
  }
}
