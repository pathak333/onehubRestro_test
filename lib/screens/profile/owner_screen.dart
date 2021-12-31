import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/screens/profile/help_screen.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class OwnerDetailScreen extends StatelessWidget {
  ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar('Owner Details', () {
          Navigator.of(context).pop();
        }),
        body: Obx(() => (!profileController.isLoading.value &&
                profileController.isLoaded.value)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Owner Name',
                                style: AppTextStyle.getPoppinsRegular()
                                    .copyWith(color: textGrey, fontSize: 14)),
                            SizedBox(height: 10),
                            Text(
                                profileController.getProfile().owner.firstname +
                                    ' ' +
                                    profileController
                                        .getProfile()
                                        .owner
                                        .lastname,
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
                            Text('Owner\'s Mobile Number',
                                style: AppTextStyle.getPoppinsRegular()
                                    .copyWith(color: textGrey, fontSize: 14)),
                            SizedBox(height: 10),
                            Text(profileController.getProfile().phoneNo,
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
                            Text('Owner\'s Email Address',
                                style: AppTextStyle.getPoppinsRegular()
                                    .copyWith(color: textGrey, fontSize: 14)),
                            SizedBox(height: 10),
                            Text(profileController.getProfile().owner.email,
                                style: AppTextStyle.getPoppinsRegular()
                                    .copyWith(color: black, fontSize: 16)),
                            Divider()
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      color: grey,
                      padding: EdgeInsets.all(30),
                      margin: EdgeInsets.only(bottom: 30),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Please checkout contacts in the ',
                            style: AppTextStyle.getPoppinsBold()),
                        TextSpan(
                            text: 'help',
                            style: AppTextStyle.getPoppinsBold().merge(
                                TextStyle(
                                    color: kSecondaryColor,
                                    decoration: TextDecoration.underline)),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    SlidePageTransition(widget: HelpScreen()));
                              }),
                        TextSpan(
                            text: ' page to make changes',
                            style: AppTextStyle.getPoppinsBold()),
                      ])))
                ],
              )
            : Center(child: CircularProgressIndicator())));
  }
}
