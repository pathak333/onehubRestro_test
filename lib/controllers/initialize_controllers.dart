import 'package:get/get.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/menu/menu-controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/controllers/order-home/home_controller.dart';
import 'package:onehubrestro/controllers/orders/orders_controller.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';

class OnehubControllers {
  // static initilazeController(){
  //   // LoginController loginController = Get.put(LoginController());
  //   // HomeController homeController = Get.put(HomeController());
  //   // OrderController orderController = Get.put(OrderController());
  //   // UserController userController = Get.put(UserController());
  //   // NavigationController navigationController = Get.put(NavigationController());
  // }
  
  static closeControllers(){
    Get.delete<LoginController>();
    Get.delete<HomeController>();
    Get.delete<OrderController>();
    Get.delete<UserController>();
    Get.delete<RealTimeOrdersController>();
    Get.delete<RestaurantController>();
    Get.delete<NavigationController>();
    Get.delete<MenuController>();
    Get.delete<ProfileController>();
  }
  
}