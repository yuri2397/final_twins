import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/chat.controller.dart';
import 'package:twinz/core/model/chat.dart';
import 'package:twinz/core/model/chat_request.dart';
import 'package:twinz/core/model/user.dart';
import 'package:twinz/core/services/chat_request.service.dart';
import 'package:twinz/core/services/matching.service.dart';
import 'package:twinz/core/services/notification.service.dart';
import 'package:twinz/core/model/notification.dart' as nt;
import 'package:twinz/core/services/user.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';

class NotificationController extends GetxController {
  final items = <nt.Notification>[].obs;
  final loading = false.obs;
  final _service = Get.find<NotificationService>();
  final haveUnreadNotification = false.obs;
  final haveUnreadMessage = false.obs;
  final selectedNotification = nt.Notification().obs;
  final _matchingService = Get.find<MatchingService>();
  final detailsLoad = false.obs;
  final visibleUser = User().obs;
  final acceptLoad = false.obs;
  final rejectLoad = false.obs;
  final _requestService = Get.find<ChatRequestService>();

  @override
  void onInit() {
    super.onInit();
    //_service.markAllRead();
    _service.countUnread().then((value) {
      print("UNREAD NOTIFICATION: $value");
      haveUnreadNotification.value = value > 0;
    }).catchError((e) {
      print("UNREAD $e");
    });
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    loading.value = true;
    await _service.index().then((value) {
      items.value = value;
      items.refresh();
      loading.value = false;
    }).catchError((e, s) {
      print("$e");
      print("$s");
      loading.value = false;
    });
  }

  Future<void> acceptRequest(int requestId, String notId) async {
    acceptLoad.value = true;
    _requestService
        .acceptRequestChat(
            chatRequest: ChatRequest(id: requestId), notId: notId)
        .then((value) {
      acceptLoad.value = false;
      fetchNotifications();
      Get.find<ChatController>().getChats();
      successMessage(
          title: "Félicitation", content: "Demande acceptée avec succès.");
      Get.find<ChatController>().detailsChat(Chat(id: value));
    }).catchError((e) {
      acceptLoad.value = false;
    });
  }

  Future<void> rejectRequest(int requestId, String notId) async {
    rejectLoad.value = true;
    _requestService
        .rejectRequestChat(
            chatRequest: ChatRequest(id: requestId), notId: notId)
        .then((value) {
      rejectLoad.value = false;

      Get.back();
      successMessage(
          title: "Félicitation", content: "Demande rejetée avec succès.");
    }).catchError((e) {
      rejectLoad.value = false;
      print("REJECT REQUEST ERROR: $e");
    });
  }

  Future<void> markAsRead(String id) async {
    _service.markAsRead(id: id).then((value) {
      items.removeWhere((element) => element.id == id);
      items.refresh();
    });
  }

  detailUserNot(nt.Notification item) {
    selectedNotification.value = item;
    if(localStorage.getUser()?.isPremium == false){
      Get.toNamed(Goo.offerScreen);
    }else{
        fetchNotificationDetails();
        Get.toNamed(Goo.notificationDetails);
    }
  }

  void fetchNotificationDetails() async {
    detailsLoad.value = true;
    var id = int.tryParse("${selectedNotification.value.data!.data!.userId}");
    _matchingService.matchingDetails(user: User(id: id)).then((value) {
      visibleUser.value = value;
      detailsLoad.value = false;
    }).catchError((e) {
      detailsLoad.value = false;
    });
  }

  requestAccepted(nt.Notification item) {
    selectedNotification.value = item;
    if (item.data?.data?.type == 'request_accepted') {
      var id =
      int.tryParse("${selectedNotification.value.data!.data!.chatId}");
      Get.find<ChatController>().detailsChat(Chat(id: id));
    }
  }
}
