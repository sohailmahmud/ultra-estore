import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget{
  const AppBarBase({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.black,)),
      backgroundColor: Theme.of(context).accentColor,
      actions: [
        IconButton(
            icon: Stack(clipBehavior: Clip.none, children: [
              Image.asset(Images.cart_icon, color: Theme.of(context).textTheme.bodyText1.color, width: 25),
              Positioned(
                top: -7,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                  child: Text('${Provider.of<CartProvider>(context).cartList.length}',
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 10)),
                ),
              ),
            ]),
            onPressed: () {
              Navigator.pushNamed(context, RouteHelper.cart);
              // Navigator.pushNamed(context, RouteHelper.menu);
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenuScreen()));
            }),
        IconButton(
            icon: Icon(Icons.search, size: 30, color: Theme.of(context).textTheme.bodyText1.color),
            onPressed: () {
              Navigator.pushNamed(context, RouteHelper.searchProduct);
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
            }),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.maxFinite, 50);
}
