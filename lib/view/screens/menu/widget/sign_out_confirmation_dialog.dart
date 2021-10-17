import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child:  Container(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.contact_support, size: 50),
            ),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(getTranslated('want_to_sign_out', context), style: poppinsBold, textAlign: TextAlign.center),
            ),

            Divider(height: 0, color: ColorResources.getHintColor(context)),
            !auth.isLoading ? Row(children: [

             Expanded(child: InkWell(
               onTap: () {
                 Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
                 Provider.of<AuthProvider>(context, listen: false).clearSharedData();
                 if(ResponsiveHelper.isWeb()) {
                   Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
                 }else {
                   Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getLoginRoute(), (route) => false);
                 }
               },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('yes', context), style: poppinsBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),

             Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: Text(getTranslated('no', context), style: poppinsBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
          ]),
        )
      ),
    );
  }
}
