import 'dart:convert';

enum OrderStatus { created, preparing, ready, picked, delivered }

enum DeliveryStatus {
  notcreated,
  searching,
  assigned,
  reached,
  picked,
  delivered,
  cancelled
}

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.customer,
    this.date,
    this.deliveryBy,
    this.deliveryCreated,
    this.deliveryDetails,
    this.leadTime,
    this.orderId,
    this.orderStatus,
    this.pickupTime,
    this.pickupTimeDisplay,
    this.products,
    this.time,
    this.total,
    this.subTotal,
    this.tax,
    this.shippingAmount,
    this.isBuzzerOn,
  });

  String customer;
  String date;
  String deliveryBy;
  bool deliveryCreated;
  DeliveryDetails deliveryDetails;
  int leadTime;
  int orderId;
  OrderStatus orderStatus;
  PickupTime pickupTime;
  String pickupTimeDisplay;
  List<Product> products;
  String time;
  int total;
  num subTotal;
  num shippingAmount;
  num tax;
  bool isBuzzerOn;
  factory Order.fromJson(Map<String, dynamic> json) => Order(
      customer: json["customer"],
      date: json["date"],
      deliveryBy: json["delivery_by"],
      deliveryCreated: json["delivery_created"],
      deliveryDetails: DeliveryDetails.fromJson(
          Map<String, dynamic>.from(json["delivery_details"])),
      leadTime: json["lead_time"],
      orderId: json["order_id"],
      orderStatus: mapStatusToOrderStatus(json["order_status"]),
      pickupTime: (json["pickup_time"] != null)
          ? PickupTime.fromJson(Map<String, dynamic>.from(json["pickup_time"]))
          : null,
      pickupTimeDisplay: json["pickup_time_display"],
      products: List<Product>.from(json["products"]
          .map((x) => Product.fromJson(Map<String, dynamic>.from(x)))),
      time: json["time"],
      total: json["total"],
      subTotal: json["sub_total"],
      shippingAmount: json["shipping_amount"],
      tax: json["tax"],
      isBuzzerOn: json["is_buzzer_on"]);

  static mapStatusToOrderStatus(String status) {
    switch (status) {
      case 'created':
        return OrderStatus.created;
        break;
      case 'preparing':
        return OrderStatus.preparing;
        break;
      case 'ready':
        return OrderStatus.ready;
        break;
      case 'picked':
        return OrderStatus.picked;
        break;
      default:
        return null;
        break;
    }
  }

  Map<String, dynamic> toJson() => {
        "customer": customer,
        "date": date,
        "delivery_by": deliveryBy,
        "delivery_created": deliveryCreated,
        "delivery_details": deliveryDetails.toJson(),
        "lead_time": leadTime,
        "order_id": orderId,
        "order_status": orderStatus.toString().split('.').last,
        "pickup_time": pickupTime.toJson(),
        "pickup_time_display": pickupTimeDisplay,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "time": time,
        "total": total,
        "tax": tax,
        "is_buzzer_on": isBuzzerOn
      };
}

class DeliveryDetails {
  DeliveryDetails({
    this.agentName,
    this.agentPhone,
    this.cancelledBy,
    this.reason,
    this.status,
  });

  String agentName;
  String agentPhone;
  String cancelledBy;
  String reason;
  DeliveryStatus status;

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) =>
      DeliveryDetails(
        agentName: json["agent_name"],
        agentPhone: json["agent_phone"],
        cancelledBy: json["cancelled_by"],
        reason: json["reason"],
        status: mapStatusToDeliveryStatus(json["status"]),
      );

  static mapStatusToDeliveryStatus(String status) {
    switch (status) {
      case 'notcreated':
        return DeliveryStatus.notcreated;
        break;
      case 'searching':
        return DeliveryStatus.searching;
        break;
      case 'assigned':
        return DeliveryStatus.assigned;
        break;
      case 'reached':
        return DeliveryStatus.reached;
        break;
      case 'picked':
        return DeliveryStatus.picked;
        break;
      case 'delivered':
        return DeliveryStatus.delivered;
        break;
      case 'cancelled':
        return DeliveryStatus.cancelled;
        break;
      default:
        return null;
        break;
    }
  }

  Map<String, dynamic> toJson() => {
        "agent_name": agentName,
        "agent_phone": agentPhone,
        "cancelled_by": cancelledBy,
        "reason": reason,
        "status": status.toString().split('.').last,
      };
}

class PickupTime {
  PickupTime({
    this.nanoseconds,
    this.seconds,
  });

  DateTime nanoseconds;
  DateTime seconds;

  factory PickupTime.fromJson(Map<String, dynamic> json) => PickupTime(
        nanoseconds: (json["_nanoseconds"] != null)
            ? DateTime.fromMillisecondsSinceEpoch(json["_nanoseconds"] * 1000)
            : null,
        seconds: (json["_seconds"] != null)
            ? DateTime.fromMillisecondsSinceEpoch(json["_seconds"] * 1000)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_nanoseconds": nanoseconds,
        "_seconds": seconds,
      };
}

class Product {
  Product({this.name, this.price, this.quantity, this.isVeg});

  String name;
  int price;
  int quantity;
  bool isVeg;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json["name"],
      price: json["price"],
      quantity: json["quantity"],
      isVeg: json["is_veg"]);

  Map<String, dynamic> toJson() =>
      {"name": name, "price": price, "quantity": quantity, "is_veg": isVeg};
}
