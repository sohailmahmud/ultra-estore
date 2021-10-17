import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
         height: ResponsiveHelper.isDesktop(context)? 500: MediaQuery.of(context).size.width * 0.4,
         // height: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_SMALL),
          child: banner.bannerList != null ? banner.bannerList.length != 0 ? Stack(
            fit: StackFit.expand,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction:  1,
                  disableCenter: true,
                  onPageChanged: (index, reason) {
                    Provider.of<BannerProvider>(context, listen: false).setCurrentIndex(index);
                  },
                ),
                itemCount: banner.bannerList.length == 0 ? 1 : banner.bannerList.length,
                itemBuilder: (context, index, _) {
                  return InkWell(
                    onTap: () {
                      if(banner.bannerList[index].productId != null) {
                        Product product;
                        for(Product prod in banner.productList) {
                          if(prod.id == banner.bannerList[index].productId) {
                            product = prod;
                            break;
                          }
                        }
                        if(product != null) {
                          Navigator.pushNamed(
                            context, RouteHelper.getProductDetailsRoute(product.id),
                            arguments: ProductDetailsScreen(product: product),
                          );
                        }

                      }else if(banner.bannerList[index].categoryId != null) {
                        CategoryModel category;
                        for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList) {
                          if(categoryModel.id == banner.bannerList[index].categoryId) {
                            category = categoryModel;
                            break;
                          }
                        }
                        if(category != null) {
                          Navigator.of(context).pushNamed(
                            RouteHelper.getCategoryProductsRoute(category.id),
                          );
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                              '/${banner.bannerList[index].image}',
                          fit: BoxFit.cover,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Positioned(
                bottom: 5, left: 0, right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: banner.bannerList.map((bnr) {
                    int index = banner.bannerList.indexOf(bnr);
                    return TabPageSelectorIndicator(
                      backgroundColor: index == banner.currentIndex ? Theme.of(context).primaryColor : ColorResources.getCardBgColor(context),
                      borderColor: index == banner.currentIndex ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
                      size: 10,
                    );
                  }).toList(),
                ),
              ),
            ],
          ) : Center(child: Text(getTranslated('no_banner_available', context))) : Shimmer(
            duration: Duration(seconds: 2),
            enabled: banner.bannerList == null,
            child: Container(margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            )),
          ),
        );
      },
    );
  }

}
