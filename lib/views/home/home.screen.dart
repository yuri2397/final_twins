import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:twinz/controllers/chat.controller.dart';
import 'package:twinz/controllers/home.controller.dart';
import 'package:twinz/controllers/notification.controller.dart';
import 'package:twinz/core/services/notification.service.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/views/home/chats/chat_list.screen.dart';
import 'package:twinz/views/home/notifications/notifications.screen.dart';
import 'package:twinz/views/home/profile/profile.screen.dart';
import 'package:twinz/views/home/search/search.screen.dart' as sc;
// search controller as scc

import 'package:twinz/controllers/search.controller.dart' as scc;

class HomeScreen extends GetView<HomeController> {
  final _screens = <Widget>[
    sc.SearchScreen(),
    NotificationsScreen(),
    ChatListScreen(),
    const ProfileScreen()
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _screens[controller.currentIndex.value],
        bottomNavigationBar: SafeArea(
          child: Container(
            color: MAIN_COLOR,
            height: 65,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: NavigationBar(
              onDestinationSelected: (int index) {},
              selectedIndex: controller.currentIndex.value,
              backgroundColor: Colors.white,
              destinations: <Widget>[
                GestureDetector(
                  onTap: () {
                    Get.find<scc.SearchController>().getMatchings();
                    controller.currentIndex.value = 0;
                    controller.currentIndex.refresh();
                  },
                  child: ImageIcon(
                    const AssetImage('assets/images/home.png'),
                    color: controller.currentIndex.value == 0
                        ? MAIN_COLOR
                        : Colors.grey[400],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.currentIndex.value = 1;
                    Get.find<NotificationController>().haveUnreadNotification.value = false;
                    Get.find<NotificationService>().markAllRead();
                    controller.currentIndex.refresh();
                  },
                  child: !Get.find<NotificationController>().haveUnreadNotification.value
                      ? Icon(Icons.notifications,
                          color: controller.currentIndex.value == 1
                              ? MAIN_COLOR
                              : Colors.grey[400])
                      : SvgPicture.asset(
                          "assets/icons/unread.svg",
                          width: 23,
                          height: 23,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.currentIndex.value = 2;
                    controller.currentIndex.refresh();
                    Get.find<NotificationController>().haveUnreadMessage.value = false;
                    Get.find<ChatController>().getChats();
                  },
                  child: !Get.find<NotificationController>().haveUnreadMessage.value
                      ? Icon(CupertinoIcons.chat_bubble_2_fill,
                          color: controller.currentIndex.value == 2
                              ? MAIN_COLOR
                              : Colors.grey[400])
                      : SvgPicture.asset(
                          'assets/icons/unreadMessage.svg',
                          width: 23,
                          height: 23,
                        ),
                ),
                GestureDetector(
                    onTap: () {
                      controller.currentIndex.value = 3;
                      controller.currentIndex.refresh();
                    },
                    child: Icon(CupertinoIcons.person_fill,
                        color: controller.currentIndex.value == 3
                            ? MAIN_COLOR
                            : Colors.grey[400])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
