import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/screens/login/components/brand_banner.dart';
import 'package:onehubrestro/screens/login/components/phone_number.dart';
import 'package:onehubrestro/screens/login/otp_screen.dart';
import 'package:onehubrestro/screens/login/password_screen.dart';
import 'package:onehubrestro/screens/maintainence/no_internet.dart';
import 'package:onehubrestro/screens/profile/help_screen.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/screen_util.dart';
import 'package:onehubrestro/utilities/transitions/fade_transition.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  final TextEditingController _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    ScreenUtil.getInstance().init(context);

    return AppContainer(
      route: '/login',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: darkNavyBlue,
        body: MediaQuery
        (
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              children: [
                BrandBanner(),
                Form(
                  key: _formKey,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 80 * ScreenUtil.getInstance().scaleWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter Your Phone Number',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(TextStyle(color: Colors.white)),
                          ),
                          SizedBox(height: ScreenUtil.getInstance().setHeight(10)),
                          PhoneNumberFeild(
                            controller: _controller,
                          ),
                          SizedBox(height: size.height * 0.1 - 45),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  child: Text('Send OTP'),
                                  style: ElevatedButton.styleFrom(
                                    primary: kSecondaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      if (await loginController
                                          .sendOtp(_controller.text)) {
                                        Navigator.push(
                                            context,
                                            SlidePageTransition(
                                                widget: OTPScreen()));
                                      } else {
                                        String message =
                                            loginController.errorMessage.value;

                                        AppSnackBar.showErrorSnackBar(
                                            message: message, width: size.width);
                                      }
                                    }
                                  }),
                              TextButton(
                                  child: Text('Login Via Password',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: kPrimaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30 * ScreenUtil.getInstance().scaleWidth,
                                        vertical: 20 * ScreenUtil.getInstance().scaleHeight),
                                    shape: StadiumBorder(),
                                  ),
                                  onPressed: () {
                                    loginController.phoneNumber.value =
                                        _controller.text;
                                    Navigator.push(
                                        context,
                                        FadePageTransition(
                                            widget: LoginPasswordScreen()));
                                  }),
                            ],
                          ),
                          SizedBox(height: ScreenUtil.getInstance().setHeight(10)),
                          Divider(
                            color: grey,
                            thickness: 0.1,
                          )
                        ],
                      )),
                ),
              ],
            ),
          )),
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
                    .merge(TextStyle(fontSize: 10, color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
