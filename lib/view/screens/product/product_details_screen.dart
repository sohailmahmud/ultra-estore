import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/title_row.dart';
import 'package:flutter_grocery/view/screens/product/product_description_screen.dart';
import 'package:flutter_grocery/view/screens/product/widget/details_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/variation_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_description_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_image_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_title_view.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final CartModel cart;
  ProductDetailsScreen({@required this.product, this.cart});

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();

    Variations _variation;
    final GlobalKey<DetailsAppBarState> _key = GlobalKey();

    Provider.of<ProductProvider>(context, listen: false).getProductDetails(context, product, cart,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);

    return Scaffold(

      backgroundColor: Theme.of(context).accentColor,
      appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : DetailsAppBar(key: _key),

      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          double price = 0;
          int _stock = 0;
          double priceWithQuantity = 0;
          bool isExistInCart = false;
          CartModel _cartModel;

          if(productProvider.product != null) {
            List<String> _variationList = [];
            for (int index = 0; index < productProvider.product.choiceOptions.length; index++) {
              _variationList.add(productProvider.product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
            }
            String variationType = '';
            bool isFirst = true;
            _variationList.forEach((variation) {
              if (isFirst) {
                variationType = '$variationType$variation';
                isFirst = false;
              } else {
                variationType = '$variationType-$variation';
              }
            });

            price = productProvider.product.price;
            _stock = productProvider.product.totalStock;
            for (Variations variation in productProvider.product.variations) {
              if (variation.type == variationType) {
                price = variation.price;
                _variation = variation;
                _stock = variation.stock;
                break;
              }
            }
            double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType);
            priceWithQuantity = priceWithDiscount * productProvider.quantity;

            _cartModel = CartModel(
              productProvider.product.id, productProvider.product.image[0], productProvider.product.name, price,
              PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType),
              productProvider.quantity, _variation,
              (price-PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType)),
              (price-PriceConverter.convertWithDiscount(context, price, productProvider.product.tax, productProvider.product.taxType)), productProvider.product.capacity, productProvider.product.unit, _stock,
            );
            isExistInCart = Provider.of<CartProvider>(context).isExistInCart(_cartModel) != -1;
          }

          return productProvider.product != null ? Column(
            children: [

              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: ResponsiveHelper.isMobilePhone()? BouncingScrollPhysics():null,
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(

                          children: [

                            ProductImageView(productModel: productProvider.product),

                            ProductTitleView(product: productProvider.product, stock: _stock),

                            VariationView(product: productProvider.product),

                            Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Row(children: [
                                Text('${getTranslated('total_amount', context)}:', style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(PriceConverter.convertPrice(context, priceWithQuantity), style: poppinsBold.copyWith(
                                  color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
                                )),
                              ]),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            //Description
                            (productProvider.product.description != null && productProvider.product.description.isNotEmpty ) ? Container(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              color: Theme.of(context).accentColor,
                              child: Column(children: [
                                Builder(builder: (context) =>
                                  TitleRow(title: getTranslated('description', context), isDetailsPage: true,
                                      onTap: () {
                                        List<int> _encoded = utf8.encode(productProvider.product.description);
                                        String _data = base64Encode(_encoded);
                                        _data = _data.replaceAll('+', '-');
                                    Navigator.of(context).pushNamed(
                                      RouteHelper.getProductDescriptionRoute(_data),
                                      arguments: DescriptionScreen(description: productProvider.product.description),
                                    );

                                      }),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                ProductDescription(
                                  productDescription: productProvider.product.description,
                                  id: productProvider.product.id.toString(),
                                )
                              ]),
                            ) : SizedBox.shrink(),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Builder(
                builder: (context) => Center(
                  child: Container(
                    width: 1170,
                    child: CustomButton(
                      margin: Dimensions.PADDING_SIZE_SMALL,
                      buttonText: getTranslated(isExistInCart ? 'already_added' : _stock <= 0 ? 'out_of_stock' : 'add_to_card', context),
                      onPressed: (!isExistInCart && _stock > 0) ? () {
                        if (!isExistInCart && _stock > 0) {
                          Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                          _key.currentState.shake();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)),backgroundColor: Colors.green,));

                          //showCustomSnackBar(getTranslated('added_to_cart', context),context, isError: false);

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('already_added', context)), backgroundColor: Colors.red,));
                          //showCustomSnackBar(getTranslated('already_added', context), context);
                        }
                      } : null,
                    ),
                  ),
                ),
              ),

            ],
          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
