import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twinz/core/model/chat.dart' as lc;
import 'package:twinz/core/services/chat.service.dart';
import 'package:twinz/core/services/user.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:twinz/routes/router.dart';
import 'package:chatview/chatview.dart' as hc;
import 'package:twinz/shared/utils/colors.dart';

import '../core/model/user.dart';

class ChatController extends GetxController {
  final messages = <hc.Message>[].obs;
  final _localUser = localStorage.getUser();

  get localUser => _localUser;
  final RxList<lc.Chat> chats = localStorage.getMessages().obs;
  final chatsLoad = false.obs;
  final unblockLoad = false.obs;

  final _service = Get.find<ChatService>();

  final currentChat = lc.Chat().obs;
  final showDetailsLoad = false.obs;
  final textFieldController = TextEditingController();
  hc.ChatController chatController = hc.ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    chatUsers: [],
  );

  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getChats();
  }

  Future<void> getChats() async {
    chatsLoad.value = true;
    await _service.chats().then((value) {
      chats.value = value;
      chats.refresh();
      localStorage.messages = chats;
      chatsLoad.value = false;
    }).catchError((e) {
      print("$e");
    });
  }

  detailsChat(lc.Chat chat) {
    currentChat.value = chat;
    showDetailsLoad.value = true;
    _service.chatDetails(chat: chat).then((value) {
      currentChat.value = value;
      messages.value = value.messages!
          .map((e) => hc.Message(
              id: "${e.id}",
              message: "${e.message}",
              createdAt: value.createdAt!,
              status: "${e.data?.status}" == 'send'
                  ? hc.MessageStatus.delivered
                  : hc.MessageStatus.read,
              sendBy: "${e.sender?.id}"))
          .toList();
      showDetailsLoad.value = false;
    }).catchError((e) {
      showDetailsLoad.value = false;
    });
    Get.toNamed(Goo.chatScreen, parameters: {'chat_id': chat.id.toString()});
  }

  void appendMessageInDiscussion(String message) {
    final id = DateTime.now().millisecondsSinceEpoch;
    messages.add(
      hc.Message(
        id: id.toString(),
        createdAt: DateTime.now(),
        message: message,
        sendBy: "-1",
        status: hc.MessageStatus.pending,
      ),
    );
  }

  Future<void> onSendTap(
    String message,
  ) async {
    if (message.isEmpty) return;
    final id = DateTime.now().millisecondsSinceEpoch;
    messages.add(
      hc.Message(
        id: id.toString(),
        createdAt: DateTime.now(),
        message: message,
        sendBy: currentUserId,
        status: hc.MessageStatus.pending,
      ),
    );
    messageController.clear();
    _service
        .sendMessage(chat: currentChat.value, message: message)
        .then((value) {
      getChats();
    }).catchError((e) {
      print("$e");
      getChats();
    });
  }

  Future<void> unblockUser(User user) async {
    unblockLoad.value = true;
    Get.find<UserService>().unblockUser(user: user).then((value) {
      unblockLoad.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("Vous avez débloqué ${user.fullName}"),
        backgroundColor: MAIN_COLOR,
      ));
      reloadChatCurrentChat();
    }).catchError((e) {
      unblockLoad.value = false;
    });
  }

  reloadChatCurrentChat() {
    showDetailsLoad.value = true;
    _service.chatDetails(chat: currentChat.value).then((value) {
      currentChat.value = value;
      messages.value = value.messages!
          .map((e) => hc.Message(
              id: "${e.id}",
              message: "${e.message}",
              createdAt: value.createdAt!,
              status: "${e.data?.status}" == 'send'
                  ? hc.MessageStatus.delivered
                  : hc.MessageStatus.read,
              sendBy: "${e.sender?.id}"))
          .toList();
      showDetailsLoad.value = false;
    }).catchError((e) {
      showDetailsLoad.value = false;
    });
  }

  Future<void> blockUser(User user) async {
    showDetailsLoad.value = true;
    Get.find<UserService>().blockUser(user: user).then((value) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("Vous avez bloqué ${user.fullName}"),
        backgroundColor: MAIN_COLOR,
      ));
      showDetailsLoad.value = false;
      reloadChatCurrentChat();
    }).catchError((e) {
      showDetailsLoad.value = false;
    });
  }

  Future<void> reportUser(User user) async {
    // add raison in a bottomsheet

    final raisonController = TextEditingController();
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Raison du signalement",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: raisonController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Raison du signalement",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: MAIN_COLOR,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: MAIN_COLOR),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Annuler"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: MAIN_COLOR,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Get.find<UserService>()
                          .reportUser(
                              user: user, raison: raisonController.text.trim())
                          .then((value) {
                        getChatMessages();
                        Get.back();
                        Get.back();
                        ScaffoldMessenger.of(Get.context!)
                            .showSnackBar(SnackBar(
                          content: Text("Vous avez signalé ${user.fullName}"),
                          backgroundColor: MAIN_COLOR,
                        ));
                      }).catchError((e) {
                        getChatMessages();
                        Get.back();
                        Get.back();
                      });
                    },
                    child: const Text("Signaler"),
                  ),
                ],
              ),
            ],
          ),
        ),
        isScrollControlled: true);
  }

  markMessageIsRead(messageId) {
    _service.markAsRead(messageId).then((value) {});
  }

  moreInfo(int index) {}

  getChatMessages() {}

  Future<void> deleteChat(lc.Chat value, String? fullName) async {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Attention !",
              style: TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 10,
          ),
          Text("Êtes-vous sûr(e) de vouloir supprimer $fullName ?",
              style: const TextStyle(
                  color: DARK_COLOR,
                  fontFamily: "Haylard",
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: DARK_COLOR,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                    showDetailsLoad.value = true;
                    _service.remove(chat: value).then((value) {
                      getChats();
                      Get.back();
                    }).catchError((e) {
                      showDetailsLoad.value = true;
                    });
                  },
                  child: const Text("Supprimer")),
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Annuler")),
            ],
          )
        ],
      ),
    ));
  }
}
