import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class NoInternet extends StatelessWidget {

  NavigationController navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Connect to Internet!',
            textAlign: TextAlign.center,
            style: AppTextStyle.getPoppinsSemibold().copyWith(
              fontSize: 24
              )),
          ),
          SizedBox(height: 15),
          Text('You are not connected to internet. Please check your network connection and try again',
            textAlign: TextAlign.center,
            style: AppTextStyle.getLatoBold()
            ),
          Container(
            width: size.width,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ImageView.provideImage(type: Sourcetype.asset,
                src: 'lib/assets/images/animated/no_network.gif')
              )
            ),
          ),
          Center(
            child: TextButton.icon(
              icon: SvgPicture.asset('lib/assets/icons/arrow_back.svg'),
              onPressed: (){
                Navigator.pushReplacementNamed(context, navigationController.currentRoute);
              }, 
              label:Text('Try Again', style: AppTextStyle.getPoppinsMedium())
            ),
          )
        ],
      )
    );
  }
}