import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/address/widget/adress_widget.dart';
import 'package:provider/provider.dart';
import 'add_new_address_screen.dart';


class AddressScreen extends StatelessWidget {

  final AddressModel addressModel;
  AddressScreen({this.addressModel});
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context)? MainAppBar(): AppBarBase(),
        body: _isLoggedIn ? Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 1170,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated('saved_address', context),
                          style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(RouteHelper.getAddAddressRoute('address'), arguments: AddNewAddressScreen());
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: ColorResources.getTextColor(context)),
                              Text(
                                getTranslated('add_new', context),
                                style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                locationProvider.addressList != null ? locationProvider.addressList.length > 0 ?

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Scrollbar(
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: ListView.builder(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: locationProvider.addressList.length,
                            itemBuilder: (context, index) => AddressWidget(
                              addressModel: locationProvider.addressList[index],
                              index: index,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : NoDataScreen()
                    : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ],
            );
          },
        ) : NotLoggedInScreen(),
    );
  }

  

}