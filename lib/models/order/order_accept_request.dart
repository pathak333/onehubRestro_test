import 'dart:convert';

OrderStatusChangeRequest orderStatusChangeRequestFromJson(String str) => OrderStatusChangeRequest.fromJson(json.decode(str));

String orderStatusChangeRequestToJson(OrderStatusChangeRequest data) => json.encode(data.toJson());

class OrderStatusChangeRequest {
    OrderStatusChangeRequest({
        this.orderId,
        this.preparationTime,
    });

    int orderId;
    int preparationTime;

    factory OrderStatusChangeRequest.fromJson(Map<String, dynamic> json) => OrderStatusChangeRequest(
        orderId: json["order_id"],
        preparationTime: json["preparation_time"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "preparation_time": preparationTime,
    };
}
