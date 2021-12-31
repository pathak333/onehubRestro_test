import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

OrderHistoryListResponse orderHistoryListResponseFromJson(String str) => OrderHistoryListResponse.fromJson(json.decode(str));

String orderHistoryListResponseToJson(OrderHistoryListResponse data) => json.encode(data.toJson());

class OrderHistoryListResponse extends APIResponse {
    OrderHistoryListResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }): super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory OrderHistoryListResponse.fromJson(Map<String, dynamic> json) => OrderHistoryListResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? OrderHistoryListData.fromJson(json["data"])
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

class OrderHistoryListData extends APIData {
    OrderHistoryListData({
        this.result,
    });

    OrderHistoryListResult result;

    factory OrderHistoryListData.fromJson(Map<String, dynamic> json) => OrderHistoryListData(
        result: OrderHistoryListResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class OrderHistoryListResult {
    OrderHistoryListResult({
        this.orders,
    });

    List<OrderItem> orders;

    factory OrderHistoryListResult.fromJson(Map<String, dynamic> json) => OrderHistoryListResult(
        orders: List<OrderItem>.from(json["orders"].map((x) => OrderItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    };
}

class OrderItem {
    OrderItem({
        this.projectId,
        this.status,
        this.date,
        this.time,
        this.products,
        this.totalPrice,
    });

    int projectId;
    String status;
    String date;
    String time;
    List<OrderProduct> products;
    int totalPrice;

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        projectId: json["project_id"],
        status: json["status"],
        date: json["date"],
        time: json["time"],
        products: List<OrderProduct>.from(json["products"].map((x) => OrderProduct.fromJson(x))),
        totalPrice: json["total_price"],
    );

    Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "status": status,
        "date": date,
        "time": time,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total_price": totalPrice,
    };
}

class OrderProduct {
    OrderProduct({
        this.id,
        this.name,
        this.price,
        this.weight,
        this.quantity,
        this.subtotal,
        this.image,
        this.sku,
    });

    int id;
    String name;
    int price;
    double weight;
    int quantity;
    int subtotal;
    String image;
    String sku;

    factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        weight: json["weight"].toDouble(),
        quantity: json["quantity"],
        subtotal: json["subtotal"],
        image: json["image"],
        sku: json["sku"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "weight": weight,
        "quantity": quantity,
        "subtotal": subtotal,
        "image": image,
        "sku": sku,
    };
}
