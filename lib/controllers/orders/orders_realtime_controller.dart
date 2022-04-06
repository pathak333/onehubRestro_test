import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/state_manager.dart';
import 'package:get/get.dart' as getPackage;
// import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';

import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';

class RealTimeOrdersController extends GetxController
    with WidgetsBindingObserver {
  final _dbReference =
      FirebaseDatabase(databaseURL: 'https://km-production.firebaseio.com')
          .reference();

  final RestaurantController _restaurantController =
      getPackage.Get.find<RestaurantController>();

  final UserController userController = Get.find<UserController>();

  RxList newOrders = [].obs;
  RxList ordersPreparing = [].obs;
  RxList readyOrders = [].obs;
  RxList pickedOrders = [].obs;

  final String ORDER_STATUS_PATH = 'order_status';

  bool _isInForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('${state.toString()}VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV');
    _isInForeground =
        state == AppLifecycleState.resumed || state == AppLifecycleState.paused;
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    SecureStoreMixin storeMixin = new SecureStoreMixin();
    AudioPlayer advancedPlayer = AudioPlayer();
    AudioCache player = new AudioCache(
        fixedPlayer: advancedPlayer,
        respectSilence: true,
        prefix: 'lib/assets/sounds/');
    const alarmAudioPath = "orderalert.mpeg";
    storeMixin.getSecureStore("rId", (rId) async {
      List ison = [];
      getNewOrders(restaurantId: int.parse(rId)).listen((event) async {
        if (event.length > 0) {
          // AndroidNotificationChannel channel = AndroidNotificationChannel(
          //   'order_alert_silent_channel', // id
          //   'Order alerts silent channel', // title
          //   description:
          //       'This channel is used for order silent alerts.', // description
          //   importance: Importance.high,
          //   playSound: false,
          //   // sound: RawResourceAndroidNotificationSound('orderalert')
          // );

          // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          //     FlutterLocalNotificationsPlugin();

          // final AndroidInitializationSettings initializationSettingsAndroid =
          //     AndroidInitializationSettings('@mipmap/ic_icon');

          // final IOSInitializationSettings initializationSettingsIOS =
          //     IOSInitializationSettings(
          //   requestSoundPermission: false,
          //   requestBadgePermission: false,
          //   requestAlertPermission: false,
          //   onDidReceiveLocalNotification: null,
          // );

          // final InitializationSettings initializationSettings =
          //     InitializationSettings(
          //         android: initializationSettingsAndroid,
          //         iOS: initializationSettingsIOS,
          //         macOS: null);

          // await flutterLocalNotificationsPlugin.initialize(
          //     initializationSettings,
          //     onSelectNotification: selectNotification);

          // advancedPlayer =
          //     await player.loop(alarmAudioPath, isNotification: true);
          if (_isInForeground) {
            // if (ison.length == 0) {
            log(advancedPlayer.state.toString());
            if (advancedPlayer.state == PlayerState.STOPPED &&
                ison.length == 0) {
              advancedPlayer =
                  await player.loop(alarmAudioPath, isNotification: true);
              ison.add(ison.length + 1);
            }
            // event.forEach((element) async {

            // flutterLocalNotificationsPlugin.show(
            //     event.first.orderId,
            //     "---You have received an new order",
            //     "--Please click here to accept the order",
            //     NotificationDetails(
            //         android: AndroidNotificationDetails(
            //             channel.id, channel.name,
            //             channelDescription: channel.description,
            //             color: Colors.blue,
            //             playSound: false,
            //             // sound: RawResourceAndroidNotificationSound('orderalert'),
            //             icon: '@mipmap/ic_icon')),
            //     payload: '{order_id: ${event[0].orderId}}');
            // userController.sounds[element.orderId] = advancedPlayer;

            //  });
          }
          // event.forEach((element) async {
          //   //  if (!userController.sounds.containsKey(element.orderId)) {
          //   //element.isBuzzerOn = true;

          //   // refresh();
          //   if (ison.contains(element.orderId) == false) {
          //     ison.add(element.orderId);
          //     var data = element.toJson();
          //     //data['is_buzzer_on'] = true;
          //     print(
          //         '$data}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');
          //     // _dbReference
          //     //     .child('orders')
          //     //     // .child('30Nov2021')
          //     //     // .child(element.orderId.toString())
          //     //     .orderByChild("order_id")
          //     //     .equalTo(element.orderId)
          //     //     .reference()
          //     //     .update(data)
          //     //     .onError((error, stackTrace) => print(
          //     //         '$error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'));

          //     // userController.sounds[element.orderId] = advancedPlayer;
          //   }
          // });

        } else {
          ison = [];
          log(advancedPlayer.state.toString());
          advancedPlayer.stop();
          //player.clearAll();
          //advancedPlayer.dispose();
        }
      });
    });

    super.onInit();
  }

  Future selectNotification(String payload) async {
    Get.toNamed("/home");
  }

  Stream<List<Order>> getOrdersByStatus(
      {int restaurantId, OrderStatus orderStatus}) {
    switch (orderStatus) {
      case OrderStatus.created:
        return getNewOrders(restaurantId: restaurantId);
        break;

      case OrderStatus.ready:
        return getReadyOrders(restaurantId: restaurantId);
        break;
      case OrderStatus.picked:
        return getPickedOrders(restaurantId: restaurantId);
        break;
      case OrderStatus.preparing:
        return getPreparingOrders(restaurantId: restaurantId);
        // print(abc);
        // return abc;
        break;
      default:
        return null;
    }
  }

  Stream<List<Order>> getPreparingOrders({int restaurantId}) {
    var orders = _getOrders()
        .orderByChild("restaurant_id")
        .equalTo(restaurantId)
        .onValue;

    final streamToPublish = orders.map((event) {
      if (event.snapshot.value != null) {
        final orderMap = Map<String, dynamic>.from(event.snapshot.value);
        final ordersList = orderMap.values.map((element) {
          return Order.fromJson(Map<String, dynamic>.from(element));
        }).toList();
        ordersList
            .retainWhere((order) => order.orderStatus == OrderStatus.preparing);
        return ordersList;
      } else {
        return <Order>[];
      }
    });

    return streamToPublish;
  }

  Stream<List<Order>> getReadyOrders({int restaurantId}) {
    var orders = _getOrders()
        .orderByChild("restaurant_id")
        .equalTo(restaurantId)
        .onValue;

    final streamToPublish = orders.map((event) {
      if (event.snapshot.value != null) {
        final orderMap = Map<String, dynamic>.from(event.snapshot.value);
        final ordersList = orderMap.values.map((element) {
          return Order.fromJson(Map<String, dynamic>.from(element));
        }).toList();
        ordersList
            .retainWhere((order) => order.orderStatus == OrderStatus.ready);
        ordersList.removeWhere((element) => element == null);
        return ordersList;
      } else {
        return <Order>[];
      }
    });

    return streamToPublish;
  }

  Stream<List<Order>> getPickedOrders({int restaurantId}) {
    var orders = _getOrders()
        .orderByChild("restaurant_id")
        .equalTo(restaurantId)
        .onValue;

    final streamToPublish = orders.map((event) {
      if (event.snapshot.value != null) {
        final orderMap = Map<String, dynamic>.from(event.snapshot.value);
        final ordersList = orderMap.values.map((element) {
          return Order.fromJson(Map<String, dynamic>.from(element));
        }).toList();
        ordersList
            .retainWhere((order) => order.orderStatus == OrderStatus.picked);
        ordersList.removeWhere((element) => element == null);
        return ordersList;
      } else {
        return <Order>[];
      }
    });

    return streamToPublish;
  }

  Stream<List<Order>> getNewOrders({int restaurantId}) {
    var orders = _getOrders()
        .orderByChild("restaurant_id")
        .equalTo(restaurantId)
        .onValue;

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

  Stream<Order> getOrderById({int restaurantId, int orderId}) {
    DateFormat formatter = DateFormat('ddMMMyyyy');
    var orders = _dbReference
        .child('orders')
        .child(formatter.format(DateTime.now()))
        // .child('30Nov2021')
        .child(orderId.toString())
        .onValue;

    final streamToPublish = orders.map((event) {
      if (event.snapshot.value != null) {
        return Order.fromJson(Map<String, dynamic>.from(event.snapshot.value));
      } else {
        return null;
      }
    });

    return streamToPublish;
  }

  DatabaseReference _getOrders() {
    // int restaurantId = _restaurantController.restaurant.value.restaurantId;
    DateFormat formatter = DateFormat('ddMMMyyyy');

    return _dbReference.child('orders').child(formatter.format(DateTime.now()));
    // .child('30Nov2021');
  }
}
