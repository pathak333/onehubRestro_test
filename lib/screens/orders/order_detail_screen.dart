import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/orders/components/order_details.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/shared/components/timer_action_button.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';
import 'package:onehubrestro/shared/components/animated/animated_dot.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({this.orderId});

  final int orderId;

  OrderController orderController = Get.find<OrderController>();
  RestaurantController restaurantController = Get.find<RestaurantController>();
  RealTimeOrdersController realTimeOrdersController =
      Get.find<RealTimeOrdersController>();

  String getStatus(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.preparing:
        return 'Preparing';
        break;
      case OrderStatus.ready:
        return 'Ready';
        break;
      case OrderStatus.picked:
        return 'Picked Up';
        break;
    }
    return 'Order Details';
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppContainer(
      route: '/home',
      child: StreamBuilder(
          stream: realTimeOrdersController.getOrderById(
              restaurantId: restaurantController.restaurant.value.restaurantId,
              orderId: orderId),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              Order order = snapshot.data;

              int remainingSeconds = (order.pickupTime != null)
                  ? order.pickupTime.seconds.difference(DateTime.now()).inSeconds
                  : 0;

              if(remainingSeconds < 0){
                remainingSeconds = 0;
              }
              
              return Scaffold(
                  appBar: getApplicationAppbar(
                      title: Text(getStatus(order.orderStatus))),
                  body: ListView(
                    children: [
                      OrderDetails(order: order),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: buildDeliveryInformation(
                            size, context, order.deliveryDetails),
                      ),
                      SizedBox(height: size.height * 0.02),
                      if (order.orderStatus == OrderStatus.preparing)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TimerActionButton(
                              secondsRemaining: remainingSeconds,
                              label: 'Order Ready',
                              showProgressBar: false,
                              onPressed: () async {
                                if (await orderController.markOrderReady(
                                    orderId: order.orderId)) {
                                  Navigator.pop(context);
                                } else {
                                  String message =
                                      orderController.errorMessage.value;
                                  AppSnackBar.showErrorSnackBar(
                                      message: message, width: size.width);
                                }
                              },
                            ),
                          ),
                        )
                    ],
                  ));
            } else {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }

  Widget buildDeliveryInformation(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    switch (deliveryDetails.status) {
      case DeliveryStatus.notcreated:
        return orderPreparingDialog(size, context, deliveryDetails);
        break;
      case DeliveryStatus.searching:
        return searchingPartnerDialog(size, context, deliveryDetails);
        break;
      case DeliveryStatus.assigned:
        return riderArrivingDialog(size, context, deliveryDetails);
        break;
      case DeliveryStatus.reached:
        return riderReachedDialog(size, context, deliveryDetails);
        break;
      case DeliveryStatus.picked:
        return orderPickedDialog(size, context, deliveryDetails);
        break;
      case DeliveryStatus.delivered:
        return orderDeliveredDialog(size, context, deliveryDetails);
        break;
    }
    return Container();
  }

  Container orderPreparingDialog(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedDot(color: kSecondaryColor),
              SizedBox(width: size.width * 0.02),
              Expanded(
                  child: Text('Delivery partner will be assigned shortly',
                      style: Theme.of(context).textTheme.headline6)),
              SizedBox(width: size.width * 0.02),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, top: 10),
            child: Text(
              'Kindly continue food preparation,' +
                  'delivery partner will reach your outlet ' +
                  'just before order is ready',
              style: AppTextStyle.getLatoSemibold()
                  .copyWith(color: textGrey, fontSize: 14),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: grey, width: 1)),
    );
  }

  Container searchingPartnerDialog(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          AnimatedDot(color: kSecondaryColor),
          SizedBox(width: size.width * 0.02),
          Expanded(
              child: Text('Searching nearby delivery partners',
                  style: AppTextStyle.getLatoSemibold())),
          SizedBox(width: size.width * 0.02),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: grey, width: 1)),
    );
  }

  Container riderArrivingDialog(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    return Container(
      child: ListTile(
        horizontalTitleGap: 0,
        tileColor: Colors.transparent,
        leading: ImageView.displayImage(
            src: 'lib/assets/images/mahesh.png', type: Sourcetype.asset),
        title: Text('${deliveryDetails.agentName} is arriving',
            style: AppTextStyle.getPoppinsSemibold()),
        trailing: IconButton(
          icon: SvgPicture.asset('lib/assets/icons/call.svg'),
          onPressed: () {
            callAgent(deliveryDetails);
          },
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: grey, width: 1)),
    );
  }

  Container riderReachedDialog(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    return Container(
      child: ListTile(
        horizontalTitleGap: 0,
        tileColor: Colors.transparent,
        leading: ImageView.displayImage(
            src: 'lib/assets/images/mahesh.png', type: Sourcetype.asset),
        title: Text('${deliveryDetails.agentName} reached the location',
            style: AppTextStyle.getPoppinsSemibold()),
        trailing: IconButton(
          icon: SvgPicture.asset('lib/assets/icons/call.svg'),
          onPressed: () {
            callAgent(deliveryDetails);
          },
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: grey, width: 1)),
    );
  }

  Container orderPickedDialog(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    return Container(
      child: ListTile(
        horizontalTitleGap: 0,
        tileColor: Colors.transparent,
        leading: ImageView.displayImage(
            src: 'lib/assets/images/mahesh.png', type: Sourcetype.asset),
        title: Text('${deliveryDetails.agentName} picked up the order',
            style: AppTextStyle.getPoppinsSemibold()),
        trailing: IconButton(
          icon: SvgPicture.asset('lib/assets/icons/call.svg'),
          onPressed: () {
            callAgent(deliveryDetails);
          },
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: grey, width: 1)),
    );
  }

  Container orderDeliveredDialog(
      Size size, BuildContext context, DeliveryDetails deliveryDetails) {
    return Container(
      height: size.height * 0.2,
      child: Column(
        children: [
          Expanded(
              flex: 6,
              child: Container(
                  decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: ListTile(
                      minVerticalPadding: 10,
                      tileColor: Colors.transparent,
                      title: Text('Order was prepared in time',
                          style: AppTextStyle.getPoppinsSemibold()),
                      subtitle: Text('Timely delivery to the customer',
                          style: AppTextStyle.getLatoSemibold()),
                      trailing: Lottie.asset(
                          'lib/assets/icons/animated/checked.json',
                          repeat: false,
                          height: 60,
                          width: 60)))),
          Expanded(
              flex: 4,
              child: Container(
                child: ListTile(
                  horizontalTitleGap: 0,
                  tileColor: Colors.transparent,
                  leading: Image(
                      image: ImageView.provideImage(
                          src: 'lib/assets/images/mahesh.png',
                          type: Sourcetype.asset)),
                  title: Text('${deliveryDetails.agentName} delivered the food',
                      style: AppTextStyle.getPoppinsSemibold()),
                  trailing: IconButton(
                    icon: SvgPicture.asset('lib/assets/icons/call.svg'),
                    onPressed: () {
                      callAgent(deliveryDetails);
                    },
                  ),
                ),
              ))
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: grey, width: 1)),
    );
  }

  void callAgent(DeliveryDetails deliveryDetails) async {
    String url = 'tel:${deliveryDetails.agentPhone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      String message = 'Cannot call the agent';
      AppSnackBar.showErrorSnackBar(message: message, width: double.infinity);
    }
  }
}
