class PlaceOrderBody {
  List<Cart> _cart;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  int _branchId;
  int _deliveryAddressId;
  int _timeSlotId;
  String _deliveryDate;
  String _paymentMethod;
  String _orderNote;
  String _couponCode;

  PlaceOrderBody(
      {List<Cart> cart,
        double couponDiscountAmount,
        String couponDiscountTitle,
        double orderAmount,
        String orderType,
        int branchId,
        int deliveryAddressId,
        int timeSlotId,
        String deliveryDate,
        String paymentMethod,
        String orderNote,
        String couponCode}) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._branchId = branchId;
    this._deliveryAddressId = deliveryAddressId;
    this._timeSlotId = timeSlotId;
    this._deliveryDate = deliveryDate;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
  }

  List<Cart> get cart => _cart;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  int get branchId => _branchId;
  int get deliveryAddressId => _deliveryAddressId;
  int get timeSlotId => _timeSlotId;
  String get deliveryDate => _deliveryDate;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'].toDouble();
    _orderType = json['order_type'];
    _branchId = json['branch_id'];
    _deliveryAddressId = json['delivery_address_id'];
    _timeSlotId = json['time_slot_id'];
    _deliveryDate = json['delivery_date'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['branch_id'] = this._branchId;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['time_slot_id'] = this._timeSlotId;
    data['delivery_date'] = this._deliveryDate;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    return data;
  }
}

class Cart {
  int _productId;
  double _price;
  String _variant;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;

  Cart(
      {int productId,
        double price,
        String variant,
        List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount}) {
    this._productId = productId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
  }

  int get productId => _productId;
  double get price => _price;
  String get variant => _variant;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'].toDouble();
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    return data;
  }
}

class Variation {
  String _type;

  Variation({String type}) {
    this._type = type;
  }

  String get type => _type;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    return data;
  }
}
