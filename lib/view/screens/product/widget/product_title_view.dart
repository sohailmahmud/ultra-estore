import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ProductTitleView extends StatelessWidget {
  final Product product;
  final int stock;
  ProductTitleView({@required this.product, @required this.stock});

  @override
  Widget build(BuildContext context) {

    double _startingPrice;
    double _endingPrice;
    if(product.variations.length != 0) {
      List<double> _priceList = [];
      product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = product.price;
    }


    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT), topRight: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              product.name ?? '',
              style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getTextColor(context)),
              maxLines: 2,
            ),

            //Product Price
            Text(
              '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                  '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
              style: poppinsBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            product.discount > 0 ? Text(
              '${PriceConverter.convertPrice(context, _startingPrice)}'
                  '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
              style: poppinsBold.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_SMALL, decoration: TextDecoration.lineThrough),
            ): SizedBox(),

            Row(children: [

              Text(
                '${product.capacity} ${product.unit}',
                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_SMALL),
              ),

              Expanded(child: SizedBox.shrink()),

              Row(children: [
                QuantityButton(isIncrement: false, quantity: productProvider.quantity, stock: stock),
                SizedBox(width: 15),
                Text(productProvider.quantity.toString(), style: poppinsSemiBold),
                SizedBox(width: 15),
                QuantityButton(isIncrement: true, quantity: productProvider.quantity, stock: stock),
              ]),
            ]),
          ]);
        },
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;
  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isIncrement && quantity > 1) {
          Provider.of<ProductProvider>(context, listen: false).setQuantity(false);
        } else if (isIncrement) {
          if(quantity < stock) {
            Provider.of<ProductProvider>(context, listen: false).setQuantity(true);
          }else {
            showCustomSnackBar(getTranslated('out_of_stock', context), context);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorResources.getGreyColor(context))),
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          color: isIncrement
              ? Theme.of(context).primaryColor
              : quantity > 1
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor,
          size: isCartWidget ? 26 : 20,
        ),
      ),
    );
  }
}
