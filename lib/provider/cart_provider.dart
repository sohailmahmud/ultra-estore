import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/repository/cart_repo.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  CartProvider({@required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;

  void getCartData() {
    _cartList = [];
    _amount = 0.0;
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
    });
  }

  void addToCart(CartModel cartModel) {
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
    notifyListeners();
  }

  void setQuantity(bool isIncrement, int index) {

    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _amount = _amount + _cartList[index].discountedPrice;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _amount = _amount - _cartList[index].discountedPrice;
    }
    cartRepo.addToCartList(_cartList);

    notifyListeners();
  }

  void removeFromCart(int index, BuildContext context) {
    _amount = _amount - (cartList[index].discountedPrice * cartList[index].quantity);
    showCustomSnackBar(getTranslated('remove_from_cart', context), context);
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  int isExistInCart(CartModel cartModel) {
    for(int index= 0; index<_cartList.length; index++) {
      if(_cartList[index].id == cartModel.id && (_cartList[index].variation != null ? _cartList[index].variation.type
          == cartModel.variation.type : true)) {
        return index;
      }
    }
    return -1;
  }


}
