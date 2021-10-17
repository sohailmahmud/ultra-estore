import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/body/review_body.dart';
import 'package:flutter_grocery/data/model/response/order_details_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class ProductReviewWidget extends StatelessWidget {
  final List<OrderDetailsModel> orderDetailsList;
  ProductReviewWidget({@required this.orderDetailsList});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: ListView.builder(
                  itemCount: orderDetailsList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 1))],
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      ),
                      child: Column(
                        children: [

                          // Product details
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${orderDetailsList[index].productDetails.image[0]}',
                                  height: 70, width: 85, fit: BoxFit.cover,
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 70, width: 85, fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(orderDetailsList[index].productDetails.name, style: poppinsMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 10),
                                  Text(PriceConverter.convertPrice(context, orderDetailsList[index].productDetails.price), style: poppinsBold),
                                ],
                              )),
                              Row(children: [
                                Text(
                                  '${getTranslated('quantity', context)}: ',
                                  style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)), overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  orderDetailsList[index].quantity.toString(),
                                  style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ],
                          ),
                          Divider(height: 20),

                          // Rate
                          Text(
                            getTranslated('rate_the_order', context),
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
                                    orderProvider.ratingList[index] < (i + 1) ? Icons.star_border : Icons.star,
                                    size: 25,
                                    color: orderProvider.ratingList[index] < (i + 1)
                                        ? ColorResources.getTextColor(context)
                                        : Theme.of(context).primaryColor,
                                  ),
                                  onTap: () {
                                    if(!orderProvider.submitList[index]) {
                                      orderProvider.setRating(index, i + 1);
                                    }
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
                            maxLines: 3,
                            capitalization: TextCapitalization.sentences,
                            isEnabled: !orderProvider.submitList[index],
                            hintText: getTranslated('write_your_review_here', context),
                            fillColor: ColorResources.getCardBgColor(context),
                            onChanged: (text) {
                              orderProvider.setReview(index, text);
                            },
                          ),
                          SizedBox(height: 20),

                          // Submit button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Column(
                              children: [
                                !orderProvider.loadingList[index] ? CustomButton(
                                  buttonText: getTranslated(orderProvider.submitList[index] ? 'submitted' : 'submit', context),
                                  onPressed: orderProvider.submitList[index] ? null : () {
                                    if(!orderProvider.submitList[index]) {
                                      if (orderProvider.ratingList[index] == 0) {
                                        showCustomSnackBar(getTranslated('give_a_rating', context), context);
                                      } else if (orderProvider.reviewList[index].isEmpty) {
                                        showCustomSnackBar(getTranslated('write_a_review', context), context);
                                      } else {
                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        ReviewBody reviewBody = ReviewBody(
                                          productId: orderDetailsList[index].productId.toString(),
                                          rating: orderProvider.ratingList[index].toString(),
                                          comment: orderProvider.reviewList[index],
                                          orderId: orderDetailsList[index].orderId.toString(),
                                        );
                                        orderProvider.submitReview(index, reviewBody).then((value) {
                                          if (value.isSuccess) {
                                            showCustomSnackBar(value.message, context, isError: false);
                                            orderProvider.setReview(index, '');
                                          } else {
                                            showCustomSnackBar(value.message, context);
                                          }
                                        });
                                      }
                                    }
                                  },
                                ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
