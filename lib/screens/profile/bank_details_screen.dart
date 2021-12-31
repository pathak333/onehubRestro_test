import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/profile/profile_controller.dart';
import 'package:onehubrestro/models/profile_response.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class BankDetailsScreen extends StatefulWidget {
  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  ProfileController profileController;
  TextEditingController _ifscController;
  TextEditingController _accountNumberController;
  TextEditingController _accountHolderController;
  TextEditingController _branchController;
  TextEditingController _accountTypeController;
  TextEditingController _upiController;

  List<String> _accountTypes = ["Savings", "Current"].toList();

  _BankDetailsScreenState() {
    profileController = Get.find<ProfileController>();
    _ifscController = TextEditingController(
        text: profileController.getProfile().bankDetails.ifsc);
    _accountNumberController = TextEditingController(
        text: profileController.getProfile().bankDetails.accountNo);
    _accountHolderController = TextEditingController(
        text: profileController.getProfile().bankDetails.bankHolderName);
    _branchController = TextEditingController(
        text: profileController.getProfile().bankDetails.branch);
    _accountTypeController = TextEditingController(
        text: profileController.getProfile().bankDetails.type);
    _upiController = TextEditingController(
        text: profileController.getProfile().bankDetails.upi);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: getAppBar('Bank Details', () {
        Navigator.of(context).pop();
      }),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              Text('IFSC Code',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _ifscController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC Code';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter IFSC Code',
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
              Text('Account Number',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _accountNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Account Number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Account Number',
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
              Text('Account holder’s name',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _accountHolderController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Account holder’s name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Account holder’s name',
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
              Text('Branch Name',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _branchController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Branch Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Branch Name',
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
              Text('Select Account Type',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              SizedBox(height: size.height * 0.01),
              DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                hint: Text('Select Account Type',
                    style:
                        AppTextStyle.getPoppinsRegular().copyWith(color: grey)),
                value: _accountTypeController?.text,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _accountTypeController.text = newValue;
                  });
                },
                items: _accountTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
              SizedBox(height: size.height * 0.05),
              Text('UPI ID',
                  style: AppTextStyle.getPoppinsRegular()
                      .copyWith(color: textGrey, fontSize: 14)),
              TextFormField(
                controller: _accountNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter UPI ID';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter UPI ID',
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
    updatedData.bankDetails.ifsc = _ifscController.text;
    updatedData.bankDetails.accountNo = _accountNumberController.text;
    updatedData.bankDetails.bankHolderName = _accountHolderController.text;
    updatedData.bankDetails.branch = _branchController.text;
    updatedData.bankDetails.type = _accountTypeController.text;
    updatedData.bankDetails.upi = _upiController.text;

    return updatedData;
  }
}
