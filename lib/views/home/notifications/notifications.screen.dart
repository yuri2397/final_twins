import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twinz/components/ui.dart';
import 'package:twinz/controllers/notification.controller.dart';
import 'package:twinz/shared/utils/colors.dart';
import 'package:twinz/core/model/notification.dart' as nt;

class NotificationsScreen extends GetView<NotificationController> {
  NotificationsScreen({super.key});
  final drawerKey = GlobalKey<DrawerControllerState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
              title: const Text("Notifications",
                  style: TextStyle(color: Colors.white))),
          drawer: drawer(drawerKey: drawerKey, scaffoldKey: scaffoldKey),
          body: controller.loading.value && controller.items.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: MAIN_COLOR),
                )
              : RefreshIndicator(
                  onRefresh: () => Future.sync(
                      () async => await controller.fetchNotifications()),
                  color: MAIN_COLOR,
                  child: controller.items.isEmpty
                      ? ListView(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/notifications.svg",
                                    width: 300,
                                  ),
                                  const Text(
                                    "Aucune notification",
                                    style: TextStyle(
                                        color: DARK_COLOR,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ).marginSymmetric(horizontal: 20)
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          itemCount: controller.items.length,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemBuilder: (BuildContext context, int index) =>
                              Dismissible(
                            key: Key(controller.items[index].id!),
                            onDismissed: (_) => controller
                                .markAsRead(controller.items[index].id!),
                            child: _buildItem(controller.items[index])
                                .marginOnly(bottom: 16),
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 2,
                            color: MAIN_COLOR,
                          ),
                        ).marginSymmetric(horizontal: 20),
                )),
    );
  }

  Widget _buildItem(nt.Notification item) {
    switch (item.data?.data?.type) {
      case 'message':
        return _buildMessage(item);
      case 'request_accepted':
        return _buildAcceptRequest(item);
      case 'new_request':
        return _buildNewRequest(item);
      default:
        return Container();
    }
  }

  _buildMessage(nt.Notification item) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () => controller.detailUserNot(item),
        title: Text("${item.data?.title}"),
        subtitle: Text("${item.data?.body}"),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              item.data?.data?.image ??
                  'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        trailing: Text(DateFormat.Hm().format(item.createdAt!)),
      ),
    );
  }

  _buildAcceptRequest(nt.Notification item) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        title: Text("${item.data?.title}"),
        subtitle: Text("${item.data?.body}"),
        trailing: Text(DateFormat.Hm().format(item.createdAt!)),
      ),
    );
  }

  _buildNewRequest(nt.Notification item) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: GestureDetector(
            onTap: () => {},
            child: const CircleAvatar(
                backgroundColor: Colors.greenAccent,
                child: Icon(Icons.check, color: Colors.white))),
        title: Text("${item.data?.title}"),
        subtitle: Text("${item.data?.body}"),
        trailing: Text(DateFormat.Hm().format(item.createdAt!)),
      ),
    );
  }
}