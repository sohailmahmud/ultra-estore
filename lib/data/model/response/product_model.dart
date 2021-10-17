class ProductModel {
  int _totalSize;
  String _limit;
  String _offset;
  List<Product> _products;

  ProductModel(
      {int totalSize, String limit, String offset, List<Product> products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;

  String get limit => _limit;

  String get offset => _offset;

  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int _id;
  String _name;
  String _description;
  List<String> _image;
  double _price;
  List<Variations> _variations;
  double _tax;
  int _status;
  String _createdAt;
  String _updatedAt;
  List<String> _attributes;
  List<CategoryIds> _categoryIds;
  List<ChoiceOptions> _choiceOptions;
  double _discount;
  String _discountType;
  String _taxType;
  String _unit;
  double _capacity;
  int _totalStock;
  List<Rating> _rating;

  Product(
      {int id,
        String name,
        String description,
        List<String> image,
        double price,
        List<Variations> variations,
        double tax,
        int status,
        String createdAt,
        String updatedAt,
        List<String> attributes,
        List<CategoryIds> categoryIds,
        List<ChoiceOptions> choiceOptions,
        double discount,
        String discountType,
        String taxType,
        String unit,
        double capacity,
        int totalStock,
        List<Null> rating}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._image = image;
    this._price = price;
    this._variations = variations;
    this._tax = tax;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._attributes = attributes;
    this._categoryIds = categoryIds;
    this._choiceOptions = choiceOptions;
    this._discount = discount;
    this._discountType = discountType;
    this._taxType = taxType;
    this._unit = unit;
    this._capacity = capacity;
    this._totalStock = totalStock;
    this._rating = rating;
  }

  int get id => _id;
  String get name => _name;
  String get description => _description;
  List<String> get image => _image;
  double get price => _price;
  List<Variations> get variations => _variations;
  double get tax => _tax;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<String> get attributes => _attributes;
  List<CategoryIds> get categoryIds => _categoryIds;
  List<ChoiceOptions> get choiceOptions => _choiceOptions;
  double get discount => _discount;
  String get discountType => _discountType;
  String get taxType => _taxType;
  String get unit => _unit;
  double get capacity => _capacity;
  int get totalStock => _totalStock;
  List<Rating> get rating => _rating;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'].cast<String>();
    _price = json['price'].toDouble();
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        _variations.add(new Variations.fromJson(v));
      });
    }
    _tax = json['tax'].toDouble();
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
    _unit = json['unit'];
    _capacity = json['capacity'] != null ? json['capacity'].toDouble() : json['capacity'];
    _totalStock = json['total_stock'];
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
    data['name'] = this._name;
    data['description'] = this._description;
    data['image'] = this._image;
    data['price'] = this._price;
    if (this._variations != null) {
      data['variations'] = this._variations.map((v) => v.toJson()).toList();
    }
    data['tax'] = this._tax;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['attributes'] = this._attributes;
    if (this._categoryIds != null) {
      data['category_ids'] = this._categoryIds.map((v) => v.toJson()).toList();
    }
    if (this._choiceOptions != null) {
      data['choice_options'] =
          this._choiceOptions.map((v) => v.toJson()).toList();
    }
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax_type'] = this._taxType;
    data['unit'] = this._unit;
    data['capacity'] = this._capacity;
    data['total_stock'] = this._totalStock;
     if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variations {
  String _type;
  double _price;
  int _stock;

  Variations({String type, double price, int stock}) {
    this._type = type;
    this._price = price;
    this._stock = stock;
  }

  String get type => _type;
  double get price => _price;
  int get stock => _stock;

  Variations.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = json['price'].toDouble();
    _stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['price'] = this._price;
    data['stock'] = this._stock;
    return data;
  }
}

class CategoryIds {
  String _id;
  int _position;

  CategoryIds({String id, int position}) {
    this._id = id;
    this._position = position;
  }

  String get id => _id;
  int get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['position'] = this._position;
    return data;
  }
}

class ChoiceOptions {
  String _name;
  String _title;
  List<String> _options;

  ChoiceOptions({String name, String title, List<String> options}) {
    this._name = name;
    this._title = title;
    this._options = options;
  }

  String get name => _name;
  String get title => _title;
  List<String> get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}
class Rating {
  String _average;

  Rating({String average}) {
    this._average = average;
  }

  String get average => _average;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    return data;
  }
}
