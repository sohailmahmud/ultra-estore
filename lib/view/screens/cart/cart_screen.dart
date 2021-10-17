import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_divider.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_grocery/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_grocery/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    bool _isSelfPickupActive = Provider.of<SplashProvider>(context, listen: false).configModel.selfPickup == 1;

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context)? MainAppBar(): AppBarBase(),
      body: Center(
        child: Consumer<CartProvider>(
          builder: (context, cart, child) {
            double deliveryCharge = 0;
            Provider.of<OrderProvider>(context).orderType == 'delivery'
                ? deliveryCharge = double.parse(Provider.of<SplashProvider>(context, listen: false).configModel.deliveryCharge) : deliveryCharge = 0;
            double _itemPrice = 0;
            double _discount = 0;
            double _tax = 0;
            cart.cartList.forEach((cartModel) {
              _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
              _discount = _discount + (cartModel.discount * cartModel.quantity);
              _tax = _tax + (cartModel.tax * cartModel.quantity);
            });
            double _subTotal = _itemPrice + _tax;
            double _total = _subTotal - _discount - Provider.of<CouponProvider>(context).discount + deliveryCharge;

            return cart.cartList.length > 0
                ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), 
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: 1170,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                  // Product
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cart.cartList.length,
                                    itemBuilder: (context, index) {
                                      return CartProductWidget(cart: cart.cartList[index], index: index,);
                                    },
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                  // Coupon
                                  Consumer<CouponProvider>(
                                    builder: (context, coupon, child) {
                                      return Row(children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _couponController,
                                            style: poppinsMedium,
                                            decoration: InputDecoration(
                                                hintText: getTranslated('enter_promo_code', context),
                                                hintStyle: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                                isDense: true,
                                                filled: true,
                                                enabled: coupon.discount == 0,
                                                fillColor: Theme.of(context).accentColor,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(10)), borderSide: BorderSide.none)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (_couponController.text.isNotEmpty && !coupon.isLoading) {
                                              if (coupon.discount < 1) {
                                                coupon.applyCoupon(_couponController.text, _total).then((discount) {
                                                  if (discount > 0) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text('You got ${PriceConverter.convertPrice(context, discount)} discount'),
                                                      backgroundColor: Colors.green,
                                                    ));
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text(getTranslated('invalid_code_or_failed', context)),
                                                      backgroundColor: Colors.red,
                                                    ));
                                                  }
                                                });
                                              } else {
                                                coupon.removeCouponData(true);
                                              }
                                            }else {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text(getTranslated('enter_a_coupon_code', context)),
                                                backgroundColor: Colors.red,
                                              ));
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 100,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.horizontal(
                                                right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                                                left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                                              ),
                                            ),
                                            child: coupon.discount <= 0
                                                ? !coupon.isLoading
                                                    ? Text(
                                                        getTranslated('apply', context),
                                                        style: poppinsMedium.copyWith(color: Colors.white),
                                                      )
                                                    : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                                : Icon(Icons.clear, color: Colors.white),
                                          ),
                                        ),
                                      ]);
                                    },
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                // Order type
                                _isSelfPickupActive ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(getTranslated('delivery_option', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  DeliveryOptionButton(value: 'delivery', title: getTranslated('delivery', context)),
                                  DeliveryOptionButton(value: 'self_pickup', title: getTranslated('self_pickup', context)),
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                ]) : SizedBox(),

                                  // Total
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('items_price', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Text(PriceConverter.convertPrice(context, _itemPrice), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  ]),
                                  SizedBox(height: 10),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('tax', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Text('(+) ${PriceConverter.convertPrice(context, _tax)}', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  ]),
                                  SizedBox(height: 10),

                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                    child: CustomDivider(color: Theme.of(context).textTheme.bodyText1.color),
                                  ),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('subtotal', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Text(PriceConverter.convertPrice(context, _subTotal), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  ]),
                                  SizedBox(height: 10),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('discount', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Text('(-) ${PriceConverter.convertPrice(context, _discount)}',
                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  ]),
                                  SizedBox(height: 10),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('coupon_discount', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Text(
                                      '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                    ),
                                  ]),
                                  SizedBox(height: 10),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('delivery_fee', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  ]),

                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                    child: CustomDivider(),
                                  ),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(getTranslated('total_amount', context),
                                        style: poppinsMedium.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    Text(
                                      PriceConverter.convertPrice(context, _total),
                                      style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                                    ),
                                  ]),

                                ]),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 1170,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                        buttonText: getTranslated('process_to_checkout', context),
                        onPressed: () {
                          if(_itemPrice < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                            'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel
                                .minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _itemPrice)} in your cart, please add more item.',
                            ), backgroundColor: Colors.red));
                          } else {
                            String _orderType = Provider.of<OrderProvider>(context, listen: false).orderType;
                            double _discount = Provider.of<CouponProvider>(context, listen: false).discount;
                            Navigator.pushNamed(
                              context, RouteHelper.getCheckoutRoute(
                              _total, _discount, _orderType,
                              Provider.of<CouponProvider>(context, listen: false).code,
                            ),
                              arguments: CheckoutScreen(
                                amount: _total, orderType: _orderType, discount: _discount,
                                couponCode: Provider.of<CouponProvider>(context, listen: false).code,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                  ],
                )
                : NoDataScreen(isCart: true);
          },
        ),
      ),
    );
  }
}
