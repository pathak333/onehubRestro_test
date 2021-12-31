class UpdateCategoryRequest {
    UpdateCategoryRequest({
        this.categoryId,
        this.name,
        this.image,
        this.sortOrder,
        this.isActive
    });

    int categoryId;
    String name;
    String image;
    int sortOrder;
    bool isActive;

    factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) => UpdateCategoryRequest(
        categoryId: json["category_id"],
        name: json["name"],
        image: json["image"],
        sortOrder: json["sort_order"],
        isActive: json["is_active"]
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "name": name,
        "image": image,
        "sort_order": sortOrder,
        "is_active": isActive
    };
}