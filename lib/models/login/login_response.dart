import 'dart:convert';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/user.dart';
import 'package:onehubrestro/models/login/otp_response.dart';

OTPResponse loginResponsefromJson(String str) =>
    OTPResponse.fromJson(json.decode(str));

String loginResponsetoJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse extends APIResponse {
  LoginResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

  APIData data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? LoginResponseData.fromJson(json["data"])
                : ErrorData.fromJson(json["data"]))
            : null
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": json.encode(data.toJson()),
      };
}

class LoginResponseData extends APIData {
  LoginResponseData({
    this.result,
  });

  User result;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      LoginResponseData(
        result:
            (json["result"] != null) ? User.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": json.encode(result.toJson()),
      };
}
