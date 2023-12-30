import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/chat_request.controller.dart';
import 'package:twinz/core/model/chat_request.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';

class ChatRequestScreen extends GetView<ChatRequestController> {
  const ChatRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          title:  Text("${lang?.notifications}"),
          elevation: 0,
        ),
        body: controller.loading.value && controller.items.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: MAIN_COLOR),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    Future.sync(() async => controller.receivedRequestChats()),
                color: MAIN_COLOR,
                child: controller.items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SvgPicture.asset(
                              "assets/images/notifications.svg",
                              width: 300,
                            ),
                             Text(
                              "${lang?.noNotifications}",
                              style:const TextStyle(
                                  color: DARK_COLOR,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ).marginSymmetric(horizontal: 20)
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 290,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: controller.items.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _buildItem(controller.items[index])).marginAll(20),
              )));
  }

  Widget _buildItem(ChatRequest request) {
    var acceptLoading = false.obs;
    var rejectLoading = false.obs;
    return Obx(
      () => Container(
        height: 300,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 10,
              offset: const Offset(2, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: SizedBox(
                height: 140,
                width: Get.width,
                child: Image.network(
                    (request.userFrom?.profilePhoto != null &&
                            request.userFrom?.profilePhoto != "")
                        ? request.userFrom!.profilePhoto!
                        : "https://img.freepik.com/photos-gratuite/jeune-femme-chien-sans-abri-au-parc-photo-haute-qualite_144627-75703.jpg?w=740&t=st=1694874615~exp=1694875215~hmac=eb6804b67c1fc7b677babff8be1caaee8f4b47db541f6cfeb548f472371d555d",
                    fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${request.userFrom?.fullName} ",
              textAlign: TextAlign.center,
              maxLines: 2,
            ).marginAll(5),
            Text("${lang?.age} ${request.userFrom?.age} ${lang?.years}",
                style: TextStyle(color: Colors.black.withOpacity(0.5))),
            const Divider(
              height: 2,
              color: NEUTRAL_COLOR,
            ).marginSymmetric(vertical: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () async {
                      rejectLoading.value = true;
                      rejectLoading.refresh();
                      await controller.cancelChatRequest(request);
                      rejectLoading.value = false;
                      rejectLoading.refresh();
                    },
                    child: rejectLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.redAccent,
                              strokeWidth: 2,
                            ),
                          )
                        : itemIcon(CupertinoIcons.clear_thick_circled,
                            color: Colors.redAccent)),
                GestureDetector(
                    onTap: () async {
                      acceptLoading.value = true;
                      acceptLoading.refresh();
                      //await controller.acceptChatRequest(request, );
                      acceptLoading.value = false;
                      acceptLoading.refresh();
                    },
                    child: acceptLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: MAIN_COLOR,
                              strokeWidth: 2,
                            ),
                          )
                        : itemIcon(CupertinoIcons.checkmark_circle_fill)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
