import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/login/register_token.dart';
import 'package:onehubrestro/models/user.dart';
import 'package:onehubrestro/models/login/change_password_response.dart';
import 'package:onehubrestro/models/login/login_data.dart';
import 'package:onehubrestro/models/login/login_response.dart';
import 'package:onehubrestro/models/login/otp_response.dart';
import 'package:onehubrestro/models/login/verify_otp_response.dart';
import 'package:onehubrestro/repository/dio_initializer.dart';

class LoginRepository {

  var _dio = new Dio();

  String domain = 'https://bulbandkey.com/gateway/hubrestro';

  Future<OTPResponse> sendOTP(LoginData data) async {
    String url = domain + '/creator/sendotp';
    Response response = await _dio.post(url, data: data);
    if(response.statusCode == 200){
      OTPResponse otpResponse = otpResponsefromJson(response.data);
      return otpResponse;
    }
    return null;
  }

  Future<LoginResponse> validateOTP(LoginData data) async {
    String url = domain + '/creator/verifyotp';
    Response response = await _dio.post(url, data: data);
    if(response.statusCode == 200){
      LoginResponse loginResponse = LoginResponse.fromJson(json.decode(response.data));
      return loginResponse;
    }

    return null;
  }

  Future<LoginResponse> login(LoginData data) async {
    String url = domain + '/creator/login';
    Response response = await _dio.post(url, data: data);
    if(response.statusCode == 200){
      LoginResponse loginResponse = LoginResponse.fromJson(json.decode(response.data));
      return loginResponse;
    }

    return null;
  }

   Future<OTPResponse> sendOTPForReset(LoginData data) async {
    String url = domain + '/creator/sendotp_forgotpasssword';
    Response response = await _dio.post(url, data: data);
    if(response.statusCode == 200){
      OTPResponse otpResponse = otpResponsefromJson(response.data);
      return otpResponse;
    }
    return null;
  }

  Future<VerifyOTPResponse> verifyOTPForReset(LoginData data) async {
    String url = domain + '/creator/forgot_password_verify';
    Response response = await _dio.post(url, data: data);
    if(response.statusCode == 200){
      VerifyOTPResponse otpResponse = verifyotpResponsefromJson(response.data);
      return otpResponse;
    }
    return null;
  }

  Future<ChangePasswordResponse> changePassword(LoginData data) async {
    String url = domain + '/creator/forgot_password_setpassword';
    Response response = await _dio.post(url, data: data);
    if(response.statusCode == 200){
      ChangePasswordResponse changePasswordResponse = changePasswordResponsefromJson(response.data);
      return changePasswordResponse;
    }
    return null;
  }

  Future<bool> registerDevice(TokenRequest request) async {
    var dio = DioInitializer.initializeDio();
    String url = domain + '/attachtoken';
    Response response = await dio.post(url, data: request);
    if(response.statusCode == 200){
      return true;
    }
    return false;
  }

  Future<bool> deregisterDevice(TokenRequest request) async {
    var dio = DioInitializer.initializeDio();
    String url = domain + '/detachtoken';
    Response response = await dio.post(url, data: request);
    if(response.statusCode == 200){
      return true;
    }
    return false;
  }

}