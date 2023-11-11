import 'package:get/get.dart';
import 'package:twinz/core/http/http_client.dart';
import 'package:twinz/core/model/chat.dart';
import 'package:twinz/core/model/user.dart';

class ChatRepository {
  final _client = Get.find<HttpClient>();

  Future<List<Chat>> chats() async {
    try {
      var response = await _client.get("/chat");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map) {
          return [];
        }
        return List<Chat>.from(response.data.map((e) => Chat.fromJson(e)));
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Chat> chatDetails({required Chat chat}) async {
    try {
      var response = await _client.get("/chat/${chat.id}");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Chat.fromJson(response.data);
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Message> sendMessage(
      {required Chat chat, required String message}) async {
    try {
      var response = await _client.post("/chat/send-msg",
          data: {"chat_id": chat.id, "message": message});
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Message.fromJson(response.data);
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _client.post("/chat/msg-status/$id");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> remove({required Chat chat}) async {
    try {
      var response = await _client.delete("/chat/${chat.id}");
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw response.data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
