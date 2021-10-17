import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:flutter_grocery/view/screens/order/track_order_screen.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;

  OrderSuccessfulScreen({@required this.orderID, this.status,});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar():null,
      body: Center(
        child: Container(
          width: 1170,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(Images.order_placed, width: 150, height: 150, color: Theme.of(context).primaryColor),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(
              getTranslated(
                  status == 0
                      ? 'order_placed_successfully'
                      : status == 1
                          ? 'payment_failed'
                          : 'payment_cancelled',
                  context),
              style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${getTranslated('order_id', context)}:  #$orderID',
                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getTextColor(context))),
            ]),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: CustomButton(
                    buttonText: getTranslated(status == 0 ? 'track_order' : 'back_home', context),
                    onPressed: () {
                      if (status == 0) {
                        Navigator.pushReplacementNamed(context, RouteHelper.getOrderTrackingRoute(int.parse(orderID)), arguments: TrackOrderScreen(orderID: orderID, isBackButton: true));
                      } else {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MenuScreen()), (route) => false);
                      }
                    }),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
