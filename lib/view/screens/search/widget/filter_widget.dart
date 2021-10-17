import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/search_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  final double maxValue;
  final int index;

  FilterWidget({@required this.maxValue, this.index});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 1170,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, size: 18, color: ColorResources.getTextColor(context)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslated('filter', context),
                      textAlign: TextAlign.center,
                      style: poppinsMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: ColorResources.getTextColor(context),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<CategoryProvider>(context, listen: false).updateSelectCategory(-1);
                      searchProvider.setLowerAndUpperValue(0, 0);
                      searchProvider.setFilterIndex(0);
                    },
                    child: Text(
                      getTranslated('reset', context),
                      style: poppinsRegular.copyWith(color: Colors.red),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Text(
                getTranslated('price', context),
                style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)),
              ),

              // price range
              RangeSlider(
                values: RangeValues(searchProvider.lowerValue, searchProvider.upperValue),
                max: maxValue,
                min: 0,
                activeColor: Theme.of(context).primaryColor,
                labels: RangeLabels(searchProvider.lowerValue.toString(), searchProvider.upperValue.toString()),
                onChanged: (RangeValues rangeValues) {
                  searchProvider.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
                },
              ),

              SizedBox(height: 15),
              Text(
                getTranslated('sort_by', context),
                style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)),
              ),
              SizedBox(height: 13),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    searchProvider.setFilterIndex(index);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 47, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          searchProvider.allSortBy[index],
                          style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: searchProvider.filterIndex == index
                                      ? Theme.of(context).primaryColor
                                      : ColorResources.getHintColor(context),
                                  width: 2)),
                          child: searchProvider.filterIndex == index
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: searchProvider.allSortBy.length,
              ),
              SizedBox(height: 30),

              Container(
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                  buttonText: getTranslated('apply', context),
                  onPressed: () {
                    Provider.of<SearchProvider>(context, listen: false).sortSearchList();
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
