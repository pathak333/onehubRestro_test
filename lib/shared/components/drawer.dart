import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/initialize_controllers.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/screens/home/home_screen.dart';
import 'package:onehubrestro/screens/menu/menu_screen.dart';
import 'package:onehubrestro/screens/order-history/order_history_screen.dart';
import 'package:onehubrestro/screens/profile/profile_screen.dart';
import 'package:onehubrestro/screens/splash_screen.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/default_transition.dart';

class AppDrawer extends StatelessWidget {
  SecureStoreMixin secureStoreMixin = Get.find<SecureStoreMixin>();

  LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: ListTile.divideTiles(context: context, color: textGrey, tiles: [
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Text('Menu',
              style: AppTextStyle.getPoppinsSemibold().copyWith(fontSize: 18)),
          trailing: IconButton(
            icon: SvgPicture.asset('lib/assets/icons/close.svg'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Row(
            children: [Text('Home', style: AppTextStyle.getPoppinsSemibold())],
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, DefaulPageTransition(widget: HomeScreen()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Row(
            children: [
              Text('Profile', style: AppTextStyle.getPoppinsSemibold())
            ],
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, DefaulPageTransition(widget: ProfileScreen()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Row(
            children: [Text('Menu', style: AppTextStyle.getPoppinsSemibold())],
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, DefaulPageTransition(widget: MenuScreen()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Row(
            children: [
              Text('Order History', style: AppTextStyle.getPoppinsSemibold())
            ],
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, DefaulPageTransition(widget: OrderHistoryScreen()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Row(
            children: [
              Text('Logout Now', style: AppTextStyle.getPoppinsSemibold()),
              SizedBox(width: 5),
              SvgPicture.asset('lib/assets/icons/arrow_forward.svg'),
            ],
          ),
          onTap: () async {
            await loginController.unregisterToken();
            secureStoreMixin.removeSecureStore('token');
            secureStoreMixin.removeSecureStore('rId');
            OnehubControllers.closeControllers();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false);
          },
        )
      ]).toList(),
    ));
  }
}
