import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/login/login_controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/repository/login.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/shared/components/animated/animated_dot.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final LoginRepository loginRepository = Get.find<LoginRepository>();
  final LoginController loginController = Get.find<LoginController>();

  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _repeatpasswordcontroller =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _passwordHidden = true;
  bool _confirmPassHidden = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/login',
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title:
              Text('Reset your Password', style: TextStyle(color: Colors.white)),
          backgroundColor: darkNavyBlue,
          iconTheme: IconThemeData(
            color: Colors.white, //OR Colors.red or whatever you want
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08, vertical: size.height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create New Password',
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: size.height * 0.05),
                  TextFormField(
                    controller: _passwordcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Create Password',
                        hintStyle: TextStyle(color: grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: lightGrey)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kSecondaryColor)),
                        errorStyle: AppTextStyle.getErrorTextStyle(),
                        suffixIcon: IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          icon: Icon(
                            _passwordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20.0,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordHidden = !_passwordHidden;
                            });
                          },
                        ),
                    ),
                    obscureText: _passwordHidden ,
                  ),
                  SizedBox(height: size.height * 0.05),
                  TextFormField(
                    controller: _repeatpasswordcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (value != _passwordcontroller.text){
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Repeat Password',
                        hintStyle: TextStyle(color: grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: lightGrey)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kSecondaryColor)),
                        errorStyle: AppTextStyle.getErrorTextStyle(),
                        suffixIcon: IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          icon: Icon(
                            _passwordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20.0,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPassHidden = !_confirmPassHidden;
                            });
                          },
                        ),
                    ),
                    obscureText: _confirmPassHidden
                  ),
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: Obx(()=> ElevatedButton.icon(
                        icon: ((!loginController.isLoading.value) && loginController.isLoaded.value) 
                        ? AnimatedDot()
                        : Container(),
                        label: ((!loginController.isLoading.value) && loginController.isLoaded.value) 
                        ? Text('Save and Continue')
                        : Transform.scale(
                          scale: 0.7,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kSecondaryColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (await loginController
                                .changePassword(_passwordcontroller.text)) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            } else {
                              String message = loginController.errorMessage.value;
                              AppSnackBar.showErrorSnackBar(
                              message: message,
                              width: size.width);
                            }
                          }
                        })),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
