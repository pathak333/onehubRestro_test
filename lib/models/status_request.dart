class StatusRequest {

  StatusRequest({
    this.restaurantId,
    this.status
  });

  int restaurantId;
  bool status; 

  factory StatusRequest.fromJson(Map<String, dynamic> json) => StatusRequest(
        restaurantId: json["restaurant_id"],
        status: json["status"]
      );

  Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "status": status
      };
}