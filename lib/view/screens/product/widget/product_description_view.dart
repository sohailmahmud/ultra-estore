import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:universal_ui/universal_ui.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class ProductDescription extends StatelessWidget {
  final String productDescription;
  final String id;
  ProductDescription({@required this.productDescription, @required this.id});

  @override
  Widget build(BuildContext context) {
    final String _viewID = id;

    if(ResponsiveHelper.isWeb()) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = productDescription;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }

    return Column(
      children: [
        productDescription.isNotEmpty ? Center(
          child: Container(
            width: 1170,
            height: 100,
            color: Colors.white,
            child: ResponsiveHelper.isWeb() ? Column(
              children: [
                Expanded(child: IgnorePointer(child: HtmlElementView(viewType: _viewID, key: Key(id)))),
              ],
            ) : Center(
              child: SizedBox(width: 1170, child: HtmlWidget(
                productDescription,
                textStyle: poppinsRegular.copyWith(color: Colors.black),
                onTapUrl: (String url) {
                  launch(url);
                },
                hyperlinkColor: Colors.blue,
              ),
              ),
            ),
          ),
        ) : Center(child: Text(getTranslated('no_description', context))),
      ],
    );
  }
}

