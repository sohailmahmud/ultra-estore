import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:typed_data';
import 'dart:ui';

import '../../../../utill/images.dart';

class MapWidget extends StatefulWidget {
  final AddressModel address;
  MapWidget({@required this.address});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng _latLng;
  Set<Marker> _markers = Set.of([]);

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('delivery_address', context)),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _latLng, zoom: 17),
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          indoorViewEnabled: true,
          markers:_markers,
        ),
        Positioned(
          left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_LARGE,
          child: Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).accentColor,
              boxShadow: [BoxShadow(color: Colors.grey[300], spreadRadius: 3, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(children: [

                  Icon(
                    widget.address.addressType == 'Home' ? Icons.home_outlined : widget.address.addressType == 'Workplace'
                        ? Icons.work_outline : Icons.list_alt_outlined,
                    size: 30, color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(widget.address.addressType, style: poppinsRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context),
                      )),

                      Text(widget.address.address, style: poppinsRegular),

                    ]),
                  ),
                ]),

                Text('- ${widget.address.contactPersonName}', style: poppinsRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),

                Text('- ${widget.address.contactPersonNumber}', style: poppinsRegular),

              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData = await convertAssetToUnit8List(Images.map_marker, width: 70);

    _markers = Set.of([]);
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      position: _latLng,
      icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

}
