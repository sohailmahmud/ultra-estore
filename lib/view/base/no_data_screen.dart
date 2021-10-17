import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  final bool isProfile;
  NoDataScreen({this.isCart = false, this.isNothing = false, this.isOrder = false, this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            isOrder ? Images.box : isCart ? Images.shopping_cart : Images.not_found,
            width: _height*0.17, height: _height*0.17,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: _height*0.03),

          Text(
            getTranslated(isOrder ? 'no_order_history' : isCart ? 'empty_shopping_bag' : isProfile ? 'no_address_found' : 'no_result_found', context),
            style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: _height*0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _height*0.01),

          Text(
            isOrder ? getTranslated('buy_something_to_see', context) : isCart ? getTranslated('look_like_you_have_not_added', context) : '',
            style: poppinsRegular.copyWith(fontSize: _height*0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _height*0.01),

          SizedBox(
            height: 40, width: 150,
            child: CustomButton(
              buttonText: getTranslated('lets_shop', context),
              onPressed: () {
                Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
               // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MenuScreen()), (route) => false);
                Navigator.pushNamedAndRemoveUntil(context, RouteHelper.menu, (route) => false);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
