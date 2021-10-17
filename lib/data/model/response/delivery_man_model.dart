class DeliveryManModel {
  int _id;
  int _orderId;
  int _deliverymanId;
  String _time;
  String _longitude;
  String _latitude;
  String _location;
  String _createdAt;
  String _updatedAt;

  DeliveryManModel(
      {int id,
        int orderId,
        int deliverymanId,
        String time,
        String longitude,
        String latitude,
        String location,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._orderId = orderId;
    this._deliverymanId = deliverymanId;
    this._time = time;
    this._longitude = longitude;
    this._latitude = latitude;
    this._location = location;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  int get orderId => _orderId;
  int get deliverymanId => _deliverymanId;
  String get time => _time;
  String get longitude => _longitude;
  String get latitude => _latitude;
  String get location => _location;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  DeliveryManModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _deliverymanId = json['deliveryman_id'];
    _time = json['time'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _location = json['location'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['order_id'] = this._orderId;
    data['deliveryman_id'] = this._deliverymanId;
    data['time'] = this._time;
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['location'] = this._location;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}