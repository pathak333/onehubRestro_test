import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/initialize_controllers.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';
import 'package:onehubrestro/screens/profile/bank_details_screen.dart';
import 'package:onehubrestro/screens/profile/disclosures_screen.dart';
import 'package:onehubrestro/screens/profile/help_screen.dart';
import 'package:onehubrestro/screens/profile/manager_details-screen.dart';
import 'package:onehubrestro/screens/profile/owner_screen.dart';
import 'package:onehubrestro/screens/profile/restaurant_details_screen.dart';
import 'package:onehubrestro/screens/profile/settlements_screen.dart';
import 'package:onehubrestro/screens/splash_screen.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class ProfileScreen extends StatelessWidget {
  RestaurantController restaurantController = Get.find<RestaurantController>();
  SecureStoreMixin secureStoreMixin = Get.find<SecureStoreMixin>();
  ProfileController profileController = Get.put(ProfileController());
  LoginController loginController = LoginController();

  List<String> pages = [
    "Owner's Details",
    "Mandatory Disclosures",
    "Managers Details",
    "Bank Details",
    "Transaction Details",
    "Help"
  ].toList();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/profile',
      child: Scaffold(
          backgroundColor: lightGrey,
          appBar: getApplicationAppbar(
              allowBackNavigation: false,
              context: context,
              title: Text('Profile',
                  style: AppTextStyle.getPoppinsSemibold()
                      .copyWith(fontSize: 18))),
          body: Obx(() => (!profileController.isLoading.value &&
                  profileController.isLoaded.value)
              ? ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: ImageView.provideImage(
                                        src: profileController
                                            .profile.value.bannerImage,
                                        type: Sourcetype.network))),
                          ),
                          SizedBox(height: 12),
                          Container(
                              child: Text(
                            profileController.profile.value.businessName,
                            style: AppTextStyle.getPoppinsSemibold()
                                .copyWith(fontSize: 18),
                          )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    SlidePageTransition(
                                        widget: RestaurantDetailsScreen()));
                              },
                              child: Text(
                                'View Details',
                                style: AppTextStyle.getPoppinsSemibold()
                                    .copyWith(
                                        fontSize: 14, color: kSecondaryColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  primary: kSecondaryColor.withOpacity(0.15),
                                  elevation: 0))
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                          children: pages
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlidePageTransition(
                                              widget: getPage(e)));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                          color: lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListTile(
                                        tileColor: lightGrey,
                                        selected: false,
                                        title: Text(
                                          e,
                                          style:
                                              AppTextStyle.getPoppinsMedium(),
                                        ),
                                        leading: (e == 'Transaction Details')
                                            ? SvgPicture.asset('lib/assets/icons/ruppee.svg')
                                            : Icon(getIcon(e), color: black),
                                        trailing: Icon(Icons.arrow_forward_ios),
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                        )
                      ]),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.schedule,
                              size: 24.0,
                            ),
                            label: Text('Logout',
                                style: AppTextStyle.getPoppinsMedium()),
                            onPressed: () async {
                              await loginController.unregisterToken();
                              secureStoreMixin.removeSecureStore('token');
                              secureStoreMixin.removeSecureStore('rId');
                              OnehubControllers.closeControllers();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashScreen()),
                                  (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Colors.white,
                                onPrimary: black),
                          ),
                          Text(
                              'App version : ${restaurantController.restaurant.value.version}',
                              style: AppTextStyle.getPoppinsMedium())
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      color: Colors.white,
                    )
                  ],
                )
              : Center(child: CircularProgressIndicator()))),
    );
  }

  IconData getIcon(String key) {
    switch (key) {
      case 'Owner\'s Details':
        return Icons.person_outline;
      case 'Mandatory Disclosures':
        return Icons.task_outlined;
      case 'Managers Details':
        return Icons.people_outlined;
      case 'Bank Details':
        return Icons.account_balance_outlined;
      case 'Help':
        return Icons.help_outline_outlined;
    }
  }

  Widget getPage(String key) {
    switch (key) {
      case 'Owner\'s Details':
        return OwnerDetailScreen();
      case 'Mandatory Disclosures':
        return DisclosuresScreen();
      case 'Managers Details':
        return ManagerDetailsScreen();
      case 'Bank Details':
        return BankDetailsScreen();
      case 'Help':
        return HelpScreen();
      case 'Transaction Details':
        return SettlementScreen();
    }
  }
}
