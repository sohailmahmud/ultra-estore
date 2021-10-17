import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
    }

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context)? MainAppBar(): AppBarBase(),
      body: _isLoggedIn ? Consumer<CouponProvider>(
        builder: (context, coupon, child) {
          return coupon.couponList != null ? coupon.couponList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: ListView.builder(
                      itemCount: coupon.couponList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: coupon.couponList[index].code));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('coupon_code_copied', context)), duration: Duration(milliseconds: 600), backgroundColor: Colors.green));
                            },
                            child: Stack(children: [

                              Image.asset(
                                Images.coupon_bg, height: 100, width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).primaryColor, fit: BoxFit.cover,
                              ),

                              Container(
                                height: 100,
                                alignment: Alignment.center,
                                child: Row(children: [

                                  SizedBox(width: 40),
                                  Image.asset(Images.percentage, height: 50, width: 50),

                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: Image.asset(Images.line, height: 100, width: 5),
                                  ),

                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                      SelectableText(
                                        coupon.couponList[index].code,
                                        style: poppinsMedium.copyWith(color: Colors.white),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                        '${coupon.couponList[index].discount}${coupon.couponList[index].discountType == 'percent' ? '%' : Provider.of<SplashProvider>(context, listen: false).configModel.currencySymbol} off',
                                        style: poppinsSemiBold.copyWith(
                                            color: Colors.white, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                        '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList[index].expireDate)}',
                                        style: poppinsLight.copyWith(
                                            color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL),
                                      ),
                                    ]),
                                  ),

                                ]),
                              ),

                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}
