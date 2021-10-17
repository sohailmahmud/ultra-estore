import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  DeliveryOptionButton({@required this.value, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String value) => order.setOrderType(value),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Text(title, style: poppinsRegular),
              SizedBox(width: 5),

              Text('(${value == 'delivery' ? PriceConverter.convertPrice(context, double.parse(Provider.of<SplashProvider>(context, listen: false)
                  .configModel.deliveryCharge)) : getTranslated('free', context)})', style: poppinsMedium),

            ],
          ),
        );
      },
    );
  }
}
