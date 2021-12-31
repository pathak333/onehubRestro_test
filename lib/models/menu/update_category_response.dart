import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

UpdateCategoryResponse updateCategoryResponseFromJson(String str) => UpdateCategoryResponse.fromJson(json.decode(str));

String updateCategoryResponseToJson(UpdateCategoryResponse data) => json.encode(data.toJson());

class UpdateCategoryResponse extends APIResponse{
    UpdateCategoryResponse({
    String status,
    String message,
    String error,
    this.data,
  }) : super(status: status, message: message, error: error);

    APIData data;

    factory UpdateCategoryResponse.fromJson(Map<String, dynamic> json) => UpdateCategoryResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? UpdateCategoryData.fromJson(json["data"])
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

class UpdateCategoryData extends APIData {
    UpdateCategoryData({
        this.result,
    });

    UpdateCategoryResult result;

    factory UpdateCategoryData.fromJson(Map<String, dynamic> json) => UpdateCategoryData(
        result: UpdateCategoryResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class UpdateCategoryResult {
    UpdateCategoryResult({
        this.categoryId,
    });

    int categoryId;

    factory UpdateCategoryResult.fromJson(Map<String, dynamic> json) => UpdateCategoryResult(
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
    };
}
