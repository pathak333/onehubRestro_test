import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/order-home/home_controller.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class NotificationScreen extends StatelessWidget {
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar('Notifications', () {
        Navigator.of(context).pop();
      }),
      body: ListView(
        children: [
          SizedBox(height: 24),
          Obx(() => Column(
              children: homeController.notifications
                  .map((notification) => NotificationCard(
                        message: notification,
                      ))
                  .toList()))
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  NotificationCard({Key key, this.message}) : super(key: key);

  RemoteMessage message;
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(message.messageId),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.25,
        dismissible: DismissiblePane(onDismissed: () {
          homeController.notifications.removeWhere((element) => element.messageId == message.messageId);
          homeController.storeNotificationsList();
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              homeController.notifications.removeWhere((element) => element.messageId == message.messageId);
              homeController.storeNotificationsList();
            },
            backgroundColor: errorRed,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
              color: lightGrey,
              border: Border(left: BorderSide(width: 8, color: green))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: black,
                radius: 30,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.notification.title,
                          style: AppTextStyle.getPoppinsMedium()
                              .copyWith(fontSize: 14)),
                      SizedBox(height: 10),
                      Text(message.notification.body,
                          style: AppTextStyle.getLatoMedium()
                              .copyWith(fontSize: 14)),
                      SizedBox(height: 10),
                      Text(getSentTime(message.sentTime),
                          style: AppTextStyle.getLatoMedium()
                              .copyWith(fontSize: 12, color: textGrey))
                    ]),
              )
            ],
          )),
    );
  }

  String getSentTime(DateTime sentTime){
    int minutes = DateTime.now().difference(sentTime).inMinutes;
    if(minutes <= 0){
      return 'Now';
    } else if(minutes > 60){
      int hours = minutes ~/ 60;
      return '${hours} ${hours == 1 ? "hour" : "hours"} ago';
    } else {
      return '${minutes} ${minutes == 1 ? 'min' : 'mins'} ago';
    }
  }
}
