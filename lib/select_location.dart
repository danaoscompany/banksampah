import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;

void main() => runApp(SelectLocation(null, null));

class SelectLocation extends StatefulWidget {
  final context, string;
  SelectLocation(this.context, this.string);
  
  @override
  SelectLocationState createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> {
  Set<Marker> markers = {};
  LatLng selectedLocation = LatLng(-6.2269927, 106.8259433);
  bool locationSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            color: Color(0xFFF9F9F9),
            child: Column(children: [
              SizedBox(height: 50),
              Row(children: [
                SizedBox(width: 10),
                Icon(Ionicons.chevron_back_outline),
                Text(string!.text33, style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold))
              ]),
              Container(
                  width: screenWidth,
                  height: screenHeight - 50 - 54,
                  margin: EdgeInsets.only(top: 20),
                  child: Stack(children: [
                    FutureBuilder<Position>(
                        future: Global.getCurrentPosition(),
                        builder: (context, snapshot) {
                          var position = snapshot.data!;
                          print("CURRENT POSITION:");
                          print(position);
                          double lat = 0.0, lng = 0.0;
                          if (position != null) {
                            lat = position.latitude;
                            lng = position.longitude;
                          }
                          return GoogleMap(
                              mapType: MapType.normal,
                              zoomControlsEnabled: false,
                              myLocationEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(lat, lng),
                                zoom: 14.4746,
                              ),
                              markers: markers,
                              onTap: (latLng) async {
                                if (markers.length >= 1) {
                                  markers.clear();
                                }
                                final markerIcon = await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(size: Size(12, 12)),
                                    "assets/images/selected_location_marker.png");
                                setState(() {
                                  selectedLocation = latLng;
                                  locationSelected = true;
                                  markers.add(Marker(markerId: MarkerId("1"), position: latLng, icon: markerIcon));
                                });
                              });
                        }),
                    Container(
                        width: screenWidth,
                        height: 100,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFFF9F9F9), Color(0x00F9F9F9)]))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                            onTap: () {
                              if (selectedLocation == null) {
                                Global.show(widget.string.text31);
                                return;
                              }
                              Navigator.pop(context, selectedLocation);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width - 15 - 15,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: Color(Global.mainColor)),
                                margin: EdgeInsets.only(left: 15, bottom: 15, right: 15),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(widget.string.text30,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))))))
                  ])),
            ])));
  }
}
