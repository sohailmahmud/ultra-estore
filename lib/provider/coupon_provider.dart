import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/coupon_model.dart';
import 'package:flutter_grocery/data/repository/coupon_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo couponRepo;

  CouponProvider({@required this.couponRepo});

  List<CouponModel> _couponList;
  CouponModel _coupon;
  double _discount = 0.0;
  String _code = '';
  bool _isLoading = false;

  CouponModel get coupon => _coupon;

  double get discount => _discount;
  String get code => _code;

  bool get isLoading => _isLoading;

  List<CouponModel> get couponList => _couponList;

  Future<void> getCouponList(BuildContext context) async {
    ApiResponse apiResponse = await couponRepo.getCouponList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _couponList = [];
      apiResponse.response.data.forEach((category) => _couponList.add(CouponModel.fromJson(category)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<double> applyCoupon(String coupon, double order) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponRepo.applyCoupon(coupon);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _coupon = CouponModel.fromJson(apiResponse.response.data);
      _code = _coupon.code;
      if (_coupon.minPurchase != null && _coupon.minPurchase < order) {
        if (_coupon.discountType == 'percent') {
          if (_coupon.maxDiscount != null && _coupon.maxDiscount != 0) {
            _discount = (_coupon.discount * order / 100) < _coupon.maxDiscount ? (_coupon.discount * order / 100) : _coupon.maxDiscount;
          } else {
            _discount = _coupon.discount * order / 100;
          }
        } else {
          _discount = _coupon.discount;
        }
      } else {
        _discount = 0.0;
      }
    } else {
      print(apiResponse.error.toString());
      _discount = 0.0;
    }
    _isLoading = false;
    notifyListeners();
    return _discount;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _code = '';
    if(notify) {
      notifyListeners();
    }
  }
}
