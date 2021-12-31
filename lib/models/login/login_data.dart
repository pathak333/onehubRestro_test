import 'dart:convert';

LoginData fromJson(String str) => LoginData.fromJson(json.decode(str));

String toJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  LoginData({
    this.phoneNo,
    this.otp,
    this.password,
    this.temporaryToken,
  });

  String phoneNo;
  String otp;
  String password;
  String temporaryToken;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        phoneNo: json["phone_no"],
        otp: json["otp"],
        password: json["password"],
        temporaryToken: json["temporary_token"]
      );

  Map<String, dynamic> toJson() => {
        "phone_no": phoneNo,
        "otp": otp,
        "password": password,
        "temporary_token": temporaryToken
      };
}