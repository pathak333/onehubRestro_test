import 'package:flutter/material.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/home/components/icons.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class OrderDetails extends StatelessWidget {
  OrderDetails({this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        children: [
          Container(
            height: size.height * 0.05,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ID: ${order.orderId}',
                      style: AppTextStyle.getPoppinsMedium()),
                  Text('${order.pickupTimeDisplay}',
                      style: AppTextStyle.getPoppinsSemibold())
                ],
              ),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          ListTile(
              title: Row(
            children: [
              if (order.orderStatus != null)
                Chip(
                  label: Text(
                      order.orderStatus
                          .toString()
                          .split('.')
                          .last
                          .toUpperCase(),
                      style: AppTextStyle.getPoppinsSemibold().copyWith(
                          color: Colors.white, fontSize: 12, letterSpacing: 2)),
                  backgroundColor: purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              if (order.orderStatus != null) SizedBox(width: size.width * 0.02),
              Expanded(
                child: Text('1 order by ${order.customer}',
                    style: AppTextStyle.getLatoSemibold()
                        .copyWith(color: kSecondaryColor)),
              )
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color: grey,
            ),
          ),
          Container(
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${product.quantity} x ${product.name}',
                                  style: AppTextStyle.getLatoBold()),
                              Text(
                                '₹${product.price}',
                                style: AppTextStyle.getLatoSemibold(),
                              )
                            ],
                          ),
                        ))
                    .toList()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color: grey,
            ),
          ),
          ListTile(
              title: Row(
            children: [
              Text('Total Bill:',
                  style:
                      AppTextStyle.getLatoSemibold().copyWith(color: textGrey)),
              SizedBox(width: size.width * 0.02),
              Text(
                  '₹ ${order.subTotal + order.shippingAmount + order.tax + 10}',
                  style: AppTextStyle.getPoppinsSemibold()
                      .copyWith(color: textGrey)),
              SizedBox(width: size.width * 0.02),
              Chip(
                label: Text('Paid'.toUpperCase(),
                    style: AppTextStyle.getPoppinsRegular().copyWith(
                        color: Colors.white, fontSize: 12, letterSpacing: 2)),
                backgroundColor: green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
