import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatelessWidget {
  final String title;
  final bool isActive;
  OrderButton({@required this.isActive, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderProvider>(builder: (context, orderProvider, child) {
        return InkWell(
          onTap: () {
            orderProvider.changeActiveOrderStatus(isActive);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: orderProvider.isActiveOrder == isActive ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              '$title (${isActive ? orderProvider.runningOrderList.length : orderProvider.historyOrderList.length})',
              style: poppinsRegular.copyWith(color: orderProvider.isActiveOrder == isActive
                  ? Theme.of(context).accentColor : Theme.of(context).textTheme.bodyText1.color),
            ),
          ),
        );
      },
      ),
    );
  }
}
