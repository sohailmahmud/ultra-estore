import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class DailyItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getDailyItemList(context, false, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('daily_needs', context)),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(width: 1170, child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return productProvider.dailyItemList != null ? productProvider.dailyItemList.length > 0 ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isMobile(context) ? 2 : 4,
              mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: (1/1.1),
            ),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productProvider.dailyItemList.length,
            itemBuilder: (context ,index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(productProvider.dailyItemList[index].id),
                      arguments: ProductDetailsScreen(product: productProvider.dailyItemList[index],
                          cart: null));
                },
                child: Container(
                  width: 150,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Container(
                      height: 120, width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: ColorResources.getGreyColor(context)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder, width: 100, height: 150, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                              '/${productProvider.dailyItemList[index].image[0]}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, width: 80, height: 50, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(
                      productProvider.dailyItemList[index].name,
                      style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      '${productProvider.dailyItemList[index].capacity} ${productProvider.dailyItemList[index].unit}',
                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        PriceConverter.convertPrice(context, productProvider.dailyItemList[index].price),
                        style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                      ),
                      Container(
                        margin: EdgeInsets.all(2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                      ),
                    ]),

                  ]),
                ),
              );
            },
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ))))),
    );
  }
}
