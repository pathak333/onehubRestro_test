import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:get/get.dart' as getPackage;
import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/login/register_token.dart';
import 'package:onehubrestro/models/user.dart';
import 'package:onehubrestro/models/login/change_password_response.dart';
import 'package:onehubrestro/models/login/login_data.dart';
import 'package:onehubrestro/models/login/login_response.dart';
import 'package:onehubrestro/models/login/otp_response.dart';
import 'package:onehubrestro/models/login/verify_otp_response.dart';
import 'package:onehubrestro/repository/login.dart';
import 'package:onehubrestro/utilities/dialog_helper.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginController extends GetxController {
  var phoneNumber = ''.obs;

  var otp = ''.obs;

  var errorMessage = ''.obs;

  var temporaryToken = ''.obs;

  LoginRepository loginRepository = getPackage.Get.put(LoginRepository());

  UserController userController = getPackage.Get.put(UserController());

  RxBool isLoading = false.obs;
  RxBool isLoaded = true.obs;

  FirebaseMessaging firebaseMessaging;


  updatePhoneNumber(var number) {
    phoneNumber.value = number;
  }

  updateOtp(var number) {
    otp.value = number;
  }

  Future<bool> sendOtp(var number) async {
    try {
      phoneNumber.value = number;

      LoginData data = LoginData(phoneNo: number);
      DialogHelper.showLoader();
      OTPResponse otpResponse = await loginRepository.sendOTP(data);
      if (otpResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        OTPData data = otpResponse.data;
        OTPResult result = data.result;
        DialogHelper.hideLoader();
        return result.sent;
      } else {
        DialogHelper.hideLoader();
        handleError(otpResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return false;
    }
    return false;
  }

  Future<bool> resendOtp() async {
    try {
      LoginData data = LoginData(phoneNo: phoneNumber.value);

      OTPResponse otpResponse = await loginRepository.sendOTP(data);
      if (otpResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        OTPData data = otpResponse.data;
        OTPResult result = data.result;
        return result.sent;
      } else {
        DialogHelper.hideLoader();
        handleError(otpResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return false;
    }
    return false;
  }

  Future<bool> verifyOtp(var number) async {
    try {
      LoginData data = LoginData(phoneNo: phoneNumber.value, otp: number);

      DialogHelper.showLoader();

      LoginResponse loginResponse = await loginRepository.validateOTP(data);

      if (loginResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        LoginResponseData data = loginResponse.data;
        User result = data.result;

        if (result != null) {
          userController.updateOutlet(result);
          SecureStoreMixin storeMixin = new SecureStoreMixin();
          storeMixin.setSecureStore('token', result.token);
          storeMixin.setSecureStore('rId', result.restaurantId.toString());
          userController.updateToken(result.token);
          await registerToken();
          DialogHelper.hideLoader();
          return true;
        }
      } else {
        DialogHelper.hideLoader();
        handleError(loginResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return false;
    }
    return false;
  }

  Future<bool> login(var password) async {
    try {
      LoginData data =
          LoginData(phoneNo: phoneNumber.value, password: password);

      DialogHelper.showLoader();

      LoginResponse loginResponse = await loginRepository.login(data);

      if (loginResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        LoginResponseData data = loginResponse.data;
        User result = data.result;

        if (result != null) {
          userController.updateOutlet(result);
          SecureStoreMixin storeMixin = new SecureStoreMixin();
          storeMixin.setSecureStore('token', result.token);
          userController.updateToken(result.token);
          await registerToken();
          return true;
        }
        DialogHelper.hideLoader();
      } else {
        DialogHelper.hideLoader();
        handleError(loginResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return false;
    }
    return false;
  }

  Future<bool> sendOTPForReset(var number) async {
    try {
      phoneNumber.value = number;
      LoginData data = LoginData(phoneNo: number);

      DialogHelper.showLoader();

      OTPResponse otpResponse = await loginRepository.sendOTP(data);
      if (otpResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        OTPData data = otpResponse.data;
        OTPResult result = data.result;
        DialogHelper.hideLoader();
        return result.sent;
      } else {
        DialogHelper.hideLoader();
        handleError(otpResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return false;
    }
    return false;
  }

  Future<bool> verifyOTPForReset(var number) async {
    try {
      LoginData data = LoginData(phoneNo: phoneNumber.value, otp: number);

      DialogHelper.showLoader();

      VerifyOTPResponse verifyotpResponse =
          await loginRepository.verifyOTPForReset(data);
      if (verifyotpResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        VerifyOTPData data = verifyotpResponse.data;
        VerifyOTPResult result = data.result;
        temporaryToken.value = result.temporaryToken;
        DialogHelper.hideLoader();
        return true;
      } else {
        DialogHelper.hideLoader();
        handleError(verifyotpResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return false;
    }
    return false;
  }

  Future<bool> changePassword(var password) async {
    try {
      LoginData data = LoginData(
          phoneNo: phoneNumber.value,
          temporaryToken: temporaryToken.value,
          password: password);

      DialogHelper.showLoader();

      ChangePasswordResponse changePasswordResponse =
          await loginRepository.changePassword(data);
      if (changePasswordResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        DialogHelper.hideLoader();
        return true;
      } else {
        DialogHelper.hideLoader();
        handleError(changePasswordResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return false;
    }
    return false;
  }

  void handleError(ErrorData data) {
    errorMessage.value = data.result.error;
  }

  Future<bool> registerToken() async {
    firebaseMessaging = FirebaseMessaging.instance;
    String value = await firebaseMessaging.getToken();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    TokenRequest tokenRequest;
    if (Platform.isAndroid) {
      tokenRequest = await _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      tokenRequest = await _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
    tokenRequest.token = value;
    return await loginRepository.registerDevice(tokenRequest);
        
  }

  Future<bool> unregisterToken() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    TokenRequest tokenRequest;
    if (Platform.isAndroid) {
      AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
      tokenRequest = TokenRequest(uuid: deviceInfo.androidId);
    } else if (Platform.isIOS) {
      IosDeviceInfo deviceInfo = await deviceInfoPlugin.iosInfo;
      tokenRequest = TokenRequest(uuid: deviceInfo.identifierForVendor);
    }
    return await loginRepository.deregisterDevice(tokenRequest);
        
  }

  Future<TokenRequest> _readAndroidBuildData(AndroidDeviceInfo deviceInfo) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return TokenRequest(
          platform: 'android',
          deviceModel: deviceInfo.model,
          uuid: deviceInfo.androidId,
          manufacturer: deviceInfo.manufacturer,
          version: deviceInfo.version.release,
          app: packageInfo.packageName,
          appVersion: packageInfo.version
        );
  }

  Future<TokenRequest> _readIosDeviceInfo(IosDeviceInfo deviceInfo) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return TokenRequest(
          platform: 'iOS',
          deviceModel: deviceInfo.model,
          uuid: deviceInfo.identifierForVendor,
          manufacturer: 'Apple',
          version: deviceInfo.systemVersion,
          app: packageInfo.packageName,
          appVersion: packageInfo.version
        );

  }
}
