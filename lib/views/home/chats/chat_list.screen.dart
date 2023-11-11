import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/chat.controller.dart';
import 'package:twinz/core/model/chat.dart';
import 'package:twinz/core/utils/utils.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatListScreen extends GetView<ChatController> {
  final drawerKey = GlobalKey<DrawerControllerState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
              backgroundColor: MAIN_COLOR,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => scaffoldKey.currentState?.openDrawer(),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
              title: const Text("Messages",
                  style: TextStyle(color: Colors.white))),
          drawer: drawer(drawerKey: drawerKey, scaffoldKey: scaffoldKey),
          body: controller.chatsLoad.value
              ? const Center(
                  child: CircularProgressIndicator(color: MAIN_COLOR),
                )
              : controller.chats.isEmpty
                  ? Center(
                      child: const Text(
                      "Aucun message",
                      style: TextStyle(
                          color: DARK_COLOR,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ).marginSymmetric(horizontal: 20))
                  : RefreshIndicator(
                      color: MAIN_COLOR,
                      onRefresh: () =>
                          Future.sync(() async => await controller.getChats()),
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          separatorBuilder: (_, index) => const Divider(
                                height: 10,
                                color: MAIN_COLOR,
                              ),
                          itemBuilder: (_, index) =>
                              _buildChatItem(controller.chats[index]),
                          itemCount: controller.chats.length),
                    )),
    );
  }

  _buildChatItem(Chat chat) {
    var sender = chat.participants
        ?.firstWhere((element) => element.id.toString() != currentUserId);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      onTap: () => controller.detailsChat(chat),
      leading: SizedBox(
        width: 60,
        height: 60,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child:
                sender!.profilePhoto != null && sender.profilePhoto!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: sender.profilePhoto!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(color: MAIN_COLOR),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/images/img.png")),
      ),
      title: Text(
          chat.participants!
              .firstWhere((e) => e.id.toString() != currentUserId)
              .fullName!,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
          chat.messages!.isEmpty
              ? "Envoyer le premier message..."
              : "${chat.messages!.last.message}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1),
      trailing: chat.messages!.isNotEmpty ? Text(
       chat.messages!.last.createdAt!
                .isAfter(DateTime.now().subtract(const Duration(days: 1)))
            ? DateFormat("HH:mm").format(chat.messages!.last.createdAt!.toLocal())
            : DateFormat.MMMd('fr').format(chat.messages!.last.createdAt!.toLocal()),
      ) : null,
    ).marginSymmetric(horizontal: 10, vertical: 5);
  }
}
