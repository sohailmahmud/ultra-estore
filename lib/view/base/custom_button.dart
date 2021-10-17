import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final double margin;
  CustomButton({@required this.buttonText, @required this.onPressed, this.margin = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: onPressed == null ? ColorResources.getHintColor(context) : Theme.of(context).primaryColor,
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(buttonText, style: poppinsMedium.copyWith(color: Theme.of(context).accentColor, fontSize: Dimensions.FONT_SIZE_LARGE)),
      ),
    );
  }
}
