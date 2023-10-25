import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twinz/core/model/zodiaque.dart';
import 'package:twinz/core/services/local_storage.service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:twinz/shared/utils/colors.dart';

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

LocalStorageService get localStorage => Get.find<LocalStorageService>();

bool get isAuth => localStorage.isAuth;

void logout() {
  localStorage.clear();
}

String get currentUserId {
  return "${localStorage.getUser()?.id}";
}

Future<XFile> getImageXFileByUrl(String url) async {
  var file = await DefaultCacheManager().getSingleFile(url);
  XFile result = XFile(file.path);
  return result;
}

SigneZodiaque determinerSigne(DateTime dateNaissance) {
  int jour = dateNaissance.day;
  int mois = dateNaissance.month;

  if ((mois == 3 && jour >= 21) || (mois == 4 && jour <= 20)) {
    return listeSignes.firstWhere((element) => element.nom == "Bélier");
  } else if ((mois == 4 && jour >= 21) || (mois == 5 && jour <= 20)) {
    return listeSignes.firstWhere((element) => element.nom == "Taureau");
  } else if ((mois == 5 && jour >= 21) || (mois == 6 && jour <= 20)) {
    return listeSignes.firstWhere((element) => element.nom == "Gémeaux");
  } else if ((mois == 6 && jour >= 21) || (mois == 7 && jour <= 23)) {
    return listeSignes.firstWhere((element) => element.nom == "Cancer");
  } else if ((mois == 7 && jour >= 24) || (mois == 8 && jour <= 23)) {
    return listeSignes.firstWhere((element) => element.nom == "Lion");
  } else if ((mois == 8 && jour >= 24) || (mois == 9 && jour <= 22)) {
    return listeSignes.firstWhere((element) => element.nom == "Vierge");
  } else if ((mois == 9 && jour >= 23) || (mois == 10 && jour <= 22)) {
    return listeSignes.firstWhere((element) => element.nom == "Balance");
  } else if ((mois == 10 && jour >= 23) || (mois == 11 && jour <= 21)) {
    return listeSignes.firstWhere((element) => element.nom == "Scorpion");
  } else if ((mois == 11 && jour >= 22) || (mois == 12 && jour <= 21)) {
    return listeSignes.firstWhere((element) => element.nom == "Sagittaire");
  } else if ((mois == 12 && jour >= 22) || (mois == 1 && jour <= 19)) {
    return listeSignes.firstWhere((element) => element.nom == "Capricorne");
  } else if ((mois == 1 && jour >= 20) || (mois == 2 && jour <= 18)) {
    return listeSignes.firstWhere((element) => element.nom == "Verseau");
  } else {
    return listeSignes.firstWhere((element) => element.nom == "Poissons");
  }
}

Future<String> get deviceName async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _readAndroidBuildData(await deviceInfoPlugin.androidInfo)['device'];
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return _readIosDeviceInfo(await deviceInfoPlugin.iosInfo)['name'];
  }
  return "Unknow";
}

Future<String> get deviceId async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _readAndroidBuildData(await deviceInfoPlugin.androidInfo)['id'];
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return _readIosDeviceInfo(await deviceInfoPlugin.iosInfo)['model'];
  }
  return "Unknow";
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'displaySizeInches':
        ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
    'displayWidthPixels': build.displayMetrics.widthPx,
    'displayWidthInches': build.displayMetrics.widthInches,
    'displayHeightPixels': build.displayMetrics.heightPx,
    'displayHeightInches': build.displayMetrics.heightInches,
    'displayXDpi': build.displayMetrics.xDpi,
    'displayYDpi': build.displayMetrics.yDpi,
    'serialNumber': build.serialNumber,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

decoration(String text, {Widget? suffix}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    hintText: text,
    suffix: suffix,
    hintStyle: const TextStyle(color: DARK_COLOR, fontFamily: "Haylard"),
    errorStyle: const TextStyle(color: Colors.redAccent),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent)),
    focusedBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: MAIN_COLOR)),
    border: const OutlineInputBorder(borderSide: BorderSide(color: DARK_COLOR)),
  );
}

bool valideDate(String jj, String mm, String yyyy) {
  int jour = int.tryParse(jj) ?? 0;
  int mois = int.tryParse(mm) ?? 0;
  int annee = int.tryParse(yyyy) ?? 0;

  if (mois < 1 || mois > 12 || jour < 1) {
    return false;
  }

  List<int> joursParMois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  if (mois == 2 && (annee % 4 == 0 && annee % 100 != 0 || annee % 400 == 0)) {
    joursParMois[1] = 29;
  }

  return jour <= joursParMois[mois - 1];
}
