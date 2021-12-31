import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/restaurant.dart';

StatusResponse statusResponseFromJson(String str) => StatusResponse.fromJson(json.decode(str));

String statusResponseToJson(StatusResponse data) => json.encode(data.toJson());

class StatusResponse extends APIResponse{
    StatusResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }) : super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory StatusResponse.fromJson(Map<String, dynamic> json) => StatusResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? StatusData.fromJson(json["data"])
                : ErrorData.fromJson(json["data"]))
            : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": data.toJson(),
    };
}

class StatusData extends APIData{
    StatusData({
        this.result,
    });

    StatusResult result;

    factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
        result: StatusResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class StatusResult {
    StatusResult({
        this.restaurant,
    });

    Restaurant restaurant;

    factory StatusResult.fromJson(Map<String, dynamic> json) => StatusResult(
        restaurant: Restaurant.fromJson(json["restaurant"]),
    );

    Map<String, dynamic> toJson() => {
        "restaurant": restaurant.toJson(),
    };
}

