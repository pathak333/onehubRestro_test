import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/home/components/icons.dart';
import 'package:onehubrestro/screens/orders/order_detail_screen.dart';
import 'package:onehubrestro/shared/components/countdown.dart';
import 'package:onehubrestro/shared/components/timer_action_button.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';
import 'package:onehubrestro/shared/components/countdown_timer.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';

class OrderCard extends StatefulWidget {
  OrderCard({Key key, this.orderId}) : super(key: key);

  final int orderId;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    setState(() {
      log('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
    });
    log('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
  }

  RestaurantController restaurantController = Get.find<RestaurantController>();

  RealTimeOrdersController realTimeOrdersController =
      Get.find<RealTimeOrdersController>();

  OrderController orderController = Get.find<OrderController>();

  Text getCardSubtitle(DeliveryDetails deliveryDetails) {
    String text = '';
    switch (deliveryDetails.status) {
      case DeliveryStatus.notcreated:
        text = 'Searching for delivery partners';
        break;
      case DeliveryStatus.searching:
        text = 'Searching for delivery partners';
        break;
      case DeliveryStatus.assigned:
        text = '${deliveryDetails.agentName} is arriving';
        break;
      case DeliveryStatus.reached:
        text = '${deliveryDetails.agentName} reached the location';
        break;
      case DeliveryStatus.picked:
        text = '${deliveryDetails.agentName} picked up the food';
        break;
      case DeliveryStatus.delivered:
        text = '${deliveryDetails.agentName} delivered the food';
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    log('oooooooooooooooooooooooooooooooooooooo');

    return StreamBuilder(
        key: Key(widget.orderId.toString()),
        stream: realTimeOrdersController.getOrderById(
            restaurantId: restaurantController.restaurant.value.restaurantId,
            orderId: widget.orderId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            Order order = snapshot.data;
            var totalSeconds = order.leadTime * 60;
            //var totalSeconds = order.pickupTime;
            var remainingSeconds = (order.pickupTime != null)
                ? order.pickupTime.seconds.difference(DateTime.now()).inSeconds
                : 0;

            if (order.orderStatus == OrderStatus.preparing) {
              if (remainingSeconds <= 0) {
                if (orderController.timers[widget.orderId] == null) {
                  orderController.timers[widget.orderId] =
                      Timer.periodic(Duration(seconds: 10), (timer) {
                    AudioCache player =
                        new AudioCache(prefix: 'lib/assets/sounds/');
                    const alarmAudioPath = "orderal.mp4";
                    //const alarmAudioPath = "order_beep.mp4";
                    player.play(alarmAudioPath, isNotification: true);
                  });
                }
              } else {
                if (orderController.startTimers[widget.orderId] == null) {
                  orderController.startTimers[widget.orderId] =
                      Timer(Duration(seconds: remainingSeconds), () {
                    if (orderController.timers[widget.orderId] == null) {
                      orderController.timers[widget.orderId] =
                          Timer.periodic(Duration(seconds: 10), (timer) {
                        AudioCache player =
                            new AudioCache(prefix: 'lib/assets/sounds/');
                        const alarmAudioPath = "orderal.mp4";
                        // audio file name
                        //const alarmAudioPath = "order_beep.mp4";
                        player.play(alarmAudioPath, isNotification: true);
                      });
                    }
                  });
                }
              }
            }

            return Column(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        //height: 100,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: ${order.orderId}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                (order.orderStatus == OrderStatus.preparing)
                                    ? Text('Remaining time:',
                                        style: TextStyle(color: Colors.white))
                                    : getCardSubtitle(order.deliveryDetails),
                              ],
                            ),
                            (order.orderStatus == OrderStatus.preparing)
                                ? Countdown(
                                    secondsRemaining: remainingSeconds,
                                    totalSecond: totalSeconds,
                                  )
                                : Container(),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )),
                      ),
                      Container(
                        // padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            ...order.products
                                .map((product) => ListTile(
                                      horizontalTitleGap: 0,
                                      leading: (product.isVeg != null)
                                          ? (product.isVeg)
                                              ? getVegIcon()
                                              : getNonVegIcon()
                                          : null,
                                      title: Text(
                                          '${product.quantity} x ${product.name}'),
                                    ))
                                .toList()
                          ],
                        ),
                      ),
                      Divider(color: grey),
                      InkWell(
                        highlightColor: kSecondaryColor.withOpacity(0.3),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'View Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      color: kSecondaryColor,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              SlidePageTransition(
                                  widget: OrderDetailScreen(
                                      orderId: order.orderId)));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15)
              ],
            );
          } else {
            return Container(height: 0);
          }
        });
  }
}
