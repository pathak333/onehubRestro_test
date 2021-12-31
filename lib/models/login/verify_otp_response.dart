import 'dart:convert';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

VerifyOTPResponse verifyotpResponsefromJson(String str) =>
    VerifyOTPResponse.fromJson(json.decode(str));

String verifyotpResponsetoJson(VerifyOTPResponse data) => json.encode(data.toJson());

class VerifyOTPResponse extends APIResponse {
  VerifyOTPResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

  APIData data;

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) => VerifyOTPResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? VerifyOTPData.fromJson(json["data"])
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

class VerifyOTPData extends APIData {
  VerifyOTPData({
    this.result,
  });

  VerifyOTPResult result;

  factory VerifyOTPData.fromJson(Map<String, dynamic> json) => VerifyOTPData(
        result:
            (json["result"] != null) ? VerifyOTPResult.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": json.encode(result.toJson()),
      };
}

class VerifyOTPResult {
  VerifyOTPResult({
    this.temporaryToken,
  });

  String temporaryToken;

  factory VerifyOTPResult.fromJson(Map<String, dynamic> json) => VerifyOTPResult(
        temporaryToken: json["temporary_token"],
      );

  Map<String, dynamic> toJson() => {
        "temporary_token": temporaryToken,
      };
}
