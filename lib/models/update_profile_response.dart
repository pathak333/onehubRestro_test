// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';

UpdateProfileResponse updateprofileResponseFromJson(String str) => UpdateProfileResponse.fromJson(json.decode(str));

String updateprofileResponseToJson(UpdateProfileResponse data) => json.encode(data.toJson());

class UpdateProfileResponse extends APIResponse{
    UpdateProfileResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    }): super(status: status, message: message, error: error);

    String status;
    String message;
    String error;
    APIData data;

    factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) => UpdateProfileResponse(
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

    UpdatedProfileResult result;

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        result: UpdatedProfileResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class UpdatedProfileResult {
    UpdatedProfileResult({
        this.payload,
    });

    UpdatedProfile payload;

    factory UpdatedProfileResult.fromJson(Map<String, dynamic> json) => UpdatedProfileResult(
        payload: UpdatedProfile.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "payload": payload.toJson(),
    };
}

class UpdatedProfile {
    UpdatedProfile({
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

    factory UpdatedProfile.fromJson(Map<String, dynamic> json) => UpdatedProfile(
        businessName: json["business_name"],
        phoneNo: json["phone_no"],
        address: Address.fromJson(json["address"]),
        owner: Owner.fromJson(json["owner"]),
        disclosures: Disclosures.fromJson(json["disclosures"]),
        manager: Manager.fromJson(json["manager"]),
        bankDetails: BankDetails.fromJson(json["bank_details"]),
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
