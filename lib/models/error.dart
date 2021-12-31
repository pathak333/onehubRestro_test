import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';

class Error {
    Error({
        this.error
    });

    String error;

    factory Error.fromJson(Map<String, dynamic> json) => Error(
        error: json["Error"],
    );

    Map<String, dynamic> toJson() => {
        "Error": error,
    };
}

class ErrorData extends APIData {
  ErrorData({
    this.result,
  });

  Error result;

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData(
        result:
            (json["result"] != null) ? Error.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": json.encode(result.toJson()),
      };
}