// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/menu/menu.dart';

MenuListResponse menuListResponseFromJson(String str) => MenuListResponse.fromJson(json.decode(str));

String menuListResponseToJson(MenuListResponse data) => json.encode(data.toJson());

class MenuListResponse extends APIResponse{

    MenuListResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

    APIData data;

      factory MenuListResponse.fromJson(Map<String, dynamic> json) => MenuListResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? MenuListData.fromJson(json["data"])
                : ErrorData.fromJson(json["data"]))
            : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class MenuListData extends APIData{
    MenuListData({
        this.result,
    });

    MenuListResult result;

    factory MenuListData.fromJson(Map<String, dynamic> json) => MenuListData(
        result: MenuListResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class MenuListResult extends APIData {
    MenuListResult({
        this.categories,
    });

    List<Category> categories;

    factory MenuListResult.fromJson(Map<String, dynamic> json) => MenuListResult(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}