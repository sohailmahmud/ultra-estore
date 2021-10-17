import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/data/repository/product_repo.dart';
import 'package:flutter_grocery/data/repository/search_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  final SearchRepo searchRepo;

  ProductProvider({@required this.productRepo, this.searchRepo});

  // Latest products
  Product _product;
  List<Product> _popularProductList;
  List<Product> _dailyItemList;
  bool _isLoading = false;
  int _popularPageSize;
  List<String> _offsetList = [];
  int _quantity = 1;
  List<int> _variationIndex;
  int _imageSliderIndex;

  Product get product => _product;
  List<Product> get popularProductList => _popularProductList;
  List<Product> get dailyItemList => _dailyItemList;
  bool get isLoading => _isLoading;
  int get popularPageSize => _popularPageSize;
  int get quantity => _quantity;
  List<int> get variationIndex => _variationIndex;
  int get imageSliderIndex => _imageSliderIndex;

  Future<void> getPopularProductList(BuildContext context, String offset, bool reload,String languageCode) async {
    if(reload) {
      _offsetList = [];
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(offset,languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        if (reload) {
          _popularProductList = [];
        }
        _popularProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _popularPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getDailyItemList(BuildContext context, bool reload, String languageCode) async {
    if(_dailyItemList == null || reload) {
      ApiResponse apiResponse = await productRepo.getDailyItemList(languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _dailyItemList = [];
        apiResponse.response.data.forEach((dailyItem) => _dailyItemList.add(Product.fromJson(dailyItem)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getProductDetails(BuildContext context, Product product, CartModel cart, String languageCode) async {
    if(product.name != null) {
      _product = product;
    }else {
      _product = null;
      notifyListeners();
      ApiResponse apiResponse = await productRepo.getProductDetails(product.id.toString(),languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _product = Product.fromJson(apiResponse.response.data);
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    initData(_product, cart);
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void initData(Product product, CartModel cart) {
    _variationIndex = [];
    if(cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if (cart.variation.type != null) {
        _variationTypes.addAll(cart.variation.type.split('-'));
      }
      int _varIndex = 0;
      product.choiceOptions.forEach((choiceOption) {
        for (int index = 0; index < choiceOption.options.length; index++) {
          if (choiceOption.options[index].trim().replaceAll(' ', '') ==
              _variationTypes[_varIndex].trim()) {
            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
    } else {
      _quantity = 1;
      product.choiceOptions.forEach((element) => _variationIndex.add(0));
    }
  }
  /*void initData(Product product, CartModel cart) {
    _quantity = 1;
    _variationIndex = [];
    if(cart != null) {
      _quantity = cart.quantity;
    product.choiceOptions.forEach((element) => _variationIndex.add(0));
    }
  }*/

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    _quantity = 1;
    notifyListeners();
  }

  int _rating = 0;
  int get rating => _rating;

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }

  String _errorText;

  String get errorText => _errorText;

  void setErrorText(String error) {
    _errorText = error;
    notifyListeners();
  }

  void removeData() {
    _errorText = null;
    _rating = 0;
    notifyListeners();
  }

  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }

  // Brand and category products
  List<Product> _categoryProductList = [];
  List<Product> _categoryAllProductList = [];
  bool _hasData;

  double _maxValue = 0;

  double get maxValue => _maxValue;

  List<Product> get categoryProductList => _categoryProductList;

  List<Product> get categoryAllProductList => _categoryAllProductList;

  bool get hasData => _hasData;

  void initCategoryProductList(String id, BuildContext context) async {
    _categoryProductList = [];
    _categoryAllProductList = [];
    _hasData = true;
    ApiResponse apiResponse = await productRepo.getBrandOrCategoryProductList(id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _categoryProductList = [];
      _categoryAllProductList = [];
      apiResponse.response.data.forEach((product) => _categoryProductList.add(Product.fromJson(product)));
      apiResponse.response.data.forEach((product) => _categoryAllProductList.add(Product.fromJson(product)));
      _hasData = _categoryProductList.length > 1;
      List<Product> _products = [];
      _products.addAll(_categoryProductList);
      List<double> _prices = [];
      _products.forEach((product) => _prices.add(double.parse(product.price.toString())));
      _prices.sort();
      if(categoryProductList.length!=0)
      _maxValue = _prices[_prices.length - 1];
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void sortCategoryProduct(int filterIndex) {
    if(filterIndex == 0) {
      _categoryProductList.sort((product1, product2) => product1.price.compareTo(product2.price));
    }else if(filterIndex == 1) {
      _categoryProductList.sort((product1, product2) => product1.price.compareTo(product2.price));
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList();
    }else if(filterIndex == 2) {
      _categoryProductList.sort((product1, product2) => product1.name.toLowerCase().compareTo(product2.name.toLowerCase()));
    }else if(filterIndex == 3) {
      _categoryProductList.sort((product1, product2) => product1.name.toLowerCase().compareTo(product2.name.toLowerCase()));
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList();
    }
    notifyListeners();
  }

  searchProduct(String query) {
    if (query.isEmpty) {
      _categoryProductList.clear();
      _categoryProductList = categoryAllProductList;
      notifyListeners();
    } else {
      _categoryProductList = [];
      categoryAllProductList.forEach((product) async {
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          _categoryProductList.add(product);
        }
      });
      _hasData = _categoryProductList.length > 1;
      notifyListeners();
    }
  }

  int _filterIndex = -1;
  double _lowerValue = 0;
  double _upperValue = 0;

  int get filterIndex => _filterIndex;

  double get lowerValue => _lowerValue;

  double get upperValue => _upperValue;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    notifyListeners();
  }


  void sortSearchList(int selectSortByIndex, List<CategoryModel> categoryList) {
    if (_upperValue > 0 && selectSortByIndex == 0) {
      _categoryProductList.clear();
      _categoryAllProductList.forEach((product) {
        if (((double.parse(product.price.toString())) >= _lowerValue) && ((double.parse(product.price.toString())) <= _upperValue)) {
          _categoryProductList.add(product);
        }
      });
    } else if (_upperValue == 0 && selectSortByIndex == 0) {
      _categoryProductList .clear();
      _categoryProductList = _categoryAllProductList;
    } else if (_upperValue == 0 && selectSortByIndex == 1) {
      _categoryProductList.clear();
      _categoryProductList = _categoryAllProductList;
      _categoryProductList.sort((a, b){
        double aPrice=double.parse(a.price.toString());
        double bPrice=double.parse(b.price.toString());
        return aPrice.compareTo(bPrice);
      });
    } else if (_upperValue == 0 && selectSortByIndex == 2) {
      _categoryProductList.clear();
      _categoryProductList = _categoryAllProductList;
      _categoryProductList.sort((a, b){
        double aPrice=double.parse(a.price.toString());
        double bPrice=double.parse(b.price.toString());
        return aPrice.compareTo(bPrice);
      });
      Iterable iterable = _categoryProductList.reversed;
      _categoryProductList = iterable.toList();
    }
    notifyListeners();
  }

  bool _isClear = true;

  bool get isClear => _isClear;

  void cleanSearchProduct() {
    _isClear = true;
    notifyListeners();
  }

  List<String> _allSortBy = [];

  List<String> get allSortBy => _allSortBy;
  int _selectSortByIndex = 0;

  int get selectSortByIndex => _selectSortByIndex;

  updateSortBy(int index) {
    _selectSortByIndex = index;
    notifyListeners();
  }

  initializeAllSortBy(BuildContext context) {
    if (_allSortBy.length == 0) {
      _allSortBy = [];
      _allSortBy = searchRepo.getAllSortByList(context);
    }
    _filterIndex = -1;

  }
}
