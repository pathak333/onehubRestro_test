import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/screens/home/home_screen.dart';
import 'package:onehubrestro/screens/login/components/single_number_field.dart';
import 'package:onehubrestro/screens/menu/menu_screen.dart';
import 'package:onehubrestro/screens/profile/help_screen.dart';
import 'package:onehubrestro/screens/splash_screen.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/shared/components/timer_action_button.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/default_transition.dart';
import 'package:onehubrestro/utilities/transitions/fade_transition.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class OTPScreen extends StatefulWidget {

  OTPScreen(){
    NavigationController navigationController = Get.find<NavigationController>();
    navigationController.setRoute('/login');
  }
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  LoginController loginController = Get.find<LoginController>();

  List<String> otpDigits = List.generate(4, (index) => "");

  bool valid = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/login',
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: darkNavyBlue,
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GetX<LoginController>(builder: (controller) {
                    return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  'A 4-digit OTP has been sent to ${controller.phoneNumber.value} via SMS. ',
                              style: Theme.of(context).textTheme.subtitle1.merge(
                                  TextStyle(color: Colors.white, fontSize: 14))),
                          TextSpan(
                              text: 'Change Phone Number',
                              style: Theme.of(context).textTheme.subtitle1.merge(
                                  TextStyle(
                                      color: kSecondaryColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14)),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                })
                        ]));
                  }),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OTPField(
                          index: 0,
                          first: true,
                          last: false,
                          otpDigits: otpDigits,
                          valid: valid),
                      SizedBox(width: 5),
                      OTPField(
                          index: 1,
                          first: false,
                          last: false,
                          otpDigits: otpDigits,
                          valid: valid),
                      SizedBox(width: 5),
                      OTPField(
                          index: 2,
                          first: false,
                          last: false,
                          otpDigits: otpDigits,
                          valid: valid),
                      SizedBox(width: 5),
                      OTPField(
                          index: 3,
                          first: false,
                          last: true,
                          otpDigits: otpDigits,
                          valid: valid)
                    ],
                  ),
                  SizedBox(height: 5),
                  (!valid
                      ? Text(loginController.errorMessage.value,
                          style: AppTextStyle.getErrorTextStyle())
                      : Container()),
                  SizedBox(height: 25),
                  ElevatedButton(
                      child: ((!loginController.isLoading.value) && loginController.isLoaded.value) 
                          ? Text('Submit OTP')
                          : Transform.scale(
                            scale: 0.7,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        primary: kSecondaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: StadiumBorder(),
                      ),
                      onPressed: () async {
                        var otp = otpDigits.join();
                        if (otp.length == 4) {
                          if (await loginController.verifyOtp(otp)) {
                            Navigator.pushReplacement(context,
                                FadePageTransition(widget: SplashScreen()));
                          } else {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              valid = false;
                            });
                          }
                        }
                      }),
                  SizedBox(height: 35),
                  TimerActionButton(
                        secondsRemaining: 120,
                        label: 'Resend OTP',
                        showProgressBar: false,
                        waitForTimer: true,
                        color: darkNavyBlue,
                        onPressed: () async {
                          if (await loginController.resendOtp()) {
                          } else {
                            String message = loginController.errorMessage.value;
                            AppSnackBar.showErrorSnackBar(
                                message: message, width: size.width);
                          }
                        },
                      )
                  ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: darkNavyBlue,
          child: TextButton(
            onPressed: () => {
              Navigator.of(context).push(
                SlidePageTransition(widget: HelpScreen())
              )
            },
            child: Text('Help and Support',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .merge(TextStyle(fontSize: 12, color: Colors.white))),
          ),
        ),
      ),
    );
  }

  // Widget textFieldOTP({BuildContext context ,bool first, last}) {
  //   return OTPField();
  // }
}
