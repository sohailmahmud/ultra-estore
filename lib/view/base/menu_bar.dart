import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/view/base/mars_menu_bar.dart';
import 'package:provider/provider.dart';


class MenuBar extends StatelessWidget {

  // final scaffoldKey;
  //
  // PlutoMenuBarDemo({
  //   this.scaffoldKey,
  // });

  // void message(context, String text) {
  // //  scaffoldKey.currentState.hideCurrentSnackBar();
  //
  //   // final snackBar = SnackBar(
  //   //   content: Text(text),
  //   // );
  //   //
  //   // Scaffold.of(context).showSnackBar(snackBar);
  // }

  List<MenuItem> getMenus(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return [
      MenuItem(
        title: getTranslated('home', context),
        icon: Icons.home_filled,
       onTap: () => Navigator.pushNamed(context, RouteHelper.menu)
           //RouteHelper.router.navigateTo(context, Routes.DASHBOARD),
      ),
      MenuItem(
        title: getTranslated('all_categories', context),
        icon: Icons.category,
        onTap: () => Navigator.pushNamed(context, RouteHelper.categorys),
      ),
  /*    MenuItem(
        title: 'Settings',
        icon: Icons.settings,
        children: [
          MenuItem(
            title: getTranslated('privacy_policy', context),
           // onTap: () => RouteHelper.router.navigateTo(context, Routes.POLICY_SCREEN),
          ),
          MenuItem(
            title: getTranslated('terms_and_condition', context),
           // onTap: () => RouteHelper.router.navigateTo(context, Routes.TERMS_SCREEN),
          ),
          MenuItem(
            title: getTranslated('about_us', context),
           // onTap: () => RouteHelper.router.navigateTo(context, Routes.ABOUT_US_SCREEN),
          ),

        ],
      ),*/
      MenuItem(
        title: getTranslated('useful_links', context),
        icon: Icons.settings,
        children: [
          MenuItem(
            title: getTranslated('privacy_policy', context),
            onTap: () => Navigator.pushNamed(context, RouteHelper.getPolicyRoute()),
          ),
          MenuItem(
            title: getTranslated('terms_and_condition', context),
            onTap: () => Navigator.pushNamed(context, RouteHelper.getTermsRoute()),
          ),
          MenuItem(
            title: getTranslated('about_us', context),
            onTap: () => Navigator.pushNamed(context, RouteHelper.getAboutUsRoute()),
          ),

        ],
      ),
    /*  MenuItem(
        title: 'Favourite',
        icon: Icons.favorite_border,
        //onTap: () => RouteHelper.router.navigateTo(context, Routes.WISHLIST_SCREEN),
      ),*/

      MenuItem(
        title: getTranslated('search', context),
        icon: Icons.search,
        onTap: () =>  Navigator.pushNamed(context, RouteHelper.searchProduct),
      ),

      MenuItem(
        title: getTranslated('menu', context),
        icon: Icons.menu,
        onTap: () => Navigator.pushNamed(context, RouteHelper.profileMenus),
      ),


      _isLoggedIn ?  MenuItem(
        title: getTranslated('profile', context),
        icon: Icons.person,
       onTap: () => Navigator.pushNamed(context, RouteHelper.profile),
      ):  MenuItem(
        title: getTranslated('login', context),
        icon: Icons.lock,
        onTap: () => Navigator.pushNamed(context, RouteHelper.login),
      ),
      MenuItem(
        title: '',
        icon: Icons.shopping_cart,
         onTap: () => Navigator.pushNamed(context, RouteHelper.cart),
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      //color: Colors.white,
    width: 800,
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).accentColor,
        gradient: false,
        goBackButtonText: 'Back',
        textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        moreIconColor: Theme.of(context).textTheme.bodyText1.color,
        menuIconColor: Theme.of(context).textTheme.bodyText1.color,
        menus: getMenus(context),

      ),
    );
  }
}