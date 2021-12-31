import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/models/profile_response.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class ManagerDetailsScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ProfileController profileController;
  TextEditingController _managerNameController;
  TextEditingController _phoneController;

  ManagerDetailsScreen() {
    profileController = Get.find<ProfileController>();
    _managerNameController = TextEditingController(
        text: profileController.getProfile().manager.name);
    _phoneController = TextEditingController(
        text: profileController.getProfile().manager.phone);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar('Manager\'s Details', () {
        Navigator.of(context).pop();
      }),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              Text('Manager 1', style: AppTextStyle.getPoppinsBold().copyWith(
                fontSize: 18
              )),
              SizedBox(height: size.height * 0.03),
              Text('Manager Name',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _managerNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Manager Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Manager Name',
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
              Text('Manager’s Mobile Number',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Mobile Number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
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
                        if (await profileController
                            .updateProfileData(updateData)) {
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
    updatedData.manager.name = _managerNameController.text;
    updatedData.manager.phone = _phoneController.text;

    return updatedData;
  }
}
