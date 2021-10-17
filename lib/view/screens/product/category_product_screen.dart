import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// ignore: must_be_immutable
class CategoryProductScreen extends StatelessWidget {
  int flag = 0;
  final CategoryModel categoryModel;
  CategoryProductScreen({@required this.categoryModel});

  void _loadData(BuildContext context) async {
    if (flag == 0) {
      Provider.of<CategoryProvider>(context, listen: false).getCategory(categoryModel.id, context);
      Provider.of<ProductProvider>(context, listen: false).initCategoryProductList(categoryModel.id.toString(), context);
      Provider.of<ProductProvider>(context, listen: false).initializeAllSortBy(context);
      Provider.of<CategoryProvider>(context, listen: false).setFilterIndex(-1);
      flag++;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar():null,
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ResponsiveHelper.isDesktop(context)? SizedBox():   CustomAppBar(
                  title: Provider.of<CategoryProvider>(context).categoryModel != null
                      ? Provider.of<CategoryProvider>(context).categoryModel.name : 'name',
                  isCenter: false, isElevation: true,
                ),
                SizedBox(height: 20),
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) =>
                  Container(
                    height: 32,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      itemCount: Provider.of<ProductProvider>(context).allSortBy.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            categoryProvider.setFilterIndex(index);
                            productProvider.sortCategoryProduct(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                                color: categoryProvider.filterIndex == index ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                                borderRadius: BorderRadius.circular(7)),
                            child: Text(
                              Provider.of<ProductProvider>(context).allSortBy[index],
                              style: poppinsRegular.copyWith(
                                  color: categoryProvider.filterIndex == index ? ColorResources.getBackgroundColor(context) : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  height: 48,
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: ColorResources.getCardBgColor(context)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
                          cursorColor: Theme.of(context).primaryColor,
                          textInputAction: TextInputAction.search,
                          autofocus: false,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: Provider.of<ProductProvider>(context, listen: false).searchProduct,
                          onSubmitted: Provider.of<ProductProvider>(context, listen: false).searchProduct,
                          decoration: InputDecoration(
                            hintText: 'Search item here...',
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            hintStyle: poppinsRegular,
                            prefixIcon: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.search, color: ColorResources.getHintColor(context)),
                              onPressed: () {},
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(style: BorderStyle.none, width: 0),
                            ),
                            /*suffixIcon: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        child: FilterWidget(maxValue: productProvider.maxValue),
                                      );
                                    });
                              },
                              icon: Icon(Icons.filter_list, color: ColorResources.getHintColor(context)),
                            ),*/
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Products
                productProvider.categoryProductList.length > 0
                    ? Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3,
                            crossAxisCount: ResponsiveHelper.isDesktop(context)?3:ResponsiveHelper.isMobilePhone()?1:ResponsiveHelper.isTab(context)?2:1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          itemCount: productProvider.categoryProductList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductWidget(product: productProvider.categoryProductList[index]);
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                        child: productProvider.hasData
                            ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: ProductShimmer(isEnabled: Provider.of<ProductProvider>(context).categoryProductList.length == 0),
                            )
                            : NoDataScreen(),
                      )),


               // for product total item and calculation

                Provider.of<CartProvider>(context, listen: false).cartList.length > 0 ? InkWell(
                    onTap: () {
                     Navigator.pop(context);
                     Provider.of<SplashProvider>(context, listen: false).setPageIndex(2);
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('total_item', context),
                                  style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Theme.of(context).accentColor,
                                  )),

                              Text('${Provider.of<CartProvider>(context, listen: false).cartList.length} ${getTranslated('items', context)}',
                                  style: poppinsMedium.copyWith(color: Theme.of(context).accentColor)),

                            ]),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('total_amount', context),
                                  style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color:Theme.of(context).accentColor,
                                  )),
                              Text('${Provider.of<CartProvider>(context, listen: false).amount}',
                                style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor),
                              ),
                            ]),

                          ],
                        ),
                      ),
                    ),
                ) : SizedBox(),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;

  ProductShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3,
        crossAxisCount: ResponsiveHelper.isDesktop(context)?3:ResponsiveHelper.isMobilePhone()?1:ResponsiveHelper.isTab(context)?2:1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Container(
        height: 85,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorResources.getCardBgColor(context),
        ),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: isEnabled,
          child: Row(children: [

            Container(
              height: 85, width: 85,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: ColorResources.getGreyColor(context)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.grey[300]),
                  SizedBox(height: 2),
                  Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.grey[300]),
                  SizedBox(height: 10),
                  Container(height: 10, width: 50, color: Colors.grey[300]),
                ]),
              ),
            ),

            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(height: 15, width: 50, color: Colors.grey[300]),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add, color: Theme.of(context).primaryColor),
              ),
            ]),

          ]),
        ),
      ),
      itemCount: 20,
    );
  }
}
