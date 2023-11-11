import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/search.controller.dart' as sc;
import 'package:twinz/core/config/env.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/views/home/search/search_item.dart';

class SearchScreen extends GetView<sc.SearchController> {
  SearchScreen({super.key});

  final drawerKey = GlobalKey<DrawerControllerState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: const Icon(Icons.menu, color: Colors.white),
          ),
          title: Image.asset(
            Env.whiteLogo,
            width: 60,
          ),
        ),
        drawer: drawer(drawerKey: drawerKey, scaffoldKey: scaffoldKey),
        body: SafeArea(
          child: Obx(() => controller.matchLoad.value
              ? const Center(
                  child: CircularProgressIndicator(color: MAIN_COLOR),
                )
              : controller.user.value?.active == "1"
                  ? controller.matchSuccess.value
                      ? Matcher(controller: controller)
                      : controller.user.value?.isPremium == false && controller.updateSettings.value
                          ? Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Vous avez atteint la limite de suggestions de profils, passez à Twinz Premium pour en voir davantage ou patientez 48h.",
                                      textAlign: TextAlign.center,
                                    ).marginSymmetric(horizontal: 20),
                                    ElevatedButton(
                                            onPressed: () =>
                                                Get.toNamed(Goo.offerScreen),
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: MAIN_COLOR,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        color: Colors.white,
                                                        width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            child: const Text(
                                                "Passez à Twinz Premium "))
                                        .marginOnly(top: 20),
                                  ]),
                            )
                          : Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Oups !!",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Haylard",
                                                fontWeight: FontWeight.w700))
                                        .marginOnly(bottom: 10),
                                    const Text(
                                      "Aucun match trouvé. Merci de\nrevoir vos paramètres.",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: Get.width * .5,
                                      child: ElevatedButton(
                                          onPressed: () =>
                                              Get.toNamed(Goo.settingScreen),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: MAIN_COLOR,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      color: Colors.white,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          child: const Text("Réglages")),
                                    ).marginOnly(top: 20),
                                  ]),
                            )
                  : _activeAccount()),
        ));
  }

  Center _activeAccount() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Oups !!",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Haylard",
                        fontWeight: FontWeight.w700))
                .marginOnly(bottom: 10),
            const Text(
              "Votre compte a été désactiver.\n Veuillez réactiver votre compte pour continuer.",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: Get.width * .5,
              child: ElevatedButton(
                  onPressed: () => controller.activeAccount(),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: MAIN_COLOR,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text("Activer mon compte")),
            ).marginOnly(top: 20),
          ]),
    );
  }
}

class Matcher extends StatelessWidget {
  final _index = 0.obs;

  Matcher({
    super.key,
    required this.controller,
  });

  final sc.SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (controller.currentMatch.isNotEmpty)
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  controller.currentMatch[_index.value].photosCount ?? 0,
                  (index) =>
                      const Icon(Icons.circle, color: MAIN_COLOR, size: 6)
                          .marginSymmetric(horizontal: 6)),
            ).marginSymmetric(vertical: 10),
          ),
        Expanded(
          child: AppinioSwiper(
            swipeOptions:
                const AppinioSwipeOptions.only(left: true, right: true),
            unlimitedUnswipe: true,
            controller: controller.swiperController,
            backgroundCardsCount: 0,
            onSwipeCancelled: () {
              controller.showCancelIcon.value = false;
              controller.showLikeIcons.value = false;
            },
            onSwipe: (index, direction) {
              _index.value = index;
              controller.swipe(index, direction);
            },
            unswipe: (value) {
              if (value) {
                _index.value--;
              }
            },
            onSwiping: (AppinioSwiperDirection direction) {
              if (direction == AppinioSwiperDirection.left) {
                controller.onSwipLeft();
              } else if (direction == AppinioSwiperDirection.right) {
                controller.onSwipRight();
              }
            },
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            cardsCount: controller.currentMatch.length,
            cardsBuilder: (BuildContext context, int index) {
              return Obx(() => SearchItemWidget(
                    user: controller.currentMatch[index],
                    showCancelIcon: controller.showCancelIcon.value,
                    showLikeIcons: controller.showLikeIcons.value,
                  ));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => controller.onCancel(controller.visibleUser.value),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.pink,
                  size: 35,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => controller.onSwipBack(controller.visibleUser.value),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(
                  Icons.undo,
                  color: Colors.orange,
                  size: 25,
                ),
              ),
            ).marginOnly(top: 10),
            Obx(
              () => GestureDetector(
                onTap: () => controller.onLike(controller.visibleUser.value),
                child: controller.likeLoad.value
                    ? const CircularProgressIndicator(
                        color: MAIN_COLOR,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: MAIN_COLOR,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 20,
                              offset: const Offset(
                                  2, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Image.asset(
                          Env.whiteLogo,
                          width: 50,
                        ),
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
