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

  final _service = Get.find<ChatService>();

  final currentChat = lc.Chat().obs;
  final showDetailsLoad = false.obs;
  final textFieldController = TextEditingController();
  hc.ChatController chatController = hc.ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    chatUsers: [],
  );

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
    _service
        .sendMessage(chat: currentChat.value, message: message)
        .then((value) {
      getChats();
    }).catchError((e) {
      print("$e");
      getChats();
    });
  }

  Future<void> blockUser(User user) async {
    Get.find<UserService>().blockUser(user: user).then((value) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("Vous avez bloqué ${user.fullName}"),
        backgroundColor: MAIN_COLOR,
      ));
    }).catchError((e) {});
  }

  Future<void> reportUser(User user) async {
    Get.find<UserService>().reportUser(user: user).then((value) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text("Vous avez signalé ${user.fullName}"),
        backgroundColor: MAIN_COLOR,
      ));
    }).catchError((e) {});
  }

  markMessageIsRead(messageId) {
    _service.markAsRead(messageId).then((value) {});
  }

  moreInfo(int index) {}

  getChatMessages() {}
}
