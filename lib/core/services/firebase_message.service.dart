import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:twinz/controllers/notification.controller.dart';
import 'package:twinz/core/services/notification.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/controllers/chat.controller.dart' as lc;
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
bool isFlutterLocalNotificationsInitialized = false;
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
// CONFIGURATION FOR NOTIFICATION
setupFlutterNotifications() async {
  if (!kIsWeb) {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        default:
          selectNotificationStream.add(notificationResponse.payload);
          break;
      }
    });
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }
}

Future _notificationsBackground(RemoteMessage message) async {
  _handleNotification(message, backGround: true);
}

Future _handleNotification(RemoteMessage message, {backGround = false}) async {
  switch (message.data['type']) {
    case 'new_request':
      _newRequestChat(message, backGround: backGround);
      break;
    case 'message':
      _newMessage(message, backGround: backGround);
      break;
    case 'request_accepted':
      _buildAcceptRequest(message, backGround: backGround);
      break;
    default:
      _showFlutterNotification(message);
  }
}

void _buildAcceptRequest(RemoteMessage message, {required backGround}) {
  try {
    if (!backGround) {
      Get.find<NotificationController>().haveUnreadNotification.value = true;
      Get.find<NotificationController>().haveUnreadNotification.refresh();
      Get.find<NotificationController>().fetchNotifications();
    }
  } catch (e) {
    print("$e");
  }
  _showFlutterNotification(
    message,
    backGround: backGround,
  );
}

void _newRequestChat(RemoteMessage message, {backGround = false}) {
  try {
    if (!backGround) {
      Get.find<NotificationController>().haveUnreadNotification.value = true;
      Get.find<NotificationController>().haveUnreadNotification.refresh();
      Get.find<NotificationController>().fetchNotifications();
    }
  } catch (e) {
    print("$e");
  }
  _showFlutterNotification(
    message,
    backGround: backGround,
  );
}

void _newMessage(RemoteMessage message, {backGround = false}) {
  try {
    if (!backGround) {
      if (Get.currentRoute ==
          "${Goo.chatScreen}?chat_id=${message.data['chat_id']}") {
        Get.find<lc.ChatController>()
            .appendMessageInDiscussion("${message.notification?.body}");
      } else {
        Get.find<NotificationController>().haveUnreadMessage.value = true;
        Get.find<NotificationController>().haveUnreadMessage.refresh();
        _showFlutterNotification(
          message,
          backGround: backGround,
        );
      }
      Get.find<lc.ChatController>().getChats();
    }
  } catch (e) {
    print("$e");
  }
  if (backGround) {
    _showFlutterNotification(
      message,
      backGround: backGround,
    );
  }
}

Future _showFlutterNotification(RemoteMessage message,
    {backGround = false, String? payload}) async {
  var title = message.notification?.title;
  var content = message.notification?.body;

  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    categoryIdentifier: 'categoryIdentifier',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'default',
  );
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id, channel.name,
      priority: Priority.high,
      importance: Importance.high,
      fullScreenIntent: true,
      channelDescription: channel.description,
      icon: '@mipmap/ic_launcher');

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  if (!backGround) {
    await flutterLocalNotificationsPlugin.show(
        message.notification.hashCode, title, content, platformChannelSpecifics,
        payload: payload);
  }
}

void onNotificationSelect(String? payload) {
  try {
    dynamic data = jsonDecode(payload ?? '');
    if (data['target_url'] != null) {
      Get.toNamed(data['target_url']);
    }
  } catch (_) {}
}

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    await setupFlutterNotifications();
    selectNotificationStream.stream.listen(onNotificationSelect);

    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);

    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    /**here is to handle notification when app is background and we want to act when user click in notification */
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationsBackground(message);
    });
    return this;
  }

  Future fcmOnMessageListeners() async {
    /**here is to handle notification when app is foreground */
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message);
    });
  }

  Future fcmOnLaunchListeners() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onBackgroundMessage(_notificationsBackground);
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      print('object');
    } else {
      print('yoo');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("TOKEN: $token");
    updateDeviceToken(token);
    return "$token";
  }

// FIREBASE INITIALIZATION
  Future<void> initFirebaseInstances() async {}

  void updateDeviceToken(token) async {
    localStorage.fcmToken = token;
    if (localStorage.isAuth) {
      await Get.find<NotificationService>().updateDeviceToken(token);
    }
  }
}

void lunchWebURL(String url) async {
  await launchUrl(Uri.parse(url));
}
