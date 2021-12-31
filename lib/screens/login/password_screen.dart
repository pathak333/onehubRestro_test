import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/repository/login.dart';
import 'package:onehubrestro/screens/login/components/phone_number.dart';
import 'package:onehubrestro/screens/login/forgot_password_screen.dart';
import 'package:onehubrestro/screens/menu/menu_screen.dart';
import 'package:onehubrestro/screens/profile/help_screen.dart';
import 'package:onehubrestro/screens/splash_screen.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/fade_transition.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class LoginPasswordScreen extends StatefulWidget {
  @override
  _LoginPasswordScreenState createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final LoginController loginController = Get.put(LoginController());
  final LoginRepository loginRepository = Get.put(LoginRepository());
  TextEditingController _numbercontroller;
  TextEditingController _passwordcontroller;

  _LoginPasswordScreenState() {
    _numbercontroller =
        TextEditingController(text: loginController.phoneNumber.value);
    _passwordcontroller = TextEditingController();
  }

  final _formKey = new GlobalKey<FormState>();

  bool _passwordHidden = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/login',
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                height: size.height,
                color: darkNavyBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Enter Your Phone Number',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .merge(TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    PhoneNumberFeild(
                      controller: _numbercontroller,
                    ),
                    SizedBox(height: size.height * 0.1 - 35),
                    Text(
                      'Enter Your Password',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .merge(TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a password';
                        }
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            icon: Icon(
                              _passwordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordHidden = !_passwordHidden;
                              });
                            },
                          ),
                          errorStyle: AppTextStyle.getErrorTextStyle()),
                      obscureText: _passwordHidden,
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          primary: kSecondaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            loginController.phoneNumber.value =
                                _numbercontroller.text;
                            if (await loginController
                                .login(_passwordcontroller.text)) {
                              Navigator.pushReplacement(context,
                                  FadePageTransition(widget: SplashScreen()));
                            } else {
                              String message =
                                  loginController.errorMessage.value;

                              AppSnackBar.showErrorSnackBar(
                                  message: message, width: size.width);
                            }
                          }
                        }),
                    SizedBox(height: 25),
                    TextButton(
                        child: Text('Forgot Password ?'),
                        style: ElevatedButton.styleFrom(
                          onPrimary: kPrimaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  FadePageTransition(
                                      widget: ForgotPasswordScreen()))
                            }),
                    SizedBox(height: 40),
                    Divider(
                      color: grey,
                      thickness: 0.2,
                    )
                  ],
                )),
          ),
        ),
        bottomNavigationBar: Container(
            color: darkNavyBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => {
                    Navigator.of(context)
                        .push(SlidePageTransition(widget: HelpScreen()))
                  },
                  child: Text('Help and Support',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .merge(TextStyle(fontSize: 12, color: Colors.white))),
                ),
                TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text('Login with OTP',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .merge(TextStyle(fontSize: 12, color: Colors.white))),
                ),
              ],
            )),
      ),
    );
  }
}
