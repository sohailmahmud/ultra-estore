import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/search_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/product_shimmer.dart';
import 'package:flutter_grocery/view/base/product_widget.dart';
import 'package:flutter_grocery/view/screens/search/widget/filter_widget.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchString;

  SearchResultScreen({this.searchString});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar():null,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) => Scrollbar(
                child: SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Container(
                            height: 48,
                            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: ColorResources.getCardBgColor(context),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                                  spreadRadius: 0.5,
                                  blurRadius: 0.5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  searchString,
                                  style: poppinsLight.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.PADDING_SIZE_LARGE),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.close, color: Colors.red, size: 22),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 13),
                          Container(
                            height: 48,
                            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: ColorResources.getCardBgColor(context),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                                  spreadRadius: 0.5,
                                  blurRadius: 0.5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    searchProvider.searchProductList!=null?
                                    Text(
                                      "${searchProvider.searchProductList.length??0}",
                                      style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor),
                                    ):SizedBox.shrink(),
                                    Text(
                                      '${searchProvider.searchProductList!=null?"":0} ${getTranslated('items_found', context)}',
                                      style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)),
                                    )
                                  ],
                                ),
                                searchProvider.searchProductList != null
                                    ? InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                List<double> _prices = [];
                                                searchProvider.filterProductList.forEach((product) => _prices.add(product.price));
                                                _prices.sort();
                                                double _maxValue = _prices.length > 0 ? _prices[_prices.length-1] : 1000;

                                                return Dialog(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                  child: FilterWidget(maxValue: _maxValue),
                                                );
                                              });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0),
                                              border: Border.all(color: ColorResources.getHintColor(context).withOpacity(.5))),
                                          child: Row(
                                            children: [
                                              Icon(Icons.filter_list, color: ColorResources.getTextColor(context)),
                                              Text(
                                                '   ${getTranslated('filter', context)}',
                                                style:
                                                    poppinsMedium.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                          SizedBox(height: 22),
                          searchProvider.searchProductList != null
                              ? searchProvider.searchProductList.length > 0
                                  ?
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 4,
                                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1),
                            itemCount: searchProvider.searchProductList.length,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ProductWidget(product: searchProvider.searchProductList[index]);
                            },
                          )
                                  : NoDataScreen()
                              : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 4,
                                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1),
                            physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  itemBuilder: (context, index) => ProductShimmer(isEnabled: searchProvider.searchProductList == null),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
