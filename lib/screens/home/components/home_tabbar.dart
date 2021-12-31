import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/order-home/home_controller.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';
import 'package:onehubrestro/utilities/screen_util.dart';

class HoomeTabBar extends StatelessWidget {
  HoomeTabBar({
    Key key,
    @required this.restaurantId,
    @required this.homeController,
  }) : super(key: key);

  final HomeController homeController;
  final int restaurantId;

  final RealTimeOrdersController realTimeOrdersController =
      Get.find<RealTimeOrdersController>();

  final OrderController orderController = Get.find<OrderController>();

  final UserController userController = Get.find<UserController>();

  RestaurantController restaurantController = Get.find<RestaurantController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScreenUtil.getInstance().init(context);

    return Container(
        height: size.height * 0.12,
        padding: EdgeInsets.all(10 * ScreenUtil.getInstance().scaleWidth),
        color: lightGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<Object>(
                stream: realTimeOrdersController.getOrdersByStatus(
                    restaurantId: restaurantId,
                    orderStatus: OrderStatus.preparing),
                builder: (context, snapshot) {
                  var items = 0;
                  if (snapshot.data != null) {
                    var orders = (snapshot.data as List<Order>);
                    if (orders.length > 0) {
                      orders.forEach((order) {
                        AudioPlayer player =
                            userController.sounds[order.orderId];

                        if (player != null) {
                          userController.sounds[order.orderId].stop();
                          userController.sounds.removeWhere(
                              (key, value) => key == order.orderId);
                        }
                      });

                      items = orders.length;
                    }
                  }
                  return Obx(() => ElevatedButton(
                      child: Text('Preparing ($items)',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                color: (homeController.selectedStatus.value ==
                                        OrderStatus.preparing)
                                    ? Colors.white
                                    : textGrey,
                                fontWeight: FontWeight.w500,
                              )),
                      onPressed: () {
                        if (!(!restaurantController.restaurant.value.status &&
                            items == 0))
                          homeController.selectedStatus.value =
                              OrderStatus.preparing;
                      },
                      style: ElevatedButton.styleFrom(
                          primary: (homeController.selectedStatus.value ==
                                  OrderStatus.preparing)
                              ? orange
                              : lightGrey,
                          padding: EdgeInsets.all(12),
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color: (homeController.selectedStatus.value ==
                                          OrderStatus.preparing)
                                      ? orange
                                      : textGrey,
                                  width: 2)),
                          elevation: 0)));
                }),
            StreamBuilder<Object>(
                stream: realTimeOrdersController.getOrdersByStatus(
                    restaurantId: restaurantId, orderStatus: OrderStatus.ready),
                builder: (context, snapshot) {
                  var items = 0;
                  if (snapshot.data != null) {
                    var orders = (snapshot.data as List<Order>);
                    if (orders.length > 0) {
                      orders.forEach((order) {
                        Timer timer = orderController.timers[order.orderId];

                        Timer startTimer =
                            orderController.startTimers[order.orderId];

                        if (timer != null) {
                          orderController.timers[order.orderId].cancel();
                          orderController.timers.removeWhere(
                              (key, value) => key == order.orderId);
                        }
                        if (startTimer != null) {
                          orderController.startTimers[order.orderId].cancel();
                          orderController.startTimers.removeWhere(
                              (key, value) => key == order.orderId);
                        }
                      });
                      items = orders.length;
                    }
                  }
                  return Obx(() => ElevatedButton(
                      child: Text('Ready ($items)',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                color: (homeController.selectedStatus.value ==
                                        OrderStatus.ready)
                                    ? Colors.white
                                    : textGrey,
                                fontWeight: FontWeight.w500,
                              )),
                      onPressed: () {
                        if (!(!restaurantController.restaurant.value.status &&
                            items == 0))
                          homeController.selectedStatus.value =
                              OrderStatus.ready;
                      },
                      style: ElevatedButton.styleFrom(
                          primary: (homeController.selectedStatus.value ==
                                  OrderStatus.ready)
                              ? orange
                              : lightGrey,
                          padding: EdgeInsets.all(12),
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color: (homeController.selectedStatus.value ==
                                          OrderStatus.ready)
                                      ? orange
                                      : textGrey,
                                  width: 2)),
                          elevation: 0)));
                }),
            StreamBuilder<Object>(
                stream: realTimeOrdersController.getOrdersByStatus(
                    restaurantId: restaurantId,
                    orderStatus: OrderStatus.picked),
                builder: (context, snapshot) {
                  var items = 0;
                  if (snapshot.data != null) {
                    var orders = (snapshot.data as List<Order>);
                    if (orders.length > 0) {
                      items = orders.length;
                    }
                  }
                  return Obx(() => ElevatedButton(
                      child: Text('Picked up ($items)',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                color: (homeController.selectedStatus.value ==
                                        OrderStatus.picked)
                                    ? Colors.white
                                    : textGrey,
                                fontWeight: FontWeight.w500,
                              )),
                      onPressed: () {
                        if (!(!restaurantController.restaurant.value.status &&
                            items == 0))
                          homeController.selectedStatus.value =
                              OrderStatus.picked;
                      },
                      style: ElevatedButton.styleFrom(
                          primary: (homeController.selectedStatus.value ==
                                  OrderStatus.picked)
                              ? orange
                              : lightGrey,
                          padding: EdgeInsets.all(12),
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color: (homeController.selectedStatus.value ==
                                          OrderStatus.picked)
                                      ? orange
                                      : textGrey,
                                  width: 2)),
                          elevation: 0)));
                })
          ],
        ));
  }
}
