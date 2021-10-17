
import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';

class MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.maintenance, width: 200, height: 200),

            Text(getTranslated('maintenance_mode', context),style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w700),),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text(
              getTranslated('maintenance_text', context),
              textAlign: TextAlign.center,

            ),

          ]),
        ),
      ),
    );
  }
}
