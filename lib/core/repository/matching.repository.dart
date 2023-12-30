import 'package:get/get.dart';
import 'package:twinz/core/http/http_client.dart';
import 'package:twinz/core/model/user.dart';

class MatchingRepository {
  final _client = Get.find<HttpClient>();

  Future<List<User>> matchings() async {
    var response = await _client.get("/matchings");
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      if (response.data is Map) {
        return [];
      }
      return List.from(response.data).map((e) => User.fromJson(e)).toList();
    }

    throw response.data;
  }

  matchingDetails(User user) async {
    var response = await _client.get("/matchings/${user.id}");

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return User.fromJson(response.data);
    }

    throw response.data;
  }

  matchingSkip(User user) async {
    var response = await _client.get("/matchings/${user.id}/skip");
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      if (response.data is Map) {
        return User.fromJson(response.data);
      }
      return true;
    }
    throw response.data;
  }

  matchingCancelSkip(User user) async {
    var response = await _client.get("/matchings/${user.id}/cancel-skip");
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      if (response.data is Map) {
        return User.fromJson(response.data);
      }
      return true;
    }

    throw response.data;
  }
}
