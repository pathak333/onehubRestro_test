import 'dart:convert';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

OrderStatusChangeResponse orderStatusChangeResponsefromJson(String str) =>
    OrderStatusChangeResponse.fromJson(json.decode(str));

String orderStatusChangeResponsetoJson(OrderStatusChangeResponse data) => json.encode(data.toJson());

class OrderStatusChangeResponse extends APIResponse {
  OrderStatusChangeResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

  APIData data;

  factory OrderStatusChangeResponse.fromJson(Map<String, dynamic> json) => OrderStatusChangeResponse(
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
