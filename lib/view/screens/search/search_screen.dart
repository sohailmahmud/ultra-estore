import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/search_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/search/search_result_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SearchProvider>(context, listen: false).initializeAllSortBy(context, notify: false);

    return Scaffold(
      backgroundColor: ColorResources.getBackgroundColor(context),
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar():null,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Center(
              child: Container(
                width: 1170,
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: getTranslated('search_item_here', context),
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icons.search,
                              controller: _searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {
                                if (_searchController.text.length > 0) {
                                  List<int> _encoded = utf8.encode(_searchController.text);
                                  String _data = base64Encode(_encoded);
                                  searchProvider.saveSearchAddress(_searchController.text);
                                  searchProvider.searchProduct(_searchController.text, context);
                                  Navigator.pushNamed(context, RouteHelper.searchResult+'?text=$_data', arguments: SearchResultScreen(searchString: _searchController.text));
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                                }
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              shadowColor: Theme.of(context).primaryColor,
                            ),
                              child: Text(
                                getTranslated('cancel', context),
                                style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context))),
                              )
                        ],
                      ),
                      // for resent search section
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('recent_search', context),
                            style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context),fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          searchProvider.historyList.length > 0
                              ? TextButton(
                                  onPressed: searchProvider.clearSearchAddress,
                                  child: Text(
                                    getTranslated('remove_all', context),
                                    style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context),fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ))
                              : SizedBox.shrink(),
                        ],
                      ),

                      // for recent search list section
                      Expanded(
                        child: ListView.builder(
                            itemCount: searchProvider.historyList.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    List<int> _encoded = utf8.encode(searchProvider.historyList[index]);
                                    String _data = base64Encode(_encoded);
                                    searchProvider.searchProduct(searchProvider.historyList[index],context);
                                    Navigator.pushNamed(context, RouteHelper.searchResult+'?text=$_data', arguments: SearchResultScreen(searchString: searchProvider.historyList[index]));
                                   // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: searchProvider.historyList[index])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 9),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.history, size: 16, color: ColorResources.getHintColor(context)),
                                            SizedBox(width: 13),
                                            Text(
                                              searchProvider.historyList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                                            )
                                          ],
                                        ),
                                        Icon(Icons.arrow_upward, size: 16, color: ColorResources.getHintColor(context)),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
