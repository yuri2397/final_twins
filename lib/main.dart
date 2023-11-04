import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/core/http/http_client.dart';
import 'package:twinz/core/services/chat.service.dart';
import 'package:twinz/core/services/chat_request.service.dart';
import 'package:twinz/core/services/firebase.service.dart';
import 'package:twinz/core/services/login.service.dart';
import 'package:twinz/core/services/matching.service.dart';
import 'package:twinz/core/services/notification.service.dart';
import 'package:twinz/core/services/user.service.dart';
import 'package:twinz/firebase_options.dart';
import 'package:twinz/routes/route.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/shared/utils/app_hehavior.dart';
import 'package:twinz/shared/utils/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/services/firebase_message.service.dart';
import 'core/services/local_storage.service.dart';
import 'core/services/profile.service.dart';

import 'package:firebase_core/firebase_core.dart';

const String STRIPE_PUBLISHABLE_KEY =
    "pk_test_51NwodCJBdlfJ0wtgE6qu9h1q8UCibKEBVzQrydGoJl853oMsz4z6HiG36SUcG5IP5ewWKpbdOuzHgqIORREFUSKo0030uAEcPm";

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

void main() async {
  await _initServices();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(GetMaterialApp(
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: Goo.splashScreen,
      getPages: ROUTER_OUTLET,
      title: Env.appName,
      defaultTransition: Transition.cupertinoDialog,
      scrollBehavior: const AppBehavior(),
      theme: defaultTheme,
    ));
  });
}

_initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  Stripe.publishableKey = STRIPE_PUBLISHABLE_KEY;
  await Stripe.instance.applySettings();
    await Firebase.initializeApp(
      name: 'twinz-app',
      options: DefaultFirebaseOptions.currentPlatform,
    );

  await Get.putAsync(() => LocalStorageService().init());
  await Get.putAsync(() => FireBaseMessagingService().init());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.lazyPut(() => HttpClient());
  Get.lazyPut(() => MatchingService());
  Get.lazyPut(() => ChatService());
  Get.lazyPut(() => ChatRequestService());
  Get.lazyPut(() => LoginService());
  Get.lazyPut(() => UserService());
  Get.lazyPut(() => NotificationService());
  Get.lazyPut(
    () => ProfileService(),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
}
