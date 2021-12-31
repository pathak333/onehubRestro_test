// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse extends APIResponse{
    ProfileResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }): super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: (json["data"] != null)
            ? ((json["status"] ==
                    APIResponseStatus.success.toString().split('.').last)
                ? ProfileData.fromJson(json["data"])
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

class ProfileData extends APIData {
    ProfileData({
        this.result,
    });

    ProfileResult result;

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        result: ProfileResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class ProfileResult {
    ProfileResult({
        this.profile,
    });

    Profile profile;

    factory ProfileResult.fromJson(Map<String, dynamic> json) => ProfileResult(
        profile: Profile.fromJson(json["profile"]),
    );

    Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
    };
}

class Profile {
    Profile({
        this.businessName,
        this.phoneNo,
        this.address,
        this.owner,
        this.disclosures,
        this.manager,
        this.bankDetails,
        this.bannerImage,
    });

    String businessName;
    String phoneNo;
    Address address;
    Owner owner;
    Disclosures disclosures;
    Manager manager;
    BankDetails bankDetails;
    String bannerImage;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        businessName: json["business_name"],
        phoneNo: json["phone_no"],
        address: json["address"] != null ? Address.fromJson(json["address"]) : Address(),
        owner: json["owner"] != null ? Owner.fromJson(json["owner"]): Owner(),
        disclosures: json["disclosures"] != null ? Disclosures.fromJson(json["disclosures"]) : Disclosures(),
        manager: json["manager"] != null ? Manager.fromJson(json["manager"]) : Manager(),
        bankDetails: json["bank_details"] != null ? BankDetails.fromJson(json["bank_details"]) : BankDetails(),
        bannerImage: json["banner_image"],
    );

    Map<String, dynamic> toJson() => {
        "business_name": businessName,
        "phone_no": phoneNo,
        "address": address.toJson(),
        "owner": owner.toJson(),
        "disclosures": disclosures.toJson(),
        "manager": manager.toJson(),
        "bank_details": bankDetails.toJson(),
        "banner_image": bannerImage,
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
        this.serviceArea,
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
    String serviceArea;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        flatNo: json["flat_no"],
        street: json["street"],
        landmark: json["landmark"],
        area: json["area"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        serviceArea: json["service_area"],
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
        "service_area": serviceArea,
    };
}

class BankDetails {
    BankDetails({
        this.bankHolderName,
        this.accountNo,
        this.ifsc,
        this.upi,
        this.branch,
        this.type,
    });

    String bankHolderName;
    String accountNo;
    String ifsc;
    String upi;
    String branch;
    String type;

    factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        bankHolderName: json["bank_holder_name"],
        accountNo: json["account_no"],
        ifsc: json["ifsc"],
        upi: json["upi"],
        branch: json["branch"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "bank_holder_name": bankHolderName,
        "account_no": accountNo,
        "ifsc": ifsc,
        "upi": upi,
        "branch": branch,
        "type": type,
    };
}

class Disclosures {
    Disclosures({
        this.aadharCode,
        this.gstCode,
        this.panCode,
        this.fssaiCode,
    });

    String aadharCode;
    String gstCode;
    String panCode;
    String fssaiCode;

    factory Disclosures.fromJson(Map<String, dynamic> json) => Disclosures(
        aadharCode: json["aadhar_code"],
        gstCode: json["gst_code"],
        panCode: json["pan_code"],
        fssaiCode: json["fssai_code"],
    );

    Map<String, dynamic> toJson() => {
        "aadhar_code": aadharCode,
        "gst_code": gstCode,
        "pan_code": panCode,
        "fssai_code": fssaiCode,
    };
}

class Manager {
    Manager({
        this.name,
        this.phone,
    });

    String name;
    String phone;

    factory Manager.fromJson(Map<String, dynamic> json) => Manager(
        name: json["name"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
    };
}

class Owner {
    Owner({
        this.firstname,
        this.lastname,
        this.email,
    });

    String firstname;
    String lastname;
    String email;

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
    };
}
