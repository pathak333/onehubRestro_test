import 'dart:convert';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

ChangePasswordResponse changePasswordResponsefromJson(String str) =>
    ChangePasswordResponse.fromJson(json.decode(str));

String changePasswordResponsetoJson(ChangePasswordResponse data) => json.encode(data.toJson());

class ChangePasswordResponse extends APIResponse {
  ChangePasswordResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

  APIData data;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.failed.toString().split('.').last)
                ? ErrorData.fromJson(json["data"]) : null)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": json.encode(data.toJson()),
      };
}
