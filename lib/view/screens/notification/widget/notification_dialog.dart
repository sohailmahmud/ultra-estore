import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/notification_model.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;
  NotificationDialog({@required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Container(
              height: 150, width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.notificationImageUrl}/${notificationModel.image}',
                  height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Text(
                notificationModel.title,
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                notificationModel.description,
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  color: ColorResources.getHintColor(context).withOpacity(.75),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
