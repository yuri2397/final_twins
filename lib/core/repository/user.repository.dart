import 'package:get/get.dart';
import 'package:twinz/core/http/http_client.dart';
import 'package:twinz/core/model/user.dart';

class UserRepository {
  final _client = Get.find<HttpClient>();

  Future<User> update({required User user}) async {
    try {
      var response =
          await _client.put("/profile", data: user.toJsonForUpdate());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return User.fromJson(response.data);
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> blockUser({required User user}) async {
    try {
      var response = await _client.post("/users/${user.id}/block", data: {});
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> reportUser({required User user, required String raison}) async {
    try {
      var response = await _client.post("/users/${user.id}/report", data: {
        "reason": raison,
      });
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unblockUser({required User user}) async {
    try {
      var response = await _client.post("/users/${user.id}/unblock", data: {});
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> enableAccount() async {
    try {
      var response = await _client.post("/enable-account", data: {});
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> disableAccount() async {
    try {
      var response = await _client.post("/disable-account", data: {});
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      var response = await _client.delete("/delete-account");
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
