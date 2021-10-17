import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/screens/order/order_details_screen.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel> orderList;
          if (order.runningOrderList != null) {
            orderList = isRunning ? order.runningOrderList.reversed.toList() : order.historyOrderList.reversed.toList();
          }

          return orderList != null ? orderList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
              },

            backgroundColor: Theme.of(context).primaryColor,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                      spreadRadius: 1, blurRadius: 5,
                    )],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    //date and money
                    Row(children: [
                      Text(
                        DateConverter.isoDayWithDateString(orderList[index].updatedAt),
                        style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)),
                      ),
                      Expanded(child: SizedBox.shrink()),
                      Text(
                        PriceConverter.convertPrice(context, orderList[index].orderAmount),
                        style: poppinsBold.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ]),
                    SizedBox(height: 8),
                    //Order list
                    Text('${getTranslated('order_id', context)} #${orderList[index].id.toString()}', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    //item position
                    Row(children: [
                      Icon(Icons.circle, color: Theme.of(context).primaryColor, size: 16),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        '${getTranslated('order_is', context)} ${getTranslated(orderList[index].orderStatus, context)}',
                        style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    SizedBox(
                      height: 50,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        // View Details Button
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              RouteHelper.getOrderDetailsRoute(orderList[index].id),
                              arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                            );
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: ColorResources.getGreyColor(context),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 600 : 100],
                                      spreadRadius: 1,
                                      blurRadius: 5)
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(getTranslated('view_details', context),
                                style: poppinsRegular.copyWith(
                                  color: Colors.black,
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                )),
                          ),
                        ),

                        //Track your Order Button
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 2, color: Theme.of(context).primaryColor))),
                          onPressed: () {
                            Navigator.of(context).pushNamed(RouteHelper.getOrderTrackingRoute(orderList[index].id));
                            },
                          child: Text(getTranslated('track_your_order', context),
                            style: poppinsRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                );
                },
            ),
          )
              : NoDataScreen(isOrder: true)
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
