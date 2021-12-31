import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/repository/login.dart';
import 'package:onehubrestro/screens/login/change_password_screen.dart';
import 'package:onehubrestro/screens/login/components/phone_number.dart';
import 'package:onehubrestro/screens/login/components/single_number_field.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  LoginController loginController = Get.put(LoginController());
  LoginRepository loginRepository = Get.put(LoginRepository());

  TextEditingController _numbercontroller = TextEditingController();

  int stepNumber = 1;

  List<String> otpDigits = List.generate(4, (index) => "");

  bool valid = true;

  var _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/login',
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            title: Text('Reset your Password',
                style: TextStyle(color: Colors.white)),
            backgroundColor: darkNavyBlue,
            iconTheme: IconThemeData(
              color: Colors.white, //OR Colors.red or whatever you want
            ),
          ),
          backgroundColor: darkNavyBlue,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    stepNumber == 1
                        ? _buildNumberComponent(size, context)
                        : _buildOTPComponent(size, context)
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Container _buildNumberComponent(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Step 1/2'),
            SizedBox(height: size.height * 0.07),
            Text(
              'Enter Your Phone Number',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10),
            PhoneNumberFeild(
                controller: _numbercontroller, 
                borderColor: grey,
                backgroundColor: lightGrey),
            SizedBox(height: 20),
            ElevatedButton(
                child: Text('Send OTP'),
                style: ElevatedButton.styleFrom(
                  primary: kSecondaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: StadiumBorder(),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (await loginController.sendOTPForReset(_numbercontroller.text)) {
                      setState(() => {stepNumber++});
                    } else{
                      String message = loginController.errorMessage.value;
                      AppSnackBar.showErrorSnackBar(
                        message: message,
                        width: size.width 
                      );
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Container _buildOTPComponent(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Step 2/2'),
          SizedBox(height: 20),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'A 4-digit OTP has been sent to  via SMS. ',
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: 'Change Phone Number',
                    style: TextStyle(
                        color: kSecondaryColor,
                        decoration: TextDecoration.underline),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          stepNumber--;
                          valid = true;
                        });
                      })
              ])),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OTPField(
                  index: 0,
                  first: true,
                  last: false,
                  backgroundcolor: lightGrey,
                  borderColor: grey,
                  otpDigits: otpDigits,
                  valid: valid),
              OTPField(
                  index: 1,
                  first: false,
                  last: false,
                  backgroundcolor: lightGrey,
                  borderColor: grey,
                  otpDigits: otpDigits,
                  valid: valid),
              OTPField(
                  index: 2,
                  first: false,
                  last: false,
                  backgroundcolor: lightGrey,
                  borderColor: grey,
                  otpDigits: otpDigits,
                  valid: valid),
              OTPField(
                  index: 3,
                  first: false,
                  last: true,
                  backgroundcolor: lightGrey,
                  borderColor: grey,
                  otpDigits: otpDigits,
                  valid: valid)
            ],
          ),
          SizedBox(height: 5),
          ( !valid ? Text(loginController.errorMessage.value,
            style: AppTextStyle.getErrorTextStyle()) : Container()),
          SizedBox(height: 25),
          ElevatedButton(
              child: Text('Submit OTP'),
              style: ElevatedButton.styleFrom(
                primary: kSecondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: StadiumBorder(),
              ),
              onPressed: () async {
                var otp = otpDigits.join();
                if (otp.length == 4) {
                  if (await loginController.verifyOTPForReset(otp)) {
                    Navigator.pushReplacement(context,
                        SlidePageTransition(widget: ChangePasswordScreen()));
                  } else {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      valid = !valid;
                    });
                  }
                }
              }),
          SizedBox(height: 35),
          GestureDetector(
            child: Text('Resend OTP', style: TextStyle(color: Colors.black)),
            onTap: () async => {await loginController.resendOtp()},
          ),
        ],
      ),
    );
  }
}
