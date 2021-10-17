class ReviewModel {
  int _id;
  String _productId;
  String _userId;
  String _comment;
  List<String> _attachment;
  String _rating;
  String _createdAt;
  String _updatedAt;
  Customer _customer;

  ReviewModel(
      {int id,
        String productId,
        String userId,
        String comment,
        List<String> attachment,
        String rating,
        String createdAt,
        String updatedAt,
        Customer customer}) {
    this._id = id;
    this._productId = productId;
    this._userId = userId;
    this._comment = comment;
    this._attachment = attachment;
    this._rating = rating;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._customer = customer;
  }

  int get id => _id;
  String get productId => _productId;
  String get userId => _userId;
  String get comment => _comment;
  List<String> get attachment => _attachment;
  String get rating => _rating;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  Customer get customer => _customer;

  ReviewModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _userId = json['user_id'];
    _comment = json['comment'];
    _attachment = json['attachment'].cast<String>();
    _rating = json['rating'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['user_id'] = this._userId;
    data['comment'] = this._comment;
    if (this._customer != null) {
      data['customer'] = this._customer.toJson();
    }
    data['rating'] = this._rating;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._customer != null) {
      data['customer'] = this._customer.toJson();
    }
    return data;
  }
}

class Customer {
  int _id;
  String _name;
  String _fName;
  String _lName;
  String _phone;
  String _image;
  String _email;
  String _emailVerifiedAt;
  String _createdAt;
  String _updatedAt;
  String _streetAddress;
  String _country;
  String _city;
  String _zip;
  String _houseNo;
  String _apartmentNo;

  Customer(
      {int id,
        String name,
        String fName,
        String lName,
        String phone,
        String image,
        String email,
        String emailVerifiedAt,
        String createdAt,
        String updatedAt,
        String streetAddress,
        String country,
        String city,
        String zip,
        String houseNo,
        String apartmentNo}) {
    this._id = id;
    this._name = name;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._image = image;
    this._email = email;
    this._emailVerifiedAt = emailVerifiedAt;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._streetAddress = streetAddress;
    this._country = country;
    this._city = city;
    this._zip = zip;
    this._houseNo = houseNo;
    this._apartmentNo = apartmentNo;
  }

  int get id => _id;
  String get name => _name;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get image => _image;
  String get email => _email;
  String get emailVerifiedAt => _emailVerifiedAt;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get streetAddress => _streetAddress;
  String get country => _country;
  String get city => _city;
  String get zip => _zip;
  String get houseNo => _houseNo;
  String get apartmentNo => _apartmentNo;

  Customer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _image = json['image'];
    _email = json['email'];
    _emailVerifiedAt = json['email_verified_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _streetAddress = json['street_address'];
    _country = json['country'];
    _city = json['city'];
    _zip = json['zip'];
    _houseNo = json['house_no'];
    _apartmentNo = json['apartment_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['image'] = this._image;
    data['email'] = this._email;
    data['email_verified_at'] = this._emailVerifiedAt;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['street_address'] = this._streetAddress;
    data['country'] = this._country;
    data['city'] = this._city;
    data['zip'] = this._zip;
    data['house_no'] = this._houseNo;
    data['apartment_no'] = this._apartmentNo;
    return data;
  }
}