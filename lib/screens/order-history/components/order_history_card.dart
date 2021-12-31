import 'package:flutter/material.dart';
import 'package:onehubrestro/models/order-history/order_history_response.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/home/components/icons.dart';
import 'package:onehubrestro/screens/order-history/history_detail_screen.dart';
import 'package:onehubrestro/screens/orders/order_detail_screen.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class OrderHistoryCard extends StatelessWidget {

  OrderHistoryCard({this.order});

  OrderItem order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Container(
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID: ${order.projectId}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Chip(
                        label: Text(order.status.toUpperCase(),
                            style: AppTextStyle.getPoppinsSemibold().copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 2)),
                        backgroundColor: getChipColor(order.status) ? errorRed : green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            order.time,
                            style: AppTextStyle.getLatoSemibold()
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 5),
                          Text(
                            order.date,
                            style: AppTextStyle.getLatoSemibold()
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Text(
                        '₹${order.totalPrice}',
                        style: AppTextStyle.getLatoSemibold()
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
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
                  children: order.products.map((product) => ListTile(
                      horizontalTitleGap: 0,
                      leading: getNonVegIcon(),
                      title: Text('${product.quantity} x ${product.name}'),
                    )).toList()
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
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: kSecondaryColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      SlidePageTransition(
                          widget: HistoryDetailScreen(order: order,)));
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 15)
      ],
    );
  }

  getChipColor(String status){
    return status != OrderStatus.preparing.toString().split('.').last
    || status != OrderStatus.ready.toString().split('.').last
    || status != OrderStatus.picked.toString().split('.').last
    || status != OrderStatus.delivered.toString().split('.').last;
  }
}
