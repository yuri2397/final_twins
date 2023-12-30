import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
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
                          child: Text("${lang?.viewProfile}")),
                      PopupMenuItem<int>(
                          value: 1,
                          child: Text("${lang?.block}"),
                          onTap: () => controller.blockUser(
                                controller.currentChat.value.participants!
                                    .firstWhere((e) =>
                                        e.id.toString() != currentUserId),
                              )),
                      PopupMenuItem<int>(
                          value: 2,
                          child: Text("${lang?.report}"),
                          onTap: () => controller.reportUser(
                                controller.currentChat.value.participants!
                                    .firstWhere((e) =>
                                        e.id.toString() != currentUserId),
                              )),
                      PopupMenuItem<int>(
                          value: 3,
                          child: Text(
                            '${lang?.delete}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          onTap: () => controller.deleteChat(
                              controller.currentChat.value,
                              controller.currentChat.value.participants
                                  ?.firstWhere(
                                      (e) => e.id.toString() != currentUserId)
                                  .fullName)),
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
                            '...',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16))),
                title: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: controller.currentChat.value.participants
                              ?.firstWhere(
                                  (e) => e.id.toString() != currentUserId)
                              .profilePhoto ==
                          null
                      ? const CircularProgressIndicator(
                          color: MAIN_COLOR,
                        )
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
                : controller.currentChat.value.blocker != null &&
                        controller.currentChat.value.blocker ==
                            int.tryParse(currentUserId)
                    ? _buildBlocked()
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
                          SafeArea(
                            child: TextFormField(
                              controller: controller.messageController,
                              decoration: InputDecoration(
                                hintText: '${lang?.writeYourMessage}',
                                hintStyle: GoogleFonts.roboto(
                                    color: Colors.grey[400], fontSize: 16),
                                suffixIcon: IconButton(
                                  onPressed: () => controller.onSendTap(
                                      controller.messageController.text.trim()),
                                  icon: const Icon(
                                    Icons.send,
                                    color: MAIN_COLOR,
                                    size: 30,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ).marginSymmetric(horizontal: 20, vertical: 20),
                          )
                        ],
                      )),
      );

  _buildBlocked() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(30),
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
             Text("${lang?.attention}", style:const TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${lang?.cannotSendMessage}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400]),
            ),

            const SizedBox(
              height: 10,
            ),
            // cliquer ici pour débloquer
            GestureDetector(
              onTap: () => controller.unblockUser(
                controller.currentChat.value.participants!
                    .firstWhere((e) => e.id.toString() != currentUserId),
              ),
              child:  Text(
                "${lang?.clickToUnblock}",
                style:const TextStyle(color: MAIN_COLOR),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (controller.unblockLoad.value == true)
              const CircularProgressIndicator(
                color: MAIN_COLOR,
              )
          ])),
    );
  }
}
