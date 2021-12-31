  class Restaurant {

    Restaurant();

    Restaurant.create({
        this.restaurantId,
        this.managerName,
        this.managerPhone,
        this.address,
        this.status,
        this.restroName,
        this.profilePic,
        this.cuisine
    });

    int restaurantId;
    String managerName;
    String managerPhone;
    Address address;
    bool status;
    String restroName;
    String profilePic;
    String cuisine;
    String version;

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant.create(
        restaurantId: json["restaurant_id"],
        managerName: json["manager_name"],
        managerPhone: json["manager_phone"],
        address: Address.fromJson(json["address"]),
        status: json["status"],
        restroName: json["restro_name"],
        profilePic: json["profile_pic"],
        cuisine: json["cuisine"],
    );

    Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "manager_name": managerName,
        "manager_phone": managerPhone,
        "address": address.toJson(),
        "status": status,
        "restro_name": restroName,
        "profile_pic": profilePic,
        "cuisine": cuisine
    };
}

class Address {
    Address({
        this.flatNo,
        this.street,
        this.landmark,
        this.area,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitude,
        this.longitude,
    });

    String flatNo;
    String street;
    String landmark;
    String area;
    String city;
    String state;
    String country;
    String pincode;
    double latitude;
    double longitude;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        flatNo: json["flat_no"],
        street: json["street"],
        landmark: json["landmark"],
        area: json["area"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        latitude: json["latitude"] != null ? json["latitude"].toDouble() : null,
        longitude: json["longitude"] != null ? json["longitude"].toDouble() : null
    );

    Map<String, dynamic> toJson() => {
        "flat_no": flatNo,
        "street": street,
        "landmark": landmark,
        "area": area,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
    };
}
