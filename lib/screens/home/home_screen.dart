import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onehubrestro/controllers/initialize_controllers.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/controllers/order-home/home_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/main.dart';
import 'package:onehubrestro/models/notifications_list.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/home/components/home_tabbar.dart';
import 'package:onehubrestro/screens/home/components/order_card.dart';
import 'package:onehubrestro/screens/home/components/timer_button.dart';
import 'package:onehubrestro/screens/home/notifications_screen.dart';
import 'package:onehubrestro/screens/orders/components/order_details.dart';
import 'package:onehubrestro/screens/splash_screen.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/drawer.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/screen_util.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/shared/components/timer_action_button.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

// firebase start
final _dbReference =
    FirebaseDatabase(databaseURL: 'https://km-production.firebaseio.com')
        .reference();

DatabaseReference _getOrders() {
  // int restaurantId = _restaurantController.restaurant.value.restaurantId;
  DateFormat formatter = DateFormat('ddMMMyyyy');

  return _dbReference.child('orders').child(formatter.format(DateTime.now()));
  // .child('30Nov2021');
}

Stream<List<Order>> getNewOrders({int restaurantId}) {
  var orders =
      _getOrders().orderByChild("restaurant_id").equalTo(restaurantId).onValue;

  final streamToPublish = orders.map((event) {
    if (event.snapshot.value != null) {
      final orderMap = Map<String, dynamic>.from(event.snapshot.value);
      final ordersList = orderMap.values.map((element) {
        return Order.fromJson(Map<String, dynamic>.from(element));
      }).toList();
      ordersList
          .retainWhere((order) => order.orderStatus == OrderStatus.created);
      ordersList.removeWhere((element) => element == null);
      return ordersList;
    } else {
      return <Order>[];
    }
  });

  return streamToPublish;
}

//final UserController userController = Get.put(UserController());
List ison = [];

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  addNotificationToList(message);
  SecureStoreMixin storeMixin = new SecureStoreMixin();
  AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = new AudioCache(
      fixedPlayer: advancedPlayer,
      respectSilence: true,
      prefix: 'lib/assets/sounds/');
  const alarmAudioPath = "orderalert.mpeg";

  storeMixin.getSecureStore("rId", (rId) {
    getNewOrders(restaurantId: int.parse(rId)).listen((event) async {
      print(
          '${advancedPlayer.state.toString()}================================================}');
      if (event.length > 0) {
        // if (ison.length == 0) {
        log(advancedPlayer.state.toString());
        if (advancedPlayer.state == PlayerState.STOPPED && ison.length == 0) {
          print(
              "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
          advancedPlayer = await player.loop(
            alarmAudioPath,
            isNotification: true,
          );
          ison.add(ison.length + 1);
        }
      } else {
        ison = [];
        // advancedPlayer.stop();
        log(advancedPlayer.state.toString());
        player.clearAll();
        advancedPlayer.dispose();
      }
    });
  });
}

Future selectNotification(String payload) async {
  Get.toNamed("/home");
}

void addNotificationToList(RemoteMessage message) {
  SecureStoreMixin storeMixin = SecureStoreMixin();
  storeMixin.getSecureStore("rId", (rId) {
    storeMixin.getSecureStore("n-${rId}", (data) {
      List<RemoteMessage> notifications = remoteMessageListFromJson(data);
      notifications.add(message);
      storeMixin.setSecureStore(
          "n-${rId}", remoteMessageListToJson(notifications));
    });
  });
}

// firebase end
class HomeScreen extends StatelessWidget {
  bool isSwitched = false;

  HomeController homeController;
  RestaurantController restaurantController;
  RealTimeOrdersController realTimeOrdersController;
  OrderController orderController;

  SecureStoreMixin secureStoreMixin;

  HomeScreen() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    secureStoreMixin = Get.find<SecureStoreMixin>();
    try {
      homeController = Get.find<HomeController>();
    } catch (error, stacktrace) {
      homeController = Get.put(HomeController());
    }
    restaurantController = Get.find<RestaurantController>();
    restaurantController.getRestaurantStatus();
    realTimeOrdersController = Get.put(RealTimeOrdersController());
    orderController = Get.put(OrderController());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/home',
      child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Obx(() => (!restaurantController.isLoading.value &&
                  restaurantController.isLoaded.value)
              ? Scaffold(
                  appBar: getHomeAppbar(context),
                  body: Column(
                    children: [
                      HoomeTabBar(
                          homeController: homeController,
                          restaurantId: restaurantController
                              .restaurant.value.restaurantId),
                      ((homeController.selectedStatus.value ==
                              OrderStatus.created)
                          ? (restaurantController.getRestaurant().status)
                              ? Expanded(child: showOnlineStatus(size))
                              : Expanded(child: showOfflineStatus(size))
                          : Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: StreamBuilder(
                                      stream: realTimeOrdersController
                                          .getOrdersByStatus(
                                              restaurantId: restaurantController
                                                  .restaurant
                                                  .value
                                                  .restaurantId,
                                              orderStatus: homeController
                                                  .selectedStatus.value),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var orders =
                                              snapshot.data as List<Order>;
                                          if (orders.length == 0) {
                                            return (restaurantController
                                                    .getRestaurant()
                                                    .status)
                                                ? showOnlineStatus(size)
                                                : showOfflineStatus(size);
                                          } else {
                                            final orders =
                                                snapshot.data as List<Order>;
                                            return ListView(
                                              children: [
                                                ...orders.map((order) {
                                                  return OrderCard(
                                                      orderId: order.orderId);
                                                }).toList()
                                              ],
                                            );
                                          }
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      })))),
                    ],
                  ),
                  bottomSheet: Obx(() => StreamBuilder(
                        stream: realTimeOrdersController.getOrdersByStatus(
                            restaurantId: restaurantController
                                .restaurant.value.restaurantId,
                            orderStatus: OrderStatus.created),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final newOrders = snapshot.data as List<Order>;
                            if (newOrders.length > 0) {
                              return GestureDetector(
                                onTap: () {
                                  for (var index = 0;
                                      index < newOrders.length;
                                      index++) {
                                    showOrderDialog(
                                        context, newOrders.elementAt(index));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: green,
                                  width: size.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                          'lib/assets/icons/expand.svg'),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Text(
                                        'You have ${newOrders.length} new order',
                                        style: AppTextStyle.getPoppinsMedium()
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(height: 0);
                            }
                          } else {
                            return Container(height: 0);
                          }
                        },
                      )))
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ))),
    );
  }

  showOrderDialog(BuildContext context, Order order) {
    var size = MediaQuery.of(context).size;
    var preparationTime = order.leadTime;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (c) => Wrap(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('New Order',
                          style: AppTextStyle.getPoppinsSemibold()
                              .copyWith(fontSize: 18)),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(c);
                          })
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(15),
                  color: green,
                  child: Text(
                    '1 new order',
                    style: AppTextStyle.getPoppinsMedium()
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                ),
                OrderDetails(order: order),
                Container(
                  height: size.height * 0.05,
                  child: ListTile(
                      title: Text('Set food preparation time',
                          style: AppTextStyle.getLatoSemibold()
                              .copyWith(color: textGrey))),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TimerButton(
                      initialTime: order.leadTime,
                      onChange: (time) {
                        preparationTime = time;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Reject',
                            style: AppTextStyle.getPoppinsSemibold()
                                .copyWith(letterSpacing: 2)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: errorRed,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          shape: StadiumBorder(
                              side: BorderSide(color: errorRed, width: 2)),
                        ),
                        onPressed: () async {
                          if (await orderController.rejectOrder(
                              orderId: order.orderId)) {
                            Navigator.pop(c);
                          } else {
                            String message = orderController.errorMessage.value;
                            AppSnackBar.showErrorSnackBar(
                                message: message, width: size.width);
                          }
                        },
                      ),
                      TimerActionButton(
                        secondsRemaining: 5,
                        label: 'Accept',
                        showProgressBar: true,
                        onPressed: () async {
                          if (await orderController.acceptOrder(
                              orderId: order.orderId,
                              preperationTime: preparationTime)) {
                            Navigator.pop(c);
                          } else {
                            String message = orderController.errorMessage.value;
                            AppSnackBar.showErrorSnackBar(
                                message: message, width: size.width);
                          }
                        },
                      )
                    ],
                  ),
                ),
                // SizedBox(height: 10)
              ],
            ));
  }

  Widget showOfflineStatus(Size size) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(
            image: ImageView.provideImage(
                type: Sourcetype.asset,
                src: 'lib/assets/images/hotel_closed.png')),
        SizedBox(height: size.height * 0.05),
        Text(
          'You are offline',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Lato',
              color: textGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Text(
          'Visit Support for ',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Lato',
              color: textGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        )
      ]),
    );
  }

  Widget showOnlineStatus(Size size) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(
            image: ImageView.provideImage(
                type: Sourcetype.asset,
                src: 'lib/assets/images/hotel_opened.png')),
        SizedBox(height: size.height * 0.05),
        Text(
          'You are online',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Lato',
              color: textGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Text(
          'Waiting for new orders',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Lato',
              color: textGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        )
      ]),
    );
  }

  AppBar getHomeAppbar(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // ScreenUtil.getInstance().init(context);
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 10,
      shadowColor: lightGrey,
      title: GetX<RestaurantController>(builder: (controller) {
        if (!controller.isLoading.value && controller.isLoaded.value) {
          return Row(children: [
            FlutterSwitch(
              width: 100,
              toggleSize: 20.0,
              value: controller.getRestaurant().status,
              borderRadius: 30.0,
              padding: size.height * 0.0045,
              activeColor: green,
              inactiveColor: grey,
              activeTextColor: Colors.white,
              inactiveTextColor: Colors.black,
              activeText: "Online",
              inactiveText: "Offline",
              showOnOff: true,
              onToggle: (status) async {
                if (!await restaurantController
                    .updateRestaurantStatus(status)) {
                  String message = restaurantController.errorMessage.value;
                  AppSnackBar.showErrorSnackBar(
                      message: message, width: size.width);
                }
              },
            ),
            SizedBox(width: 10),
            // Text('${controller.getRestaurant().restaurantId}', style: TextStyle(color: black),),
            if (!controller.getRestaurant().status)
              Text(
                'View Details',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline),
              ),
          ]);
        } else {
          return Container();
        }
      }),
      actions: [
        Obx(
          () => GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(SlidePageTransition(widget: NotificationScreen()));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.notifications_outlined,
                        size: 30, color: black),
                    onPressed: () {}),
                if (homeController.notifications != null &&
                    homeController.notifications.length > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: kSecondaryColor,
                      child: Center(
                        child: Text(
                          homeController.notifications.length.toString(),
                          style: AppTextStyle.getPoppinsRegular()
                              .copyWith(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      radius: 10,
                    ),
                  )
              ],
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.menu, size: 35, color: black),
            onPressed: () {
              Navigator.push(context, SlidePageTransition(widget: AppDrawer()));
            }),
      ],
    );
  }
}
