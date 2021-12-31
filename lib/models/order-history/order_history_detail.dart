// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/orders.dart';

OrderHistoryDetailResponse orderHistoryDetailFromJson(String str) => OrderHistoryDetailResponse.fromJson(json.decode(str));

String orderHistoryDetailToJson(OrderHistoryDetailResponse data) => json.encode(data.toJson());

class OrderHistoryDetailResponse extends APIResponse {
    OrderHistoryDetailResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }): super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory OrderHistoryDetailResponse.fromJson(Map<String, dynamic> json) => OrderHistoryDetailResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? OrderHistoryData.fromJson(json["data"])
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

class OrderHistoryData extends APIData{
    OrderHistoryData({
        this.result,
    });

    OrderHistoryResult result;

    factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
        result: OrderHistoryResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class OrderHistoryResult {
    OrderHistoryResult({
        this.order,
    });

    OrderDetail order;

    factory OrderHistoryResult.fromJson(Map<String, dynamic> json) => OrderHistoryResult(
        order: OrderDetail.fromJson(json["order"]),
    );

    Map<String, dynamic> toJson() => {
        "order": order.toJson(),
    };
}

class OrderDetail {
    OrderDetail({
        this.date,
        this.time,
        this.timelne,
        this.status,
        this.products,
        this.totalPrice,
        this.customer,
        this.totals,
    });

    String date;
    String time;
    List<Timelne> timelne;
    String status;
    List<Product> products;
    int totalPrice;
    String customer;
    List<Total> totals;

    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        date: json["date"],
        time: json["time"],
        timelne: List<Timelne>.from(json["timelne"].map((x) => Timelne.fromJson(x))),
        status: json["status"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
        totalPrice: json["total_price"],
        customer: json["customer"],
        totals: List<Total>.from(json["totals"].map((x) => Total.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "time": time,
        "timelne": List<dynamic>.from(timelne.map((x) => x.toJson())),
        "status": status,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total_price": totalPrice,
        "customer": customer,
        "totals": List<dynamic>.from(totals.map((x) => x.toJson())),
    };
}

class Timelne {
    Timelne({
        this.event,
        this.time,
    });

    String event;
    String time;

    factory Timelne.fromJson(Map<String, dynamic> json) => Timelne(
        event: json["event"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "event": event,
        "time": time,
    };
}

class Total {
    Total({
        this.name,
        this.value,
    });

    String name;
    int value;

    factory Total.fromJson(Map<String, dynamic> json) => Total(
        name: json["name"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
    };
}
