import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  ProfileController profileController = Get.put(ProfileController());

  HelpScreen() {
    profileController.getSupportDetail();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: getAppBar('Help', () {
          Navigator.of(context).pop();
        }),
        body: SingleChildScrollView(
            child: Obx(() => (!profileController.isLoading.value &&
                    profileController.isLoaded.value)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Icon(Icons.help, color: kSecondaryColor, size: 100),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: Text(
                            'Call us on the following phone numbers for support',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.getPoppinsSemibold()),
                      ),
                      SizedBox(height: 40),
                      Column(
                          children: profileController
                              .supportDetail.value.numbers
                              .map((e) => Container(
                                  width: double.infinity,
                                  color: lightGrey,
                                  padding: EdgeInsets.all(30),
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    children: [
                                      Text(e.label,
                                          style:
                                              AppTextStyle.getPoppinsSemibold()
                                                  .copyWith(color: textGrey)),
                                      SizedBox(height: 10),
                                      Column(
                                        children: e.phones
                                            .map((phone) => Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(phone.label,
                                                          style: AppTextStyle
                                                              .getPoppinsRegular()),
                                                      GestureDetector(
                                                        onTap: () {
                                                          callPerson(
                                                              phone.phone);
                                                        },
                                                        child: Text(phone.phone,
                                                            style: AppTextStyle
                                                                    .getPoppinsRegular()
                                                                .copyWith(
                                                                    color:
                                                                        kSecondaryColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline)),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      )
                                    ],
                                  )))
                              .toList())
                    ],
                  )
                : Center(child: CircularProgressIndicator()))));
  }

  void callPerson(String number) async {
    String url = 'tel:${number}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      String message = 'Cannot call the support agent';
      AppSnackBar.showErrorSnackBar(message: message, width: double.infinity);
    }
  }
}
