import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/category_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// ignore: must_be_immutable
class AllCategoryScreen extends StatelessWidget {
  int flag = 0;
  @override
  Widget build(BuildContext context) {

    if (flag == 0) {
      Provider.of<CategoryProvider>(context).changeSelectedIndex(0, notify: false);
      Provider.of<CategoryProvider>(context, listen: false)
          .getSubCategoryList(context, Provider.of<CategoryProvider>(context, listen: false).categoryList[0].id.toString(),
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
      flag++;
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context)? MainAppBar(): AppBarBase(),
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              return categoryProvider.categoryList.length != 0
                  ? Row(children: [

                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 3),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          //color: ColorResources.WHITE,
                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 600 : 200], spreadRadius: 3, blurRadius: 10)],
                        ),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: categoryProvider.categoryList.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            CategoryModel _category = categoryProvider.categoryList[index];
                            return InkWell(
                              onTap: () {
                                categoryProvider.changeSelectedIndex(index);
                                categoryProvider.getSubCategoryList(context, _category.id.toString(),
                                  Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
                              },
                              child: CategoryItem(
                                title: _category.name,
                                icon: _category.image,
                                isSelected: categoryProvider.categorySelectedIndex == index,
                              ),
                            );
                          },
                        ),
                      ),

                      categoryProvider.subCategoryList != null
                          ? Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: categoryProvider.subCategoryList.length + 1,
                                itemBuilder: (context, index) {
                                  if(index == 0) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getCategoryProductsRoute(
                                            categoryProvider.categoryList[categoryProvider.categorySelectedIndex].id,
                                          ),
                                          arguments: CategoryProductScreen(categoryModel: CategoryModel(
                                            id: categoryProvider.categoryList[categoryProvider.categorySelectedIndex].id,
                                            name: categoryProvider.categoryList[categoryProvider.categorySelectedIndex].name,
                                          )),
                                        );
                                      },
                                      title: Text(getTranslated('all', context)),
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                    );
                                  }
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.getCategoryProductsRoute(categoryProvider.subCategoryList[index-1].id),
                                      );
                                    },
                                    title: Text(categoryProvider.subCategoryList[index-1].name,
                                      style: poppinsMedium.copyWith(fontSize: 13, color: ColorResources.getTextColor(context)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                  );
                                },
                              ),
                            )
                          : Expanded(child: SubCategoryShimmer()),
                    ])
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;

  CategoryItem({@required this.title, @required this.icon, @required this.isSelected});

  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isSelected ? Theme.of(context).primaryColor
            : ColorResources.getBackgroundColor(context)
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            //padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? ColorResources.getCategoryBgColor(context)
                    : ColorResources.getGreyLightColor(context).withOpacity(0.05)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/$icon',
                fit: BoxFit.cover, width: 100, height: 100,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: poppinsSemiBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  color: isSelected ? ColorResources.getBackgroundColor(context) : ColorResources.getTextColor(context)
                )),
          ),
        ]),
      ),
    );
  }
}

class SubCategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).subCategoryList == null,
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white),
          ),
        );
      },
    );
  }
}
