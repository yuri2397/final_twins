import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinz/controllers/chat.controller.dart' as lc;
import 'package:twinz/controllers/search.controller.dart' as sc;
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:chatview/chatview.dart' as hc;

class ChatScreen extends GetView<lc.ChatController> {
  ChatScreen({super.key});

  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 1);

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) => Obx(
        () => Scaffold(
            appBar: AppBar(
                backgroundColor: MAIN_COLOR,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                actions: [
                  PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (item) => controller.moreInfo(item),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                          onTap: () =>
                              Get.find<sc.SearchController>().searchDetails(
                                controller.currentChat.value.participants!
                                    .firstWhere((e) =>
                                        e.id.toString() != currentUserId),
                              ),
                          value: 0,
                          child: const Text('Voir le profil')),
                      PopupMenuItem<int>(
                          value: 1,
                          child: const Text('Bloquer'),
                          onTap: () => controller.blockUser(
                                controller.currentChat.value.participants!
                                    .firstWhere((e) =>
                                        e.id.toString() != currentUserId),
                              )),
                      PopupMenuItem<int>(
                          value: 2,
                          child: const Text('Signaler'),
                          onTap: () => controller.reportUser(
                                controller.currentChat.value.participants!
                                    .firstWhere((e) =>
                                        e.id.toString() != currentUserId),
                              )),
                    ],
                  )
                ],
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(25),
                    child: Text(
                        controller.currentChat.value.participants
                                ?.firstWhere(
                                    (e) => e.id.toString() != currentUserId)
                                .fullName ??
                            'Chargement...',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16))),
                title: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: controller.currentChat.value.participants
                              ?.firstWhere(
                                  (e) => e.id.toString() != currentUserId)
                              .profilePhoto ==
                          null
                      ? Image.asset("assets/images/avataaars.png",
                          width: 50, height: 50, fit: BoxFit.fill)
                      : Image.network(
                          "${controller.currentChat.value.participants?.firstWhere((e) => e.id.toString() != currentUserId).profilePhoto}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill),
                )),
            body: controller.showDetailsLoad.value
                ? const Center(
                    child: CircularProgressIndicator(color: MAIN_COLOR),
                  )
                : Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        controller: scrollController,
                        itemCount: controller.messages.length,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return BubbleSpecialThree(
                            text: controller.messages[index].message,
                            color: controller.messages[index].sendBy ==
                                    currentUserId
                                ? MAIN_COLOR
                                : GRAY_COLOR,
                            tail: false,
                            sent: controller.messages[index].status ==
                                hc.MessageStatus.delivered,
                            isSender: controller.messages[index].sendBy ==
                                currentUserId,
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ).marginOnly(bottom: 10);
                        },
                      )),
                      MessageBar(
                        onSend: (text) => controller.onSendTap(text),
                        sendButtonColor: MAIN_COLOR,
                        messageBarHitText: "Votre message",
                      ),
                    ],
                  )),
      );
}
