import 'dart:convert';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

OTPResponse otpResponsefromJson(String str) =>
    OTPResponse.fromJson(json.decode(str));

String otpResponsetoJson(OTPResponse data) => json.encode(data.toJson());

class OTPResponse extends APIResponse {
  OTPResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

  APIData data;

  factory OTPResponse.fromJson(Map<String, dynamic> json) => OTPResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? OTPData.fromJson(json["data"])
                : ErrorData.fromJson(json["data"]))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": json.encode(data.toJson()),
      };
}

class OTPData extends APIData {
  OTPData({
    this.result,
  });

  OTPResult result;

  factory OTPData.fromJson(Map<String, dynamic> json) => OTPData(
        result: (json["result"] != null)
            ? OTPResult.fromJson(json["result"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "result": json.encode(result.toJson()),
      };
}

class OTPResult {
  OTPResult({
    this.sent,
  });

  bool sent;

  factory OTPResult.fromJson(Map<String, dynamic> json) => OTPResult(
        sent: json["sent"],
      );

  Map<String, dynamic> toJson() => {
        "sent": sent,
      };
}
