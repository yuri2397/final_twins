import 'package:get/get.dart';
import 'package:twinz/core/model/chat.dart';
import 'package:twinz/core/repository/chat.repository.dart';

class ChatService extends GetxService {
  final _repo = ChatRepository();

  Future<List<Chat>> chats() async {
    try {
      return await _repo.chats();
    } catch (e) {
      rethrow;
    }
  }

  Future<Chat> chatDetails({required Chat chat}) async {
    try {
      return await _repo.chatDetails(chat: chat);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> remove({required Chat chat}) async{
    try {
      return await _repo.remove(chat: chat);
    } catch (e) {
      rethrow;
    }
  }

  Future<Message> sendMessage(
      {required Chat chat, required String message}) async {
    try {
      return await _repo.sendMessage(chat: chat, message: message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repo.markAsRead(id);
    } catch (e) {
      rethrow;
    }
  }
}
