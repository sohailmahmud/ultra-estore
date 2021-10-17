import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:flutter_grocery/view/screens/order/order_details_screen.dart';

class CancelDialog extends StatelessWidget {
  final OrderModel orderModel;
  final bool fromCheckout;

  CancelDialog({@required this.orderModel, @required this.fromCheckout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Container(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            fromCheckout
                ? Text(
                    getTranslated('order_placed_successfully', context),
                    style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
                  )
                : SizedBox(),
            SizedBox(height: fromCheckout ? Dimensions.PADDING_SIZE_SMALL : 0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${getTranslated('order_id', context)}:', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(orderModel.id.toString(), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
            ]),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.info, color: Theme.of(context).primaryColor),
              Text(
                getTranslated('payment_failed', context),
                style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor),
              ),
            ]),
            SizedBox(height: 10),
            Text(
              getTranslated('payment_process_is_interrupted', context),
              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(children: [
              Expanded(
                  child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteHelper.menu, (route) => false, arguments: MenuScreen());
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                  ) ,
                  child: Text(getTranslated('maybe_later', context), style: poppinsBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context,
                          RouteHelper.getOrderDetailsRoute(orderModel.id),
                          arguments: OrderDetailsScreen(orderModel:  null, orderId: orderModel.id),
                        );
                        },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                      ) ,
                      child: Text(getTranslated('order_details', context), style: poppinsBold.copyWith(color: Colors.white)),
                    ),
                  )),
            ]),
          ]),
        ),
      ),
    );
  }
}
