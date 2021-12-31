class Product {
    Product({
        this.menuId,
        this.name,
        this.isVeg,
        this.displayPrice,
        this.price,
        this.image,
        this.id,
        this.isRecomended,
        this.isInStock,
        this.instockTime
    });

    int menuId;
    String name;
    bool isVeg;
    int displayPrice;
    int price;
    String image;
    bool isRecomended;
    dynamic id;
    bool isInStock;
    String instockTime;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        menuId: json["menu_id"],
        name: json["name"],
        isVeg: json["is_veg"],
        displayPrice: json["display_price"],
        price: json["price"],
        image: json["image"],
        id: json["id"],
        isRecomended: json["is_recomended"],
        isInStock: json["is_in_stock"],
        instockTime: json["in_stock_time"]
    );

    Map<String, dynamic> toJson() {
      var data ={
        "menu_id": menuId,
        "name": name,
        "is_veg": isVeg,
        "display_price": displayPrice,
        "price": price,
        "image": image,
        "id": id,
        "is_recomended": isRecomended,
        "is_in_stock": isInStock,
        "in_stock_time": instockTime
    };
    data.removeWhere((key, value) => value == null);
    return data;
    }
}

class Category {
    Category({
        this.categoryId,
        this.name,
        this.urlkey,
        this.menuItems,
        this.image,
        this.sortOrder,
        this.id,
        this.products,
        this.totalproducts,
        this.isActive
    });

    int categoryId;
    String name;
    String urlkey;
    List<dynamic> menuItems;
    String image;
    int sortOrder;
    dynamic id;
    List<Product> products;
    int totalproducts;
    bool isActive;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        name: json["name"],
        urlkey: json["urlkey"],
        menuItems: List<dynamic>.from(json["menu_items"].map((x) => x)),
        image: json["image"],
        sortOrder: json["sort_order"],
        id: json["id"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
        totalproducts: json["totalproducts"],
        isActive: json["is_active"]
    );

    Map<String, dynamic> toJson(){ 
      var data = {
        "category_id": categoryId,
        "name": name,
        "urlkey": urlkey,
        "menu_items": (menuItems != null) ? List<dynamic>.from(menuItems.map((x) => x)): null,
        "image": image,
        "sort_order": sortOrder,
        "id": id,
        "products": (products != null) ? List<dynamic>.from(products.map((x) => x.toJson())): null,
        "totalproducts": totalproducts,
        "is_active": isActive
      };
      data.removeWhere((key, value) => value == null);
      return data;
    }
}
