import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/controllers/order-home/home_controller.dart';
import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/models/notifications_list.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/screens/home/home_screen.dart';
import 'package:onehubrestro/screens/home/notifications_screen.dart';
import 'package:onehubrestro/screens/login/login_screen.dart';
import 'package:onehubrestro/screens/maintainence/no_internet.dart';
import 'package:onehubrestro/screens/menu/edit/add_timings.dart';
import 'package:onehubrestro/screens/menu/menu_screen.dart';
import 'package:onehubrestro/screens/order-history/order_history_screen.dart';
import 'package:onehubrestro/screens/profile/profile_screen.dart';
import 'package:onehubrestro/screens/splash_screen.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'package:onehubrestro/utilities/theme.dart';
import 'package:onehubrestro/utilities/transitions/default_transition.dart';
import 'package:onehubrestro/utilities/transitions/fade_transition.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

final ReceivePort backgroundMessageport = ReceivePort();
const String backgroundMessageIsolateName = 'fcm_background_msg_isolate';

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final port =
        IsolateNameServer.lookupPortByName(backgroundMessageIsolateName);
    port.send(message);
  }
}

void backgroundMessagePortHandler(message) {
  final dynamic data = message['data'];
  print("________________________$message");
  print("________________________$data");
  // Here I can access and update my top-level variables.
}

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'order_alert_channel', // id
//     'Order alerts channel', // title
//     description: 'This channel is used for order alerts.', // description
//     importance: Importance.high,
//     playSound: true,
//     sound: RawResourceAndroidNotificationSound('orderalert'));

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// final _dbReference =
//     FirebaseDatabase(databaseURL: 'https://km-production.firebaseio.com')
//         .reference();

// DatabaseReference _getOrders() {
//   // int restaurantId = _restaurantController.restaurant.value.restaurantId;
//   DateFormat formatter = DateFormat('ddMMMyyyy');

//   return _dbReference.child('orders').child(formatter.format(DateTime.now()));
//   // .child('30Nov2021');
// }

// Stream<List<Order>> getNewOrders({int restaurantId}) {
//   var orders =
//       _getOrders().orderByChild("restaurant_id").equalTo(restaurantId).onValue;

//   final streamToPublish = orders.map((event) {
//     if (event.snapshot.value != null) {
//       final orderMap = Map<String, dynamic>.from(event.snapshot.value);
//       final ordersList = orderMap.values.map((element) {
//         return Order.fromJson(Map<String, dynamic>.from(element));
//       }).toList();
//       ordersList
//           .retainWhere((order) => order.orderStatus == OrderStatus.created);
//       ordersList.removeWhere((element) => element == null);
//       return ordersList;
//     } else {
//       return <Order>[];
//     }
//   });

//   return streamToPublish;
// }

// //final UserController userController = Get.put(UserController());
// List ison = [];

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   addNotificationToList(message);
//   SecureStoreMixin storeMixin = new SecureStoreMixin();
//   AudioPlayer advancedPlayer = AudioPlayer();
//   AudioCache player = new AudioCache(
//       fixedPlayer: advancedPlayer,
//       respectSilence: true,
//       prefix: 'lib/assets/sounds/');
//   const alarmAudioPath = "orderalert.mpeg";

//   storeMixin.getSecureStore("rId", (rId) {
//     getNewOrders(restaurantId: int.parse(rId)).listen((event) async {
//       print(
//           '${advancedPlayer.state.toString()}================================================}');
//       if (event.length > 0) {
//         // if (ison.length == 0) {
//         log(advancedPlayer.state.toString());
//         if (advancedPlayer.state == PlayerState.STOPPED && ison.length == 0) {
//           print(
//               "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
//           advancedPlayer = await player.loop(
//             alarmAudioPath,
//             isNotification: true,
//           );
//           ison.add(ison.length + 1);
//         }
//       } else {
//         ison = [];
//         // advancedPlayer.stop();
//         log(advancedPlayer.state.toString());
//         player.clearAll();
//         advancedPlayer.dispose();
//       }
//     });
//   });
// }

// Future selectNotification(String payload) async {
//   Get.toNamed("/home");
// }

// void addNotificationToList(RemoteMessage message) {
//   SecureStoreMixin storeMixin = SecureStoreMixin();
//   storeMixin.getSecureStore("rId", (rId) {
//     storeMixin.getSecureStore("n-${rId}", (data) {
//       List<RemoteMessage> notifications = remoteMessageListFromJson(data);
//       notifications.add(message);
//       storeMixin.setSecureStore(
//           "n-${rId}", remoteMessageListToJson(notifications));
//     });
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // MethodChannel _channel =
  //     MethodChannel('com.bulbandkey.onehubrestro/order_alerts_channel');

  // await _channel.invokeMethod('orderChannel');

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
// isolate code for notification
  IsolateNameServer.registerPortWithName(
    backgroundMessageport.sendPort,
    backgroundMessageIsolateName,
  );

  backgroundMessageport.listen(backgroundMessagePortHandler);

  runApp(OneHubRestro());
}

printID() async {
  var deviceID = await FirebaseMessaging.instance.getToken();
  print(
      '$deviceID+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
}

class OneHubRestro extends StatelessWidget {
  // This widget is the root of your application.

  NavigationController navigationController = Get.put(NavigationController());
  HomeController homeController = Get.put(HomeController());

  OneHubRestro() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      homeController.addNotificationToList(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    printID();
    return Center(
        child: GetMaterialApp(
      title: 'Hub Restaurant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return FadePageTransition(widget: SplashScreen());
            break;
          case '/splash':
            return FadePageTransition(widget: SplashScreen());
            break;
          case '/login':
            return FadePageTransition(widget: LoginScreen());
            break;
          case '/home':
            return SlidePageTransition(widget: HomeScreen());
            break;
          case '/menu':
            return SlidePageTransition(widget: MenuScreen());
            break;
          case '/order-history':
            return DefaulPageTransition(widget: OrderHistoryScreen());
            break;
          case '/profile':
            return DefaulPageTransition(widget: ProfileScreen());
            break;
          case '/no-internet':
            return DefaulPageTransition(widget: NoInternet());
            break;
          case '/noti':
            return DefaulPageTransition(widget: NotificationScreen());
            break;
          default:
            return SlidePageTransition(widget: HomeScreen());
            break;
        }
      },
    ));
  }
}
