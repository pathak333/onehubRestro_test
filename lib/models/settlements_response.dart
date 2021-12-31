// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

SettlementResponse settlementResponseFromJson(String str) => SettlementResponse.fromJson(json.decode(str));

String settlementResponseToJson(SettlementResponse data) => json.encode(data.toJson());

class SettlementResponse extends APIResponse {
    SettlementResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }): super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory SettlementResponse.fromJson(Map<String, dynamic> json) => SettlementResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? SettlementData.fromJson(json["data"])
                : ErrorData.fromJson(json["data"]))
                : null
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error,
        "data": data.toJson(),
    };
}

class SettlementData extends APIData {
    SettlementData({
        this.result,
    });

    SettlementResult result;

    factory SettlementData.fromJson(Map<String, dynamic> json) => SettlementData(
        result: SettlementResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class SettlementResult {
    SettlementResult({
        this.settlements,
    });

    List<Settlement> settlements;

    factory SettlementResult.fromJson(Map<String, dynamic> json) => SettlementResult(
        settlements: List<Settlement>.from(json["settlements"].map((x) => Settlement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "settlements": List<dynamic>.from(settlements.map((x) => x.toJson())),
    };
}

class Settlement {
    Settlement({
        this.date,
        this.time,
        this.orderId,
        this.transactionId,
        this.uniqueId,
        this.settlementAmount,
        this.breakup,
    });

    String date;
    String time;
    int orderId;
    String transactionId;
    String uniqueId;
    double settlementAmount;
    List<Breakup> breakup;

    factory Settlement.fromJson(Map<String, dynamic> json) => Settlement(
        date: json["date"],
        time: json["time"],
        orderId: json["order_id"],
        transactionId: json["transaction_id"],
        uniqueId: json["unique_id"],
        settlementAmount: json["settlement_amount"].toDouble(),
        breakup: List<Breakup>.from(json["breakup"].map((x) => Breakup.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "time": time,
        "order_id": orderId,
        "transaction_id": transactionId,
        "unique_id": uniqueId,
        "settlement_amount": settlementAmount,
        "breakup": List<dynamic>.from(breakup.map((x) => x.toJson())),
    };
}

class Breakup {
    Breakup({
        this.label,
        this.value
    });

    String label;
    dynamic value;

    factory Breakup.fromJson(Map<String, dynamic> json) => Breakup(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value
    };
}
