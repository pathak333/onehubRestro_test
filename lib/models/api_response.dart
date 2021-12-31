import 'dart:convert';

abstract class APIData {
   Map<String, dynamic> toJson();
}
enum APIResponseStatus { success, failed }

class APIResponse {

  APIResponse({
    this.status,
    this.message,
    this.error,
  });
  
  String status;
  String message;
  String error;

  factory APIResponse.fromJson(Map<String, dynamic> json) => APIResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"]
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error
      };
  
}

APIResponse apiResponsefromJson(String str) =>
    APIResponse.fromJson(json.decode(str));

String apiResponsetoJson(APIResponse data) => json.encode(data.toJson());