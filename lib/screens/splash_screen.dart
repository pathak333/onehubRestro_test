import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/app_version_contoller.dart';
import 'package:onehubrestro/controllers/initialize_controllers.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'dart:ui' as prefix0;
import 'dart:io';

import 'package:onehubrestro/utilities/test_styles.dart';

class SplashScreen extends StatelessWidget {
  SecureStoreMixin secureStoreMixin = Get.put(new SecureStoreMixin());

  UserController userController;
  NavigationController navigationController;
  AppVersionController appVersionController;

  SplashScreen() {
    // OnehubControllers.initilazeController();
    try{
      userController = Get.find<UserController>();
    } catch(error, stacktrace){
      userController = Get.put(UserController());
    }
    navigationController = Get.put(NavigationController());
    appVersionController = AppVersionController();

    navigationController.setRoute('/splash');
  }

  @override
  Widget build(BuildContext context) {
    // secureStoreMixin.setSecureStore('token', '60f838d569803bebd416f9cf');

    Future.delayed(const Duration(seconds: 2), () async {
      if (await appVersionController.isNewVersion()) {
        _showUpdateDialog(context);
      } else {
        secureStoreMixin.getSecureStore('token', (token) {
          if (token != null) {
            userController.updateToken(token);
            RestaurantController restaurantController =
                Get.put(RestaurantController());
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }
        });
      }
    });

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkNavyBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: SvgPicture.asset('lib/assets/icons/logo.svg'))
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) async {
    var size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
          },
          child: new BackdropFilter(
              filter: prefix0.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: IntrinsicWidth(
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "There is a new version available. Please update to the latest version",
                            style: AppTextStyle.getPoppinsMedium()
                                .copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Divider(),
                              TextButton(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text('Update',
                                          style:
                                              AppTextStyle.getPoppinsSemibold()
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: kSecondaryColor))),
                                  onPressed: () async {
                                    secureStoreMixin.getSecureStore('token',
                                        (token) {
                                      if (token != null) {
                                        userController.updateToken(token);
                                        RestaurantController
                                            restaurantController =
                                            Get.put(RestaurantController());
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/home',
                                            (route) => false);
                                      } else {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (route) => false);
                                      }
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
