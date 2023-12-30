import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twinz/core/config/env.dart';
import 'package:twinz/core/model/user.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/controllers/search.controller.dart' as sc;

// ignore: must_be_immutable
class SearchItemWidget extends StatelessWidget {
  User user;
  bool showCancelIcon = false;
  bool showLikeIcons = false;

  SearchItemWidget(
      {super.key,
      required this.user,
      this.showCancelIcon = false,
      this.showLikeIcons = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Get.find<sc.SearchController>().searchDetails(user),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                (user.profilePhoto != null && user.profilePhoto != "")
                    ? user.profilePhoto!
                    : "https://img.freepik.com/photos-gratuite/jeune-femme-chien-sans-abri-au-parc-photo-haute-qualite_144627-75703.jpg?w=740&t=st=1694874615~exp=1694875215~hmac=eb6804b67c1fc7b677babff8be1caaee8f4b47db541f6cfeb548f472371d555d",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
              onTap: () => Get.find<sc.SearchController>().searchDetails(user),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: SvgPicture.asset(
                  "assets/icons/i.svg",
                  color: MAIN_COLOR,
                  width: 30,
                ),
              )),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              width: Get.width - 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.fullName}, ${user.age}".capitalizeFirst ?? "",
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      width: Get.width,
                      child: Text(
                          DateFormat.MMMMd(
                                  Localizations.localeOf(context).languageCode)
                              .format(user.birthDate ?? DateTime.now()),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    //
                    if (user.bio != null)
                      SizedBox(
                        width: Get.width,
                        height: 60,
                        child: Text(user.bio ?? 'Bio',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(color: Colors.white)),
                      ).marginOnly(right: 5),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
            )),
        if (showCancelIcon)
          Positioned(
            top: 10,
            bottom: 10,
            left: Get.width * .38,
            right: Get.width * .38,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(
                Icons.close,
                color: Colors.pink,
                size: 35,
              ),
            ),
          ),
        if (showLikeIcons)
          Positioned(
            top: 10,
            bottom: 10,
            left: Get.width * .38,
            right: Get.width * .38,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Image.asset(
                  Env.whiteLogo,
                  width: 50,
                )),
          ),
      ],
    );
  }
}
