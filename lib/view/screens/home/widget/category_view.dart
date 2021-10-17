import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return category.categoryList != null
            ? Column(
              children: [

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TitleWidget(title: getTranslated('category', context)),
                ),

                GridView.builder(
                    itemCount: category.categoryList.length > 5 ? 6 : category.categoryList.length,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (1 / 1.2),
                      crossAxisCount: ResponsiveHelper.isDesktop(context)?6:ResponsiveHelper.isMobilePhone()?3:ResponsiveHelper.isTab(context)?4:3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 5) {
                           ResponsiveHelper.isMobilePhone() ? Provider.of<SplashProvider>(context, listen: false).setPageIndex(1) : SizedBox();
                           ResponsiveHelper.isWeb() ? Navigator.pushNamed(context, RouteHelper.categorys) : SizedBox();

                          } else {
                            Navigator.of(context).pushNamed(
                              RouteHelper.getCategoryProductsRoute(category.categoryList[index].id),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
                            boxShadow: Provider.of<ThemeProvider>(context).darkTheme
                                ? null
                                : [BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: Column(children: [
                            Expanded(
                              flex: 6,
                              child: Container(
                                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index != 5 ? ColorResources.getCardBgColor(context) : Theme.of(context).primaryColor,
                                ),
                                child: index != 5 ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder,
                                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                    fit: BoxFit.cover, height: 100, width: 100,
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
                                  ),
                                ) : Text('${category.categoryList.length - 5}+', style: poppinsRegular.copyWith(color: Theme.of(context).accentColor)),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Text(
                                  index != 5 ? category.categoryList[index].name : getTranslated('view_all', context),
                                  style: poppinsRegular,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
              ],
            )
            : CategoryShimmer();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      //physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: (1 / 1.2),
        crossAxisCount: ResponsiveHelper.isWeb()?6:ResponsiveHelper.isMobilePhone()?3:ResponsiveHelper.isTab(context)?4:3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
            boxShadow: Provider.of<ThemeProvider>(context).darkTheme ? null : [BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: Provider.of<CategoryProvider>(context).categoryList == null,
            child: Column(children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_LARGE),
                  child: Container(color: Colors.grey[300], width: 50, height: 10),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
