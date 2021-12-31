import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/models/order-history/order_history_parameters.dart';
import 'package:onehubrestro/screens/order-history/components/history_list_header.dart';
import 'package:onehubrestro/screens/order-history/components/no-order.dart';
import 'package:onehubrestro/screens/order-history/components/order_history_card.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderController orderController = Get.find<OrderController>();

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  int page = 1;
  DateTime startDate, endDate;

  OrderHistoryScreen() {
    orderController.getPastOrders(OrderListParameters(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppContainer(
        route: '/order-history',
        child: Scaffold(
            appBar: getApplicationAppbar(
                allowBackNavigation: false,
                context: context,
                title: Text('Order History',
                    style: AppTextStyle.getPoppinsSemibold()
                        .copyWith(fontSize: 18))),
            // body: NoOrderComponent(),
            body: Obx(() {
              if (!orderController.isLoading.value &&
                  orderController.isLoaded.value) {
                if (orderController.pastOrders.length == 0) {
                  return NoOrderComponent();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        OrderHistoryHeader(
                          onDateSelected: (stDate, edDate) {
                            startDate = stDate;
                            endDate = edDate;
                            orderController.getPastOrders(OrderListParameters(
                                page: 1,
                                startDate: formatter.format(stDate),
                                endDate: formatter.format(edDate)));
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Column(
                            children: orderController.pastOrders
                                .map((order) => OrderHistoryCard(order: order))
                                .toList()),
                        Align(
                          child: (!orderController.isMoreLoading.value &&
                                  orderController.isMoreLoaded.value)
                              ? ElevatedButton(
                                  child: Text('View More',
                                      style: AppTextStyle.getPoppinsBold()
                                          .copyWith(
                                              fontSize: 14,
                                              color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    primary: kSecondaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    page++;
                                    if (await orderController.getPastOrders(
                                        OrderListParameters(
                                            page: page,
                                            startDate: startDate != null
                                                ? formatter.format(startDate)
                                                : null,
                                            endDate: endDate != null
                                                ? formatter.format(endDate)
                                                : null))) {
                                    } else {
                                      String message =
                                          orderController.errorMessage.value;
                                      AppSnackBar.showErrorSnackBar(
                                          message: message, width: size.width);
                                    }
                                  })
                              : Center(child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })));
  }
}
