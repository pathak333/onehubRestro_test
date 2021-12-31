import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/models/settlements_response.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class SettlementScreen extends StatelessWidget {
  ProfileController profileController = Get.find<ProfileController>();

  SettlementScreen() {
    profileController.getSettlementsList();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      route: '/profile',
      child: Scaffold(
          appBar: getAppBar('Transaction Details', () {
            Navigator.of(context).pop();
          }),
          body: Obx(() {
            if (!profileController.isLoading.value &&
                profileController.isLoaded.value) {
              if(profileController.settlements.value.length > 0){
                return Container(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: profileController.settlements
                      .map((settlement) =>
                          SettlementCard(settlement: settlement))
                      .toList(),
                ),
              );
              } else {
                return Center(child: Text('No Transactions'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })),
    );
  }
}

class SettlementCard extends StatefulWidget {
  Settlement settlement;

  SettlementCard({this.settlement});

  @override
  _SettlementCardState createState() => _SettlementCardState();
}

class _SettlementCardState extends State<SettlementCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        widget.settlement.date,
                        style:
                            AppTextStyle.getLatoSemibold().copyWith(fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.circle, size: 8),
                      SizedBox(width: 10),
                      Text(
                        widget.settlement.time,
                        style:
                            AppTextStyle.getLatoSemibold().copyWith(fontSize: 14),
                      )
                    ],
                  )),
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 300),
                vsync: this,
                child: Container(
                  color: lightGrey,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (expanded)
                        Column(
                          children: widget.settlement.breakup
                              .map((entry) => Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.label,
                                          style: AppTextStyle.getPoppinsRegular()
                                              .copyWith(fontSize: 14),
                                        ),
                                        Text(
                                          '\u{20B9}${entry.value}',
                                          style: AppTextStyle.getLatoRegular()
                                              .copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      if (expanded) Divider(thickness: 1),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Settlement Amount',
                              style: AppTextStyle.getPoppinsRegular()
                                  .copyWith(fontSize: 18),
                            ),
                            Text(
                              '\u{20B9}${widget.settlement.settlementAmount}',
                              style: AppTextStyle.getLatoSemibold()
                                  .copyWith(fontSize: 18, color: green),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Order ID',
                              style: AppTextStyle.getPoppinsRegular()
                                  .copyWith(fontSize: 12, color: textGrey)),
                          Text(widget.settlement.orderId.toString(),
                              style: AppTextStyle.getPoppinsRegular()
                                  .copyWith(fontSize: 14))
                        ],
                      ),
                      Column(
                        children: [
                          Text('Trasnsaction ID',
                              style: AppTextStyle.getPoppinsRegular()
                                  .copyWith(fontSize: 12, color: textGrey)),
                          Text(widget.settlement.transactionId.toString(),
                              style: AppTextStyle.getPoppinsRegular()
                                  .copyWith(fontSize: 14))
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kSecondaryColor,
                              boxShadow: [BoxShadow(
                                color: kSecondaryColor.withOpacity(0.5),
                                blurRadius: 5,
                                offset: Offset(0,5)
                              )]),
                          child: Center(
                              child: Transform.rotate(
                                angle: expanded ? pi : 0,
                                  child: Icon(Icons.expand_more,
                                      color: Colors.white))),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
        SizedBox(height: 30)
      ],
    );
  }
}
