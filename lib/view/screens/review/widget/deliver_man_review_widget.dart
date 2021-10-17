import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/body/review_body.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/screens/order/widget/delivery_man_widget.dart';
import 'package:provider/provider.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan deliveryMan;
  final String orderID;
  DeliveryManReviewWidget({@required this.deliveryMan, @required this.orderID});

  @override
  _DeliveryManReviewWidgetState createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: SizedBox(
              width: 1170,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                widget.deliveryMan != null ? DeliveryManWidget(deliveryMan: widget.deliveryMan) : SizedBox(),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  child: Column(children: [
                    Text(
                      getTranslated('rate_his_service', context),
                      style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)), overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    SizedBox(
                      height: 30,
                      child: ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return InkWell(
                            child: Icon(
                              orderProvider.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                              size: 25,
                              color: orderProvider.deliveryManRating < (i + 1)
                                  ? ColorResources.getTextColor(context)
                                  : Theme.of(context).primaryColor,
                            ),
                            onTap: () {
                              orderProvider.setDeliveryManRating(i + 1);
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Text(
                      getTranslated('share_your_opinion', context),
                      style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)), overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    CustomTextField(
                      maxLines: 5,
                      capitalization: TextCapitalization.sentences,
                      controller: _controller,
                      hintText: getTranslated('write_your_review_here', context),
                      fillColor: ColorResources.getCardBgColor(context),
                    ),
                    SizedBox(height: 40),

                    // Submit button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                      child: Column(
                        children: [
                          !orderProvider.isLoading ? CustomButton(
                            buttonText: getTranslated('submit', context),
                            onPressed: () {
                              if (orderProvider.deliveryManRating == 0) {
                                showCustomSnackBar(getTranslated('give_a_rating', context), context);
                              } else if (_controller.text.isEmpty) {
                                showCustomSnackBar(getTranslated('write_a_review', context), context);
                              } else {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                ReviewBody reviewBody = ReviewBody(
                                  deliveryManId: widget.deliveryMan.id.toString(),
                                  rating: orderProvider.deliveryManRating.toString(),
                                  comment: _controller.text,
                                  orderId: widget.orderID,
                                );
                                orderProvider.submitDeliveryManReview(reviewBody).then((value) {
                                  if (value.isSuccess) {
                                    showCustomSnackBar(value.message, context, isError: false);
                                    _controller.text = '';
                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });
                              }
                            },
                          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                        ],
                      ),
                    ),
                  ]),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}
