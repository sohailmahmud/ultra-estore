import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryManWidget extends StatelessWidget {
  final DeliveryMan deliveryMan;
  DeliveryManWidget({@required this.deliveryMan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: ColorResources.getCardBgColor(context),
        boxShadow: [
          BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 0.5, blurRadius: 0.5)
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder,
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.deliveryManImageUrl}/${deliveryMan.image}',
              height: 40, width: 40, fit: BoxFit.cover,
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 40, width:40, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${deliveryMan.fName} ${deliveryMan.lName}',
                  style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
                Text(
                  deliveryMan.email,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              launch('tel:${deliveryMan.phone}');
            },
            icon: Image.asset(Images.call, color: Theme.of(context).primaryColor, width: 30, height: 30),
          ),
        ],
      ),
    );
  }
}
