class OrderListParameters {
    OrderListParameters({
        this.page,
        this.startDate,
        this.endDate,
    });

    int page;
    String startDate;
    String endDate; 

    factory OrderListParameters.fromJson(Map<String, dynamic> json) => OrderListParameters(
        page: json["page"],
        startDate : json["start_date"],
        endDate : json["end_date"]
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "start_date": startDate,
        "end_date": endDate
    }..removeWhere((key, value) => value == null);
}