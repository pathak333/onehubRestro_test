// To parse this JSON data, do
//
//     final TokenRequest = TokenRequestFromJson(jsonString);

import 'dart:convert';

TokenRequest tokenRequestFromJson(String str) =>
    TokenRequest.fromJson(json.decode(str));

String tokenRequestToJson(TokenRequest data) => json.encode(data.toJson());

class TokenRequest {
  TokenRequest({
    this.uuid,
    this.platform,
    this.token,
    this.manufacturer,
    this.deviceModel,
    this.appVersion,
    this.version,
    this.app,
  });

  String uuid;
  String platform;
  String token;
  String manufacturer;
  String deviceModel;
  String appVersion;
  String version;
  String app;

  factory TokenRequest.fromJson(Map<String, dynamic> json) => TokenRequest(
        uuid: json["uuid"],
        platform: json["platform"],
        token: json["token"],
        manufacturer: json["manufacturer"],
        deviceModel: json["device_model"],
        appVersion: json["app_version"],
        version: json["version"],
        app: json["app"],
      );

  Map<String, dynamic> toJson() {
    var data = {
      "uuid": uuid,
      "platform": platform,
      "token": token,
      "manufacturer": manufacturer,
      "device_model": deviceModel,
      "app_version": appVersion,
      "version": version,
      "app": app,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
