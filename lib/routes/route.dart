// ignore_for_file: non_constant_identifier_names

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:twinz/components/active_localisation.screen.dart';
import 'package:twinz/components/offer.screen.dart';
import 'package:twinz/components/onboarding.screen.dart';
import 'package:twinz/components/splash_screen.screen.dart';
import 'package:twinz/resolvers/active_account.binding.dart';
import 'package:twinz/resolvers/active_location.binding.dart';
import 'package:twinz/resolvers/forgot_password.binding.dart';
import 'package:twinz/resolvers/home.binding.dart';
import 'package:twinz/resolvers/login.binding.dart';
import 'package:twinz/resolvers/offer.binding.dart';
import 'package:twinz/resolvers/onboarding.binding.dart';
import 'package:twinz/resolvers/register.binding.dart';
import 'package:twinz/routes/router.dart';
import 'package:twinz/views/auth/active_account.screen.dart';
import 'package:twinz/views/auth/add_address.screen.dart';
import 'package:twinz/views/auth/add_avatar.screen.dart';
import 'package:twinz/views/auth/add_bio.screen.dart';
import 'package:twinz/views/auth/add_birthday.screen.dart';
import 'package:twinz/views/auth/add_email.screen.dart';
import 'package:twinz/views/auth/add_files_register.screen.dart';
import 'package:twinz/views/auth/add_sex.screen.dart';
import 'package:twinz/views/auth/forgot-password.screen.dart';
import 'package:twinz/views/home/notifications/notification_details.screen.dart';
import 'package:twinz/views/home/profile/add_files.screen.dart';
import 'package:twinz/views/auth/add_password.screen.dart';
import 'package:twinz/views/auth/add_signe.screen.dart';
import 'package:twinz/views/auth/login.screen.dart';
import 'package:twinz/views/auth/register.screen.dart';
import 'package:twinz/views/home/chats/chat.screen.dart';
import 'package:twinz/views/home/home.screen.dart';
import 'package:twinz/views/home/profile/details.screen.dart';
import 'package:twinz/views/home/profile/setting.screen.dart';
import 'package:twinz/views/home/profile/update_password.screen.dart';
import 'package:twinz/views/home/profile/update_profile.screen.dart';
import 'package:twinz/views/home/search/search.screen.dart';
import 'package:twinz/views/home/search/search_detail.dart';

dynamic ROUTER_OUTLET = [
  /// SHARED ROUTES
  GetPage(name: Goo.splashScreen, page: () => const SplashScreen()),
  GetPage(
      name: Goo.onboardingScreen,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding()),

  /// AUTH ROUTES

  GetPage(
      name: Goo.loginScreen,
      binding: LoginBinding(),
      page: () => LoginScreen()),

  // reset password

  GetPage(
      name: Goo.forgotPasswordScreen,
      binding: ForgotPasswordBinding(),
      page: () => ForgotPasswordScreen()),

  GetPage(
      name: Goo.notificationDetails,
      page: () => const NotificationDetailsScreen()),

  GetPage(
      name: Goo.activeLocationScree,
      binding: ActiveLocationBinding(),
      page: () => const ActiveLocationScreen()),

  GetPage(
    name: Goo.registerScreen,
    binding: RegisterBinding(),
    page: () => RegisterScreen(),
  ),
  GetPage(name: Goo.addEmailScreen, page: () => AddEmailScreen()),
  GetPage(name: Goo.addPasswordScreen, page: () => AddPasswordScreen()),
  GetPage(name: Goo.addBirthDayScreen, page: () => AddBirthDayScreen()),
  GetPage(name: Goo.addFilesScreen, page: () => const AddFilesScreen()),
  GetPage(name: Goo.addSigneScreen, page: () => AddSigneScreen()),
  GetPage(name: Goo.addBioScreen, page: () => AddBioScreen()),
  GetPage(name: Goo.addAvatarScreen, page: () => AddAvatarScreen()),
  GetPage(name: Goo.addAddressScreen, page: () => AddAddressScreen()),
  GetPage(name: Goo.addSexScreen, page: () => AddSexScreen()),
  GetPage(
      name: Goo.addFilesRegisterScreen,
      page: () => const AddFilesRegisterScreen()),
  GetPage(
      name: Goo.activeAccountScreen,
      binding: ActiveAccountBinding(),
      page: () => const ActiveAccountScreen()),

  /// HOME MODULES
  GetPage(
      name: Goo.homeScreen, page: () => HomeScreen(), binding: HomeBinding()),
  GetPage(name: Goo.searchDetailsScreen, page: () => const SearchDetails()),

  // PROFILE PAGES
  GetPage(name: Goo.detailsProfileScreen, page: () => DetailProfileScreen()),
  GetPage(name: Goo.updateProfileScreen, page: () => UpdateProfileScreen()),
  GetPage(name: Goo.updatePasswordScreen, page: () => PasswordProfileScreen()),
  GetPage(name: Goo.settingScreen, page: () => SettingScreen()),
  GetPage(
      name: Goo.offerScreen,
      page: () => OfferScreen(),
      binding: OfferBindinge()),

  // CHAT PAGES
  GetPage(name: Goo.chatScreen, page: () => ChatScreen()),
];
