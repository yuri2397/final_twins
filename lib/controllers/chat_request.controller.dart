import 'package:get/get.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/core/model/chat_request.dart';
import 'package:twinz/core/services/chat_request.service.dart';
import 'package:twinz/core/utils/utils.dart';

class ChatRequestController extends GetxController {
  final items = <ChatRequest>[].obs;
  final loading = false.obs;
  final _service = Get.find<ChatRequestService>();

  @override
  void onInit() async {
    super.onInit();
    receivedRequestChats();
  }

  Future<void> receivedRequestChats() async {
    loading.value = true;
    await _service.receivedRequestChats().then((value) {
      items.value = value;
      items.refresh();
      loading.value = false;
    }).catchError((e, s) {
      loading.value = false;
    });
  }

  Future<void> acceptChatRequest(ChatRequest request, String notId) async {
    await _service.acceptRequestChat(chatRequest: request, notId: notId).then((value) {
      items.removeWhere((element) => element.id == request.id);
      items.refresh();
    }).catchError((e) => errorMessage(title: "${lang?.oups}", content: "$e"));
  }

  Future<void> cancelChatRequest(ChatRequest request) async {
    await _service.cancelRequestChat(chatRequest: request).then((value) {
      items.removeWhere((element) => element.id == request.id);
      items.refresh();
    }).catchError((e) => errorMessage(title: "${lang?.oups}", content: "$e"));
  }
}
