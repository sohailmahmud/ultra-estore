import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/chat_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/chat/widget/message_bubble.dart';
import 'package:flutter_grocery/view/screens/chat/widget/message_bubble_shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ChatProvider>(context, listen: false).getChatList(context);
    }

    return Scaffold(
        appBar: ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context)? MainAppBar(): AppBarBase(),
        body: _isLoggedIn ? Consumer<ChatProvider>(
          builder: (context, chat, child) {
            return Column(children: [
              Expanded(
                child: chat.chatList != null
                    ? chat.chatList.length > 0
                    ? Scrollbar(
                      child: SingleChildScrollView(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                        child: Center(
                          child: SizedBox(
                              width: 1170,
                            child: ListView.builder(
                  
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  itemCount: chat.chatList.length,
                  shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                            return MessageBubble(chat: chat.chatList[index], addDate: chat.showDate[index]);
                  },
                ),
                          ),
                        ),
                      ),
                    )
                    : SizedBox()
                    : Center(
                      child: SizedBox(
                  width: 1170,
                        child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  itemCount: 20,
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (context, index) {
                        return MessageBubbleShimmer(isMe: index % 2 == 0);
                  },
                ),
                      ),
                    ),
              ),

              // Bottom TextField
              Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chat.file != null
                          ? Padding(
                        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ResponsiveHelper.isMobilePhone() ? Image.file(File(chat.file.path), height: 70, width: 70, fit: BoxFit.cover)
                                : Image.network(chat.file.path, height: 70, width: 70, fit: BoxFit.cover),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: InkWell(
                                onTap: () => chat.removeImage(_controller.text),
                                child: Icon(Icons.cancel, color: ColorResources.getCardBgColor(context)),
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox.shrink(),
                      Container(
                        //height: 100,
                        color: Theme.of(context).accentColor,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 30),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: Column(
                            children: [


                              TextField(
                                maxLines: null,
                                controller: _controller,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                cursorColor: Theme.of(context).primaryColor,
                                onChanged: (String newText) {
                                  if (newText.isNotEmpty && !chat.isSendButtonActive) {
                                    chat.toggleSendButtonActivity();
                                  } else if (newText.isEmpty && chat.isSendButtonActive) {
                                    chat.toggleSendButtonActivity();
                                  }
                                },
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(style: BorderStyle.none, width: 1),
                                  ),
                                  isDense: true,
                                  hintText: getTranslated('say_somethings', context),
                                  fillColor: ColorResources.getCardBgColor(context),
                                  hintStyle: poppinsLight.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getHintColor(context)),
                                  filled: true,
                                ),
                                onSubmitted: (text) {
                                  if (_controller.text.trim().isNotEmpty) {
                                    chat.sendMessage(
                                      _controller.text,
                                      Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                      Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id,
                                      context,
                                    );
                                    _controller.text = '';
                                  }else {
                                    showCustomSnackBar('Write something', context);
                                  }
                                },
                              ),

                              SizedBox(height: 13),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        chat.choosePhotoFromCamera();
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: ColorResources.getHintColor(context),
                                      ),
                                    ),
                                    SizedBox(width: 24),
                                    InkWell(
                                      onTap: () async {
                                        chat.choosePhotoFromGallery();
                                      },
                                      child: Icon(
                                        Icons.insert_photo,
                                        color: ColorResources.getHintColor(context),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_controller.text.trim().isNotEmpty) {
                                      chat.sendMessage(
                                        _controller.text,
                                        Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                        Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id,
                                        context,
                                      );
                                      _controller.text = '';
                                    }else {
                                      showCustomSnackBar('Write something', context);
                                    }
                                  },
                                  child: Text(
                                    getTranslated('send', context),
                                    style: poppinsMedium.copyWith(
                                        color: chat.isSendButtonActive
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.getHintColor(context)),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]);
          },
        ) : NotLoggedInScreen()
    );
  }
}
