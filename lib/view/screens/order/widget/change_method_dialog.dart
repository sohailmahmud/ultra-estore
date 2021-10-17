import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class ChangeMethodDialog extends StatelessWidget {
  final String orderID;
  final Function callback;
  final bool fromOrder;
  ChangeMethodDialog({@required this.orderID, @required this.callback, @required this.fromOrder});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Container(
              width: 300,
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                Image.asset(Images.wallet, color: Theme.of(context).primaryColor, width: 100, height: 100),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Text(
                  getTranslated('do_you_want_to_switch', context), textAlign: TextAlign.justify,
                  style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                !order.isLoading ?  Row(children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                        minimumSize: Size(1, 50),
                      ),
                      child: Text(getTranslated('no', context)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: CustomButton(buttonText: getTranslated('yes', context), onPressed: () async {
                    await order.updatePaymentMethod(orderID, fromOrder, callback);
                    Navigator.pop(context);
                  })),
                ]) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ]),
            ),
          ),
        );
      },
    );
  }
}
