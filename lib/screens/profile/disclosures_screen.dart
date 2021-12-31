import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/models/profile_response.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class DisclosuresScreen extends StatelessWidget {
  ProfileController profileController;

  TextEditingController _gstController;
  TextEditingController _panController;
  TextEditingController _fssaiController;

  DisclosuresScreen() {
    profileController = Get.find<ProfileController>();
    _gstController = TextEditingController(
        text: profileController.getProfile().disclosures.gstCode);
    _panController = TextEditingController(
        text: profileController.getProfile().disclosures.panCode);
    _fssaiController = TextEditingController(
        text: profileController.getProfile().disclosures.fssaiCode);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: getAppBar('Mandatory Disclosures', () {
        Navigator.of(context).pop();
      }),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              Text('GST Number',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _gstController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter GST';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Get Number',
                  hintStyle:
                      AppTextStyle.getPoppinsRegular().copyWith(color: grey),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: lightGrey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor)),
                  errorStyle: AppTextStyle.getErrorTextStyle(),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Text('PAN Number',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _panController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter PAN';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter PAN number',
                  hintStyle:
                      AppTextStyle.getPoppinsRegular().copyWith(color: grey),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: lightGrey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor)),
                  errorStyle: AppTextStyle.getErrorTextStyle(),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Text('FSSAI Number',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _fssaiController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter FSSAI';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter FSSAI number',
                  hintStyle:
                      AppTextStyle.getPoppinsRegular().copyWith(color: grey),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: lightGrey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor)),
                  errorStyle: AppTextStyle.getErrorTextStyle(),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Align(
                child: ElevatedButton(
                    child: Text('Save',
                        style: AppTextStyle.getPoppinsBold()
                            .copyWith(fontSize: 14, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: kSecondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Profile updateData = prepareUpdateProfile();
                        if (await profileController.updateProfileData(updateData)) {
                          Navigator.pop(context);
                        } else {
                          String message = profileController.errorMessage.value;
                          AppSnackBar.showErrorSnackBar(
                              message: message, width: size.width);
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Profile prepareUpdateProfile() {
    Profile updatedData =
        Profile.fromJson(profileController.getProfile().toJson());
    updatedData.disclosures.gstCode = _gstController.text;
    updatedData.disclosures.panCode = _panController.text;
    updatedData.disclosures.fssaiCode = _fssaiController.text;

    return updatedData;
  }
}
