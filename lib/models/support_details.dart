// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

SupportDetailsResponse supportDetailsResponsewelcomeFromJson(String str) => SupportDetailsResponse.fromJson(json.decode(str));

String supportDetailsResponseToJson(SupportDetailsResponse data) => json.encode(data.toJson());

class SupportDetailsResponse extends APIResponse {
    SupportDetailsResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }) : super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory SupportDetailsResponse.fromJson(Map<String, dynamic> json) => SupportDetailsResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? SupportData.fromJson(json["data"])
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

class SupportData extends APIData {
    SupportData({
        this.result,
    });

    SupportResult result;

    factory SupportData.fromJson(Map<String, dynamic> json) => SupportData(
        result: SupportResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class SupportResult {
    SupportResult({
        this.numbers,
    });

    List<SupportDetail> numbers;

    factory SupportResult.fromJson(Map<String, dynamic> json) => SupportResult(
        numbers: List<SupportDetail>.from(json["numbers"].map((x) => SupportDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "numbers": List<dynamic>.from(numbers.map((x) => x.toJson())),
    };
}

class SupportDetail {
    SupportDetail({
        this.label,
        this.phones,
    });

    String label;
    List<Phone> phones;

    factory SupportDetail.fromJson(Map<String, dynamic> json) => SupportDetail(
        label: json["label"],
        phones: List<Phone>.from(json["phones"].map((x) => Phone.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "phones": List<dynamic>.from(phones.map((x) => x.toJson())),
    };
}

class Phone {
    Phone({
        this.label,
        this.phone,
    });

    String label;
    String phone;

    factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        label: json["label"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "phone": phone,
    };
}
