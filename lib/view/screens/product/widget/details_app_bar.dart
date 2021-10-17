import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:provider/provider.dart';

class DetailsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Key key;
  DetailsAppBar({this.key});

  @override
  DetailsAppBarState createState() => DetailsAppBarState();

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}

class DetailsAppBarState extends State<DetailsAppBar> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
  }

  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0).chain(CurveTween(curve: Curves.elasticIn)).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1.color, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.3),
      backgroundColor: Theme.of(context).accentColor,
      actions: [AnimatedBuilder(
        animation: offsetAnimation,
        builder: (buildContext, child) {
          return Container(
            padding: EdgeInsets.only(left: offsetAnimation.value + 15.0, right: 15.0 - offsetAnimation.value),
            child: IconButton(
              icon: Stack(clipBehavior: Clip.none, children: [
                Image.asset(Images.cart_icon, width: 23, height: 25, color: Theme.of(context).textTheme.bodyText1.color),
                Positioned(
                  top: -7, right: -2,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                    child: Text('${Provider.of<CartProvider>(context).cartList.length}', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 10)),
                  ),
                ),
              ]),
              onPressed: () {
                Provider.of<SplashProvider>(context, listen: false).setPageIndex(2);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MenuScreen()));
              },
            ),
          );
        },
      )],
    );
  }
}
