import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class OrderHistoryHeader extends StatefulWidget {
  OrderHistoryHeader({this.sDate, this.eDate, this.onDateSelected});
  DateTime sDate, eDate;
  Function(DateTime, DateTime) onDateSelected;

  @override
  _OrderHistoryHeaderState createState() => _OrderHistoryHeaderState();
}

class _OrderHistoryHeaderState extends State<OrderHistoryHeader> {
  DateTime startDate;
  DateTime endDate;

  DateFormat formatter = DateFormat('dd MMM');

  OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          (orderController.pastOrdersStartDate.value == null &&
                  orderController.pastOrdersEndDate.value == null)
              ? Container(
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                      child: Row(
                        children: [
                          Text(
                            'Select Date',
                            style: AppTextStyle.getPoppinsSemibold()
                                .copyWith(fontSize: 14),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.expand_more)
                        ],
                      ),
                      onTap: () async {
                        final DateTimeRange pickedDateRange =
                            await showDateRangePicker(
                                context: context,
                                builder: (context, Widget child) => Theme(
                                      data: ThemeData(
                                          appBarTheme: AppBarTheme(
                                              backgroundColor:
                                                  kSecondaryColor)),
                                      child: child,
                                    ),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate: DateTime.now());
                        if (pickedDateRange != null)
                          setState(() {
                            startDate = pickedDateRange.start;
                            orderController.pastOrdersStartDate = startDate.obs;

                            endDate = pickedDateRange.end;
                            orderController.pastOrdersEndDate = endDate.obs;

                            widget.onDateSelected(startDate, endDate);
                          });
                      }),
                )
              : GestureDetector(
                  onTap: () async {
                    final DateTimeRange pickedDateRange1 =
                        await showDateRangePicker(
                            initialDateRange: DateTimeRange(
                                start: widget.sDate, end: widget.eDate),
                            context: context,
                            builder: (context, Widget child) => Theme(
                                  data: ThemeData(
                                      appBarTheme: AppBarTheme(
                                          backgroundColor: kSecondaryColor)),
                                  child: child,
                                ),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now());
                    if (pickedDateRange1 != null)
                      setState(() {
                        startDate = pickedDateRange1.start;
                        orderController.pastOrdersStartDate = startDate.obs;

                        endDate = pickedDateRange1.end;
                        orderController.pastOrdersEndDate = endDate.obs;

                        widget.onDateSelected(startDate, endDate);
                      });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: kSecondaryColor),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Text(
                          '${formatter.format(orderController.pastOrdersStartDate.value)} - ${formatter.format(orderController.pastOrdersEndDate.value)} ',
                          style: AppTextStyle.getPoppinsSemibold()
                              .copyWith(fontSize: 14, color: kSecondaryColor),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.expand_more, color: kSecondaryColor)
                      ],
                    ),
                  ),
                ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                startDate = null;
                orderController.pastOrdersStartDate.value = null;

                endDate = null;
                orderController.pastOrdersEndDate.value = null;

                widget.onDateSelected(startDate, endDate);
              });
            },
            child: Text(
              'CLEAR FILTERS',
              style: AppTextStyle.getPoppinsSemibold()
                  .copyWith(fontSize: 14, color: grey),
            ),
          ),
        ],
      ),
    );
  }
}
