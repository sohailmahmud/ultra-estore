import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/data/model/response/userinfo_model.dart';

class OrderModel {
  int _id;
  int _userId;
  double _orderAmount;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  String _paymentStatus;
  String _orderStatus;
  double _totalTaxAmount;
  String _paymentMethod;
  String _transactionReference;
  int _deliveryAddressId;
  String _createdAt;
  String _updatedAt;
  int _checked;
  int _deliveryManId;
  double _deliveryCharge;
  String _orderNote;
  String _couponCode;
  String _orderType;
  int _branchId;
  int _timeSlotId;
  String _date;
  String _deliveryDate;
  int _detailsCount;
  UserInfoModel _customer;
  DeliveryMan _deliveryMan;

  OrderModel(
      {int id,
        int userId,
        double orderAmount,
        double couponDiscountAmount,
        String couponDiscountTitle,
        String paymentStatus,
        String orderStatus,
        double totalTaxAmount,
        String paymentMethod,
        String transactionReference,
        int deliveryAddressId,
        String createdAt,
        String updatedAt,
        int checked,
        int deliveryManId,
        double deliveryCharge,
        String orderNote,
        String couponCode,
        String orderType,
        int branchId,
        int timeSlotId,
        String date,
        String deliveryDate,
        int detailsCount,
        UserInfoModel customer,
        DeliveryMan deliveryMan}) {
    this._id = id;
    this._userId = userId;
    this._orderAmount = orderAmount;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._paymentStatus = paymentStatus;
    this._orderStatus = orderStatus;
    this._totalTaxAmount = totalTaxAmount;
    this._paymentMethod = paymentMethod;
    this._transactionReference = transactionReference;
    this._deliveryAddressId = deliveryAddressId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._checked = checked;
    this._deliveryManId = deliveryManId;
    this._deliveryCharge = deliveryCharge;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._orderType = orderType;
    this._branchId = branchId;
    this._timeSlotId = timeSlotId;
    this._date = date;
    this._deliveryDate = deliveryDate;
    this._detailsCount = detailsCount;
    this._customer = customer;
    this._deliveryMan = deliveryMan;
  }

  int get id => _id;
  int get userId => _userId;
  double get orderAmount => _orderAmount;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  String get paymentStatus => _paymentStatus;
  String get orderStatus => _orderStatus;
  double get totalTaxAmount => _totalTaxAmount;
  // ignore: unnecessary_getters_setters
  String get paymentMethod => _paymentMethod;
  // ignore: unnecessary_getters_setters
  set paymentMethod(String value) {
    _paymentMethod = value;
  }
  String get transactionReference => _transactionReference;
  int get deliveryAddressId => _deliveryAddressId;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get checked => _checked;
  int get deliveryManId => _deliveryManId;
  double get deliveryCharge => _deliveryCharge;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  String get orderType => _orderType;
  int get branchId => _branchId;
  int get timeSlotId => _timeSlotId;
  String get date => _date;
  String get deliveryDate => _deliveryDate;
  int get detailsCount => _detailsCount;
  UserInfoModel get customer => _customer;
  DeliveryMan get deliveryMan => _deliveryMan;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderAmount = json['order_amount'].toDouble();
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];
    _totalTaxAmount = json['total_tax_amount'].toDouble();
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _checked = json['checked'];
    _deliveryManId = json['delivery_man_id'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _orderType = json['order_type'];
    _branchId = json['branch_id'];
    _timeSlotId = json['time_slot_id'];
    _date = json['date'];
    _deliveryDate = json['delivery_date'];
    _detailsCount = json['details_count'];
    _customer = json['customer'] != null
        ? new UserInfoModel.fromJson(json['customer'])
        : null;
    _deliveryMan = json['delivery_man'] != null
        ? new DeliveryMan.fromJson(json['delivery_man'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['order_amount'] = this._orderAmount;
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['payment_status'] = this._paymentStatus;
    data['order_status'] = this._orderStatus;
    data['total_tax_amount'] = this._totalTaxAmount;
    data['payment_method'] = this._paymentMethod;
    data['transaction_reference'] = this._transactionReference;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['checked'] = this._checked;
    data['delivery_man_id'] = this._deliveryManId;
    data['delivery_charge'] = this._deliveryCharge;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['order_type'] = this._orderType;
    data['branch_id'] = this._branchId;
    data['time_slot_id'] = this._timeSlotId;
    data['date'] = this._date;
    data['delivery_date'] = this._deliveryDate;
    data['details_count'] = this._detailsCount;
    if (this._customer != null) {
      data['customer'] = this._customer.toJson();
    }
    if (this._deliveryMan != null) {
      data['delivery_man'] = this._deliveryMan.toJson();
    }
    return data;
  }
}

class DeliveryMan {
  int _id;
  String _fName;
  String _lName;
  String _phone;
  String _email;
  String _identityNumber;
  String _identityType;
  String _identityImage;
  String _image;
  String _password;
  String _createdAt;
  String _updatedAt;
  String _authToken;
  String _fcmToken;
  List<Rating> _rating;

  DeliveryMan(
      {int id,
        String fName,
        String lName,
        String phone,
        String email,
        String identityNumber,
        String identityType,
        String identityImage,
        String image,
        String password,
        String createdAt,
        String updatedAt,
        String authToken,
        String fcmToken,
        List<Rating> rating}) {
    this._id = id;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._email = email;
    this._identityNumber = identityNumber;
    this._identityType = identityType;
    this._identityImage = identityImage;
    this._image = image;
    this._password = password;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._authToken = authToken;
    this._fcmToken = fcmToken;
    this._rating = rating;
  }

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get email => _email;
  String get identityNumber => _identityNumber;
  String get identityType => _identityType;
  String get identityImage => _identityImage;
  String get image => _image;
  String get password => _password;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get authToken => _authToken;
  String get fcmToken => _fcmToken;
  List<Rating> get rating => _rating;

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    _fcmToken = json['fcm_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating.add(new Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['identity_number'] = this._identityNumber;
    data['identity_type'] = this._identityType;
    data['identity_image'] = this._identityImage;
    data['image'] = this._image;
    data['password'] = this._password;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['auth_token'] = this._authToken;
    data['fcm_token'] = this._fcmToken;
    if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
