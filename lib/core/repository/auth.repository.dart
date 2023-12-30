import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/core/http/http_client.dart';
import 'package:twinz/core/model/setting.dart';
import 'package:twinz/core/model/token.dart';
import 'package:twinz/core/model/upload-file.dart';
import 'package:twinz/core/model/user.dart';
import 'package:twinz/core/services/firebase_message.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:dio/dio.dart' as dio;

class AuthRepository {
  final _client = Get.find<HttpClient>();

  Future<Token> login(
      {required String username, required String password}) async {
    try {
      try {
        var deviceToken =
            await Get.find<FireBaseMessagingService>().getDeviceToken();
        var response = await _client.post("/login", data: {
          "email": username,
          "password": password,
          "device_name": await deviceName,
          "device_id": await deviceId,
          "device_token": deviceToken
        });

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Token.fromJson(response.data);
        } else {
          throw "${lang?.emailOrPasswordInvalid}";
        }
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      var response = await _client.post("/password/forgot", data: {
        "email": email,
      });
      print(response.data);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "${lang?.emailInvalid}";
      }
    } catch (e) {
      rethrow;
    }
  }

  // check email
  Future<bool> checkEmail({required String email}) async {
    try {
      var response = await _client.post("/check-email", data: {
        "email": email,
      });

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw "${lang?.emailInvalid}";      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendLink() async {
    try {
      await _client.get(
        "/verify/resend",
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<User> profile() async {
    try {
      var response = await _client.get("/profile");
      print(response.data);
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
        return User.fromJson(response.data);
      } else {
        Get.log(response.data);
        throw "${lang?.errorToGetYourProfile}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> profileUpdate(Map<String, dynamic> data) async {
    try {
      var response = await _client.put("/profile", data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return User.fromJson(response.data);
      } else {
        Get.log(response.data);
        throw "${lang?.errorToUpdateYourInfos}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateSettings(Setting settings) async {
    try {
      var response = await _client.post("/settings", data: settings.toJson());
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
        return User.fromJson(response.data);
      } else {
        Get.log(response.data);
        throw "Impossible de modifier.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _client.post("/logout", data: {});
    } catch (e) {
      print("LOGOUT ERROR: $e");
      rethrow;
    }
  }

  Future<Token> register(
      {required Map<String, dynamic> data, required List<XFile> files}) async {
    List<String> images = [];

    List<dio.MultipartFile> multipartFiles = [];
    for (var file in files) {
      final bytes = File(file.path).readAsBytesSync();
      String b64 = base64Encode(bytes);
      images.add(b64);
      var multipartFile =
          await dio.MultipartFile.fromFile(file.path, filename: file.name);
      multipartFiles.add(multipartFile);
    }
    data.addAll({'photos': images});

    try {
      var response = await _client.post(
        '/register',
        data: data,
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        return Token.fromJson(response.data);
      } else {
        throw "${response.data}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updatePhotoProfile(XFile file) async {
    try {
      var response = await _client.post("/profile-photo",
          data: dio.FormData.fromMap({
            'profile_photo':
                await dio.MultipartFile.fromFile(file.path, filename: file.name)
          }),
          options: dio.Options(
            contentType: 'multipart/form-data',
          ));

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        return User.fromJson(response.data);
      } else {
        throw "${response.data}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UploadFile>> addPhoto(List<XFile> files) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({});

      for (var f in files) {
        print("${f.path}");
        formData.files.add(
            MapEntry('photos[]', await dio.MultipartFile.fromFile(f.path)));
      }

      var response = await _client.post("/photos",
          data: formData,
          options: dio.Options(contentType: 'multipart/form-data', headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${localStorage.getToken()?.accessToken}'
          }));

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return List<UploadFile>.from(
            response.data.map((e) => UploadFile.fromJson(e)));
      } else {
        Get.log(response.data);
        throw "Impossible de modifier.";
      }
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Future<List<UploadFile>> getPhotos() async {
    try {
      var response = await _client.get("/photos");
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
        if (response.data is Map) {
          return [];
        }
        return List<UploadFile>.from(
            response.data.map((x) => UploadFile.fromJson(x)));
      } else {
        Get.log(response.data);
        throw "Impossible de récuperer les images.";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UploadFile>> removePhoto(id) async {
    try {
      var response = await _client.get("/photos/$id");
      if (response.statusCode! <= 200 && response.statusCode! < 300) {
        if (response.data is Map) {
          return [];
        }
        return List<UploadFile>.from(
            response.data.map((x) => UploadFile.fromJson(x)));
      } else {
        Get.log(response.data);
        throw "Impossible de récuperer les images.";
      }
    } catch (e) {
      rethrow;
    }
  }
}
