import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/chat_model.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final ChatModel chat;
  final bool addDate;

  MessageBubble({@required this.chat, this.addDate});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat.reply == null;
    //String dateTime = DateConverter.isoStringToLocalTimeOnly(chat.createdAt);
    String _date = DateConverter.isoStringToLocalDateOnly(chat.createdAt) == DateConverter.estimatedDate(DateTime.now()) ? getTranslated('today', context)
        : DateConverter.isoStringToLocalDateOnly(chat.createdAt) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
        ? getTranslated('yesterday', context) : DateConverter.isoStringToLocalDateOnly(chat.createdAt);


    return Padding(
      padding: isMe ? EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          addDate ? Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Align(alignment: Alignment.center, child: Text(_date, style: poppinsRegular, textAlign: TextAlign.center)),
          ) : SizedBox(),
          isMe
              ? Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName} ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName}',
                      style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.only(left: 8, bottom: 9),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          fit: BoxFit.fill,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.only(right: 8, bottom: 9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(Images.placeholder),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Text(
                      AppConstants.APP_NAME,
                      style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                    )
                  ],
                ),
          isMe
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${DateConverter.isoStringToLocalTimeWithAmPmAndDay(chat.createdAt)}', style: poppinsRegular.copyWith(fontSize: 10, color: ColorResources.getTextColor(context))),
                    SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        //width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF4d5054) : Color(0xFFECECEC),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                                    child: Text(chat.message, style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context))),
                                  ),
                                  chat.image != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.chatImageUrl}/${chat.image}',
                                      width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth,
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
                                    ),
                                  )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isMe ? ColorResources.getHintColor(context) : Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: Text(
                                chat.reply,
                                style: poppinsRegular.copyWith(color: Theme.of(context).accentColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      DateConverter.isoStringToLocalTimeWithAmPmAndDay(chat.createdAt),
                      style: poppinsRegular.copyWith(fontSize: 10, color: ColorResources.getTextColor(context)),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
