import 'package:flutter_grocery/data/model/response/product_model.dart';

class CartModel {
  int _id;
  String _image;
  String _name;
  double _price;
  double _discountedPrice;
  int _quantity;
  Variations _variation;
  double _discount;
  double _tax;
  double _capacity;
  String _unit;
  int _stock;


  CartModel(this._id, this._image, this._name, this._price, this._discountedPrice, this._quantity, this._variation, this._discount,
       this._tax, this._capacity, this._unit, this._stock);


  Variations get variation => _variation;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int value) {
    _quantity = value;
  }
  double get price => _price;
  double get capacity => _capacity;
  String get unit => _unit;
  double get discountedPrice => _discountedPrice;
  String get name => _name;
  String get image => _image;
  int get id => _id;
  double get discount => _discount;
  double get tax => _tax;
  int get stock => _stock;


  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _price = json['price'];
    _discountedPrice = json['discounted_price'];
    _quantity = json['quantity'];
    _variation = json['variations'] != null ? Variations.fromJson(json['variations']) : null;
    _discount = json['discount'];
    _tax = json['tax'];
    _capacity = json['capacity'];
    _unit = json['unit'];
    _stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['image'] = this._image;
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    data['quantity'] = this._quantity;
    if (this._variation != null) {
      data['variations'] = this._variation.toJson();
    }
    data['discount'] = this._discount;
    data['tax'] = this._tax;
    data['capacity'] = this._capacity;
    data['unit'] = this._unit;
    data['stock'] = this._stock;
    return data;
  }
}
