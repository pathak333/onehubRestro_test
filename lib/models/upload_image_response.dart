// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';

UploadImageResponse uploadImageResponseFromJson(String str) => UploadImageResponse.fromJson(json.decode(str));

String uploadImageResponseToJson(UploadImageResponse data) => json.encode(data.toJson());

class UploadImageResponse extends APIResponse {

    UploadImageResponse({
        this.status,
        this.message,
        this.error,
        this.photo,
    }) : super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData photo;

    factory UploadImageResponse.fromJson(Map<String, dynamic> json) => UploadImageResponse(
        status: json["status"],
        message: json["message"],
        photo: Photo.fromJson(json["photo"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "photo": photo.toJson(),
    };
}

class Photo extends APIData{
    Photo({
        this.id,
        this.photo,
    });

    String id;
    String photo;

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
    };
}
