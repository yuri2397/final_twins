import 'package:get/get.dart';
import 'package:twins/core/http/http_client.dart';
import 'package:twins/core/model/user.dart';

class UserRepository {
  final _client = Get.find<HttpClient>();

  Future<User> update({required User user}) async {
    try {
      var response = await _client.put("/update", data: user.toJson());
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
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
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> reportUser({required User user}) async {
    try {
      var response = await _client.post("/users/${user.id}/report", data: {});
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
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
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
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
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
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
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "Oups! une erreur s'est produite.";
      }
    } catch (e) {
      rethrow;
    }
  }
}
