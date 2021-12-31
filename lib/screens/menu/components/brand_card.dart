import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/restautant/restaurant_controller.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class BrandCard extends StatelessWidget {

  RestaurantController restaurantController = Get.find<RestaurantController>();
  
  BrandCard({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return (!restaurantController.isLoading.value && restaurantController.isLoaded.value)
    ? Column(
      children: [
        Container(
          height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageView.provideImage(
                src: restaurantController.restaurant.value.profilePic,
                type: Sourcetype.network
              ),
              fit: BoxFit.fitWidth
            )
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: ListTile(
            title: Text(restaurantController.restaurant.value.restroName, style: AppTextStyle.getPoppinsSemibold().copyWith(
        fontSize: 18
      ),),
            subtitle: Text(restaurantController.restaurant.value.cuisine, style: AppTextStyle.getLatoRegular().copyWith(
        color: textLightGrey
      ),),
          ),
        )
      ],
    )
    :Container();
  }
}