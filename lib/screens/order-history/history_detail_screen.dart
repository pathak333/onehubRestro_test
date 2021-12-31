import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/models/order-history/order_history_detail.dart';
import 'package:onehubrestro/models/order-history/order_history_response.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/order-history/components/history_list_header.dart';
import 'package:onehubrestro/screens/order-history/components/no-order.dart';
import 'package:onehubrestro/screens/order-history/components/order_history_card.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:timelines/timelines.dart';

class HistoryDetailScreen extends StatelessWidget {
  OrderItem order;

  OrderController orderController = Get.find<OrderController>();

  HistoryDetailScreen({this.order}) {
    orderController.getOrderDetail(order.projectId);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppContainer(
      route: '/order-history',
      child: Scaffold(
          backgroundColor: lightGrey,
          appBar: getApplicationAppbar(
              context: context,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${order.projectId}'),
                  Text(
                    '${order.time} | ${order.date}',
                    style:
                        AppTextStyle.getPoppinsMedium().copyWith(fontSize: 14),
                  ),
                ],
              )),
          body: Obx(() {
            if (!orderController.isLoading.value &&
                orderController.isLoaded.value) {
              OrderDetail orderItem = orderController.selectedOrder.value;
              return ListView(
                children: [
                  Container(
                      height: getTimelIneheight(orderItem.timelne.length),
                      color: kSecondaryColor,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: OrderTimeline(
                        timeline: orderItem.timelne,
                      )),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Column(
                            children: orderItem.products
                                .map((product) => ListTile(
                                    horizontalTitleGap: 0,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${product.quantity} x ${product.name}',
                                            style: AppTextStyle.getLatoBold()),
                                        Text('₹360',
                                            style:
                                                AppTextStyle.getLatoSemibold())
                                      ],
                                    )))
                                .toList()),
                        Column(
                            children: orderItem.totals
                                .map((total) => Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(total.name,
                                              style:
                                                  AppTextStyle.getLatoSemibold()
                                                      .copyWith(
                                                          color: textGrey)),
                                          Text('₹${total.value}',
                                              style:
                                                  AppTextStyle.getLatoSemibold()
                                                      .copyWith(
                                                          color: textGrey))
                                        ],
                                      ),
                                    ))
                                .toList()),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Cash to be collected from rider',
                        //           style: AppTextStyle.getLatoSemibold()
                        //               .copyWith(color: textGrey)),
                        //       Text('₹0',
                        //           style: AppTextStyle.getLatoSemibold()
                        //               .copyWith(color: textGrey))
                        //     ],
                        //   ),
                        // ),
                        ListTile(
                          horizontalTitleGap: 0,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Bill',
                                  style: AppTextStyle.getLatoSemibold()),
                              Text('₹${orderItem.totalPrice}',
                                  style: AppTextStyle.getLatoSemibold())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      color: Colors.white,
                      child: ListTile(
                        horizontalTitleGap: 0,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order by',
                                style: AppTextStyle.getPoppinsRegular()
                                    .copyWith(fontSize: 18)),
                            Text(orderItem.customer,
                                style: AppTextStyle.getLatoRegular())
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  Container(
                      color: Colors.white,
                      child: ListTile(
                        horizontalTitleGap: 0,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Transaction ID',
                                style: AppTextStyle.getPoppinsRegular()
                                    .copyWith(fontSize: 18)),
                            Text('#${order.projectId}',
                                style: AppTextStyle.getLatoRegular())
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  Container(color: Colors.white, height: 100)
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })),
    );
  }

  double getTimelIneheight(int timelineLength) {
    if (timelineLength == 1) {
      return 80;
    } else if (timelineLength == 2) {
      return 110;
    } else {
      return 45.0 * timelineLength;
    }
  }
}

class OrderTimeline extends StatelessWidget {
  OrderTimeline({this.timeline});

  List<Timelne> timeline;

  @override
  Widget build(BuildContext context) {

    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: Colors.white,
        connectorTheme: ConnectorThemeData(
          thickness: 1.5,
        ),
      ),
      padding: EdgeInsets.only(top: 20.0),
      builder: TimelineTileBuilder.connected(
        indicatorBuilder: (context, index) {
          return DotIndicator(
            size: 10,
          );
        },
        connectorBuilder: (_, index, connectorType) {
          return SolidLineConnector();
        },
        contentsBuilder: (context, index) => Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (index == timeline.length - 1)
                  ? Chip(
                      label: Text(timeline[index].event.toUpperCase(),
                          style: AppTextStyle.getPoppinsSemibold().copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              letterSpacing: 2)),
                      backgroundColor:
                          getChipColor(timeline[index].event.toUpperCase())
                              ? errorRed
                              : green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    )
                  : Text(
                      timeline[index].event,
                      style: AppTextStyle.getLatoRegular()
                          .copyWith(color: Colors.white, fontSize: 14),
                    ),
              Text(
                timeline[index].time,
                style: AppTextStyle.getLatoRegular()
                    .copyWith(color: Colors.white, fontSize: 14),
              )
            ],
          ),
        ),
        itemExtentBuilder: (_, __) {
          return 30.0;
        },
        itemCount: timeline.length,
      ),
    );
  }

  getChipColor(String status) {
    return status !=
            OrderStatus.preparing.toString().split('.').last.toUpperCase() ||
        status != OrderStatus.ready.toString().split('.').last.toUpperCase() ||
        status != OrderStatus.picked.toString().split('.').last.toUpperCase() ||
        status !=
            OrderStatus.delivered.toString().split('.').last.toUpperCase();
  }
}
