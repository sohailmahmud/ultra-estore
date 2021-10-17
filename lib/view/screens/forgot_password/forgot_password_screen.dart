import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/email_checker.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.country).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar(): CustomAppBar(title: getTranslated('forgot_password', context)),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return Column(
                    children: [
                      SizedBox(height: 55),
                      Image.asset(Images.close_lock, width: 142, height: 142, color: Theme.of(context).primaryColor),
                      SizedBox(height: 40),
                      Center(
                          child: Text(
                        getTranslated('please_enter_your_number_to', context),
                        textAlign: TextAlign.center,
                        style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80),
                            Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification ? Text(
                              getTranslated('mobile_number', context),
                              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                            ) : Text(
                              getTranslated('email', context),
                              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification ? Row(children: [
                              CodePickerWidget(
                                onChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                initialSelection: _countryDialCode,
                                favorite: [_countryDialCode],
                                showDropDownButton: true,
                                padding: EdgeInsets.zero,
                                showFlagMain: true,
                                textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),

                              ),
                              Expanded(child: CustomTextField(
                                hintText: getTranslated('number_hint', context),
                                isShowBorder: true,
                                controller: _emailController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.phone,
                              )),
                            ]) : CustomTextField(
                              hintText: getTranslated('demo_gmail', context),
                              isShowBorder: true,
                              controller: _emailController,
                              inputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 24),
                            !auth.isForgotPasswordLoading
                                ? SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      buttonText: getTranslated('send', context),
                                      onPressed: () {
                                        String _email = _emailController.text.trim();
                                        if(Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification) {
                                          String _phone = _countryDialCode+_email;
                                          if (_email.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                          } else {
                                            Provider.of<AuthProvider>(context, listen: false).forgetPassword(_phone).then((value) {
                                              if (value.isSuccess) {
                                                Navigator.of(context).pushNamed(
                                                  RouteHelper.getVerifyRoute('forget-password', _phone),
                                                  arguments: VerificationScreen(emailAddress: _phone),
                                                );
                                              } else {
                                                showCustomSnackBar(value.message, context);
                                              }
                                            });
                                          }
                                        }else {
                                          if (_email.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                          } else if (EmailChecker.isNotValid(_email)) {
                                            showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                          } else {
                                            Provider.of<AuthProvider>(context, listen: false).forgetPassword(_email).then((value) {
                                              if (value.isSuccess) {
                                                Navigator.of(context).pushNamed(
                                                  RouteHelper.getVerifyRoute('forget-password', _email),
                                                  arguments: VerificationScreen(emailAddress: _email),
                                                );
                                              } else {
                                                showCustomSnackBar(value.message, context);
                                              }
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
