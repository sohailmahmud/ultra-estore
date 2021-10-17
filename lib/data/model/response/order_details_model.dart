class OrderDetailsModel {
  int id;
  int productId;
  int orderId;
  double price;
  ProductDetails productDetails;
  double discountOnProduct;
  String discountType;
  int quantity;
  double taxAmount;
  String createdAt;
  String updatedAt;
  String variant;

  OrderDetailsModel(
      {this.id,
      this.productId,
      this.orderId,
      this.price,
      this.productDetails,
      this.discountOnProduct,
      this.discountType,
      this.quantity,
      this.taxAmount,
      this.createdAt,
      this.updatedAt,
      this.variant});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    orderId = json['order_id'];
    price = json['price'].toDouble();
    productDetails = json['product_details'] != null ? new ProductDetails.fromJson(json['product_details']) : null;
    discountOnProduct = json['discount_on_product'].toDouble();
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails.toJson();
    }
    data['discount_on_product'] = this.discountOnProduct;
    data['discount_type'] = this.discountType;
    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['variant'] = this.variant;
    return data;
  }
}

class ProductDetails {
  int id;
  String name;
  String description;
  List<dynamic> image;
  double price;
  List<CategoryIds> categoryIds;
  int capacity;
  String unit;
  double tax;
  int status;
  String createdAt;
  String updatedAt;
  double discount;
  String discountType;
  String taxType;

  ProductDetails(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.categoryIds,
      this.capacity,
      this.unit,
      this.tax,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.discount,
      this.discountType,
      this.taxType});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'].toDouble();
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    capacity = json['capacity'];
    unit = json['unit'];
    tax = json['tax'].toDouble();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    taxType = json['tax_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    if (this.categoryIds != null) {
      data['category_ids'] = this.categoryIds.map((v) => v.toJson()).toList();
    }
    data['capacity'] = this.capacity;
    data['unit'] = this.unit;
    data['tax'] = this.tax;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['tax_type'] = this.taxType;
    return data;
  }
}

class CategoryIds {
  String id;
  int position;

  CategoryIds({this.id, this.position});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    return data;
  }
}
