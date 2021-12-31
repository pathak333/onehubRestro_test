import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

AppversionResponse appversionFromJson(String str) => AppversionResponse.fromJson(json.decode(str));

String appversionToJson(AppversionResponse data) => json.encode(data.toJson());

class AppversionResponse extends APIResponse{
    AppversionResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }) : super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory AppversionResponse.fromJson(Map<String, dynamic> json) => AppversionResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? VersionData.fromJson(json["data"])
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

class VersionData extends APIData{
    VersionData({
        this.result,
    });

    VersionResult result;

    factory VersionData.fromJson(Map<String, dynamic> json) => VersionData(
        result: VersionResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class VersionResult {
    VersionResult({
        this.version,
        this.summary,
        this.iosVersion,
        this.pulaVersionAndroid,
        this.pulaVersionIos,
        this.sakalAndroidVersion,
        this.bakV2AndroidVersion,
        this.bakV2IosVersion,
        this.sakalIosVersion,
        this.the3KmIosVersion,
        this.the1HubRestaurantAndroid,
        this.the1HubRestaurantIos,
    });

    String version;
    String summary;
    String iosVersion;
    String pulaVersionAndroid;
    String pulaVersionIos;
    String sakalAndroidVersion;
    String bakV2AndroidVersion;
    String bakV2IosVersion;
    String sakalIosVersion;
    String the3KmIosVersion;
    String the1HubRestaurantAndroid;
    String the1HubRestaurantIos;

    factory VersionResult.fromJson(Map<String, dynamic> json) => VersionResult(
        version: json["version"],
        summary: json["summary"],
        iosVersion: json["ios_version"],
        pulaVersionAndroid: json["pula_version_android"],
        pulaVersionIos: json["pula_version_ios"],
        sakalAndroidVersion: json["sakal_android_version"],
        bakV2AndroidVersion: json["bak_v2_android_version"],
        bakV2IosVersion: json["bak_v2_ios_version"],
        sakalIosVersion: json["sakal_ios_version"],
        the3KmIosVersion: json["3km_ios_version"],
        the1HubRestaurantAndroid: json["1hub_restaurant_android"],
        the1HubRestaurantIos: json["1hub_restaurant_ios"],
    );

    Map<String, dynamic> toJson() => {
        "version": version,
        "summary": summary,
        "ios_version": iosVersion,
        "pula_version_android": pulaVersionAndroid,
        "pula_version_ios": pulaVersionIos,
        "sakal_android_version": sakalAndroidVersion,
        "bak_v2_android_version": bakV2AndroidVersion,
        "bak_v2_ios_version": bakV2IosVersion,
        "sakal_ios_version": sakalIosVersion,
        "3km_ios_version": the3KmIosVersion,
        "1hub_restaurant_android": the1HubRestaurantAndroid,
        "1hub_restaurant_ios": the1HubRestaurantIos,
    };
}
