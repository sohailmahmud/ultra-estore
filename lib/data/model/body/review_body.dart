class ReviewBody {
  String _productId;
  String _orderId;
  String _deliveryManId;
  String _comment;
  String _rating;
  List<String> _fileUpload;

  ReviewBody(
      {String productId,
        String orderId,
        String deliveryManId,
        String comment,
        String rating,
        List<String> fileUpload}) {
    this._productId = productId;
    this._orderId = orderId;
    this._deliveryManId = deliveryManId;
    this._comment = comment;
    this._rating = rating;
    this._fileUpload = fileUpload;
  }

  String get productId => _productId;
  String get orderId => _orderId;
  String get deliveryManId => _deliveryManId;
  String get comment => _comment;
  String get rating => _rating;
  List<String> get fileUpload => _fileUpload;

  ReviewBody.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _deliveryManId = json['delivery_man_id'];
    _comment = json['comment'];
    _rating = json['rating'];
    _fileUpload = json['fileUpload'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['delivery_man_id'] = this._deliveryManId;
    data['comment'] = this._comment;
    data['rating'] = this._rating;
    data['fileUpload'] = this._fileUpload;
    return data;
  }
}
