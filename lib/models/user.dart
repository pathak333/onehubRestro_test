class User {

    User();

    User.create({
        this.firstname,
        this.lastname,
        this.phoneNo,
        this.logo,
        this.businessName,
        this.email,
        this.profilePic,
        this.restaurantId,
        this.token,
    });

    

    String firstname;
    String lastname;
    String phoneNo;
    String logo;
    String businessName;
    String email;
    String profilePic;
    String token;
    int restaurantId;

    factory User.fromJson(Map<String, dynamic> json) => User.create(
        firstname: json["firstname"],
        lastname: json["lastname"],
        phoneNo: json["phone_no"],
        logo: json["logo"],
        businessName: json["business_name"],
        email: json["email"],
        profilePic: json["profile_pic"],
        token: json["token"],
        restaurantId: json["restaurant_id"]
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "phone_no": phoneNo,
        "logo": logo,
        "business_name": businessName,
        "email": email,
        "profile_pic": profilePic,
        "token": token,
        "restaurant_id": restaurantId
    };
}
