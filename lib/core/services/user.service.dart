import 'package:get/get.dart';
import 'package:twinz/core/model/user.dart';
import 'package:twinz/core/repository/user.repository.dart';
import 'package:twinz/core/utils/utils.dart';

class UserService extends GetxService {
  final _repo = UserRepository();

  Future<User> updateUser(User user) async {
    try {
      return await _repo.update(user: user);
    } catch (e) {
      print("UPDATE ERROR: $e");
      rethrow;
    }
  }

  Future<bool> blockUser({required User user}) async {
    try {
      return await _repo.blockUser(user: user);
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Future<bool> reportUser({required User user, required String raison}) async {
    try {
      return await _repo.reportUser(user: user, raison: raison);
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Future<bool> unblockUser({required User user}) async {
    try {
      return await _repo.unblockUser(user: user);
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Future<bool> enableAccount() async {
    try {
      return await _repo.enableAccount();
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Future<bool> disableAccount() async {
    try {
      return await _repo.disableAccount();
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      return await _repo.deleteAccount();
    } catch (e) {
      print("$e");
      rethrow;
    }
  }
}
