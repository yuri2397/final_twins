import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twinz/core/model/user.dart';
import 'package:twinz/core/services/chat_request.service.dart';
import 'package:twinz/core/services/matching.service.dart';
import 'package:twinz/core/services/user.service.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/routes/router.dart';

class SearchController extends GetxController {
  final _matchingService = Get.find<MatchingService>();
  final AppinioSwiperController swiperController = AppinioSwiperController();
  final currentMatch = <User>[].obs;
  final visibleUser = User(id: 0).obs;
  final _chatRequestService = Get.find<ChatRequestService>();
  final canUnswip = true.obs;
  final detailUserPhotosController = PageController();
  final matchLoad = true.obs;
  final detailsLoad = false.obs;
  final subscribeForPremium = false.obs;
  final matchSuccess = true.obs;
  final likeLoad = false.obs;
  final _userService = Get.find<UserService>();
  final user = localStorage.getUser().obs;
  final showCancelIcon = false.obs;
  final showLikeIcons = false.obs;
  final updateSettings = false.obs;

  @override
  void onInit() {
    determinePosition().then((value) async{
      var user = localStorage.getUser();
      user?.lat = "${value.latitude}";
      user?.lng = "${value.longitude}";
      localStorage.user = user;
     await  _userService.updateUser(user!);
      getMatchings();
    });
    super.onInit();
  }

  Future<void> getMatchings() async {
    matchLoad.value = true;
    await _matchingService.matchings().then((value) {
      currentMatch.value = value;
      if (value.isEmpty) {
        matchSuccess.value = false;
      } else {
        visibleUser.value = value.first;
        matchSuccess.value = true;
        currentMatch.refresh();
      }
      matchLoad.value = false;
    }).catchError((e, s) {
      if(e.toString().contains("403")){
        matchSuccess.value = false;
        updateSettings.value = true;
      }
      matchLoad.value = false;
    });
  }

  void swipe(int index, AppinioSwiperDirection direction) async {
    if (direction == AppinioSwiperDirection.left) {
      _matchingService.matchingSkip(visibleUser.value);
    } else if (direction == AppinioSwiperDirection.right) {
      _chatRequestService.sendRequestChat(toUser: visibleUser.value).then((value) {
        likeLoad.value = false;
      }).catchError((e) {
        likeLoad.value = false;
      });
    }
    if ((user.value?.isPremium == true)) {
      if (currentMatch.length == index) {
        matchLoad.value = true;
        await _matchingService.matchings().then((value) {
          currentMatch.value = value;
          if (value.isEmpty) {
            matchSuccess.value = false;
          } else {
            visibleUser.value = value.first;
            matchSuccess.value = true;
            currentMatch.refresh();
          }
          matchLoad.value = false;
        }).catchError((e, s) {
          matchLoad.value = false;
        });
      }
      canUnswip.value = true;
    } else if(currentMatch.length != index){
      visibleUser.value = currentMatch[index];
    }else{
      matchSuccess.value = false;
    }
    showCancelIcon.value = false;
    showLikeIcons.value = false;
  }

  onLike(User user) {
    swiperController.swipeRight();
  }

  onSwipBack(User currentMatch) {
    if (canUnswip.value) {
      if (localStorage.getUser()!.isPremium == false) {
        canUnswip.value = false;
      }
      canUnswip.refresh();
      _matchingService.matchingCancelSkip(currentMatch);
      swiperController.unswipe();
    }
  }

  onCancel(User currentMatch) {
    swiperController.swipeLeft();
  }

  searchDetails(User user) async {
    detailsLoad.value = true;
    _matchingService.matchingDetails(user: user).then((value) {
      visibleUser.value = value;
      detailsLoad.value = false;
    }).catchError((e) {
      detailsLoad.value = false;
    });
    Get.toNamed(Goo.searchDetailsScreen);
  }

  activeAccount() {
    matchLoad.value = true;
    _userService.enableAccount().then((value) {
      user.value?.active = "1";
      getMatchings();
      matchLoad.value = false;
    }).catchError((e) {
      print("$e");
      matchLoad.value = false;
    });
  }

  void onSwipLeft() {
    showCancelIcon.value = true;
  }

  void onSwipRight() {
    showLikeIcons.value = true;
  }
}
