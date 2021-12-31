import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/image_controller.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/models/profile_response.dart';
import 'package:onehubrestro/models/restaurant.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  ProfileController profileController = Get.find<ProfileController>();

  ImageController imageController = new ImageController();

  _RestaurantDetailsScreenState();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar('More Details', () {
        Navigator.of(context).pop();
      }),
      body: ListView(
        children: [
          Container(
            height: size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: ImageView.provideImage(
                        src: profileController.getProfile().bannerImage,
                        type: Sourcetype.network))),
          ),
          GestureDetector(
            onTap: () {
              showImageOptions(size, context);
            },
            child: Container(
              color: darkNavyBlue,
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  Text(
                    'Change Banner Image',
                    style: AppTextStyle.getPoppinsMedium()
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, color: Colors.white)
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Restaurant Name',
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: textGrey, fontSize: 14)),
                SizedBox(height: 10),
                Text(profileController.getProfile().businessName,
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: black, fontSize: 16)),
                Divider()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mobile',
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: textGrey, fontSize: 14)),
                SizedBox(height: 10),
                Text(profileController.getProfile().manager.phone,
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: black, fontSize: 16)),
                Divider()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Google Location',
                            style: AppTextStyle.getPoppinsRegular()
                                .copyWith(color: textGrey, fontSize: 14)),
                        SizedBox(height: 10),
                        Text(profileController.getProfile().address.landmark,
                            style: AppTextStyle.getPoppinsRegular()
                                .copyWith(color: black, fontSize: 16)),
                      ],
                    ),
                    GestureDetector(
                        onTap: () async {
                          var mapSchema =
                              'https://www.google.com/maps/search/?api=1&query=${profileController.getProfile().address.latitude},${profileController.getProfile().address.longitude}';
                          if (await canLaunch(mapSchema)) {
                            await launch(mapSchema);
                          } else {
                            throw 'Could not launch $mapSchema';
                          }
                        },
                        child: SvgPicture.asset('lib/assets/icons/maps.svg'))
                  ],
                ),
                Divider()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address Line 1',
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: textGrey, fontSize: 14)),
                SizedBox(height: 10),
                Text(profileController.getProfile().address.area,
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: black, fontSize: 16)),
                Divider()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address Line 2',
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: textGrey, fontSize: 14)),
                SizedBox(height: 10),
                Text(
                    profileController.getProfile().address.street +
                        ', ' +
                        profileController.getProfile().address.city,
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: black, fontSize: 16)),
                Divider()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pincode',
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: textGrey, fontSize: 14)),
                SizedBox(height: 10),
                Text(profileController.getProfile().address.pincode,
                    style: AppTextStyle.getPoppinsRegular()
                        .copyWith(color: black, fontSize: 16)),
                Divider()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showImageOptions(var size, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text('Take Photo'),
                onTap: () {
                  uploadImage('camera', size);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Choose Image'),
                onTap: () {
                  uploadImage('gallery', size);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void uploadImage(String type, var size) async {
    var imageUrl = await imageController.uploadImage(type, size);
    if (imageUrl != null) {
      if (imageUrl != "not selected") {
        Profile profile =
            Profile.fromJson(profileController.getProfile().toJson());
        profile.bannerImage = imageUrl;
        if (await profileController.updateProfileData(profile)) {
          setState(() {});
        } else {
          String message = profileController.errorMessage.value;
          AppSnackBar.showErrorSnackBar(message: message, width: size.width);
        }

        AppSnackBar.showSuccessSnackBar(
            message: 'Image uploaded succesfully', width: size.width);
      }
    } else {
      String message = imageController.errorMessage;
      AppSnackBar.showErrorSnackBar(message: message, width: size.width);
    }
  }
}
