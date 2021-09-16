import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/bank_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:jiffy/src/enums/units.dart';

void main() => runApp(BankSampah(null, null));

class BankSampah extends StatefulWidget {
  final context, string;
  BankSampah(this.context, this.string);
  
  @override
  BankSampahState createState() => BankSampahState();
}

class BankSampahState extends State<BankSampah> {
  final queryController = TextEditingController();
  int currentCategory = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<String> getBanks(double lat, double lng) async {
    if (currentCategory == 0) {
      final response = await http.post(Uri.parse(Global.API_URL + "/user/get_nearest_banks"), body: <String, String>{
        'latitude': lat.toString(),
        'longitude': lng.toString(),
      });
      return response.body;
    } else if (currentCategory == 1) {
      final response = await http.post(Uri.parse(Global.API_URL + "/user/get_open_banks"),
          body: <String, String>{'time': Jiffy().format('HH:mm')});
      //print("ALL OPEN BANKS:");
      //print(response.body);
      return response.body;
    }
    return "[]";
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var transparentBorder = new BorderSide(color: Colors.transparent);
    return Scaffold(
        appBar: AppBar(
            title: Text(string!.text43, style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black)),
        backgroundColor: Color(0xFFE5E5E5),
        body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(children: [
              Container(
                  width: width - 10 - 10,
                  height: 45,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Container(
                        width: 50,
                        height: 45,
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(Ionicons.search_outline, color: Color(0xFFA8A8A8)))),
                    Container(
                        width: width - 10 - 10 - 50,
                        height: 45,
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: queryController,
                            decoration: InputDecoration(
                                hintText: widget.string.text44,
                                hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder))))
                  ])),
              SizedBox(height: 10),
              Container(
                  height: 50,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Color(currentCategory == 0 ? 0xFF27AE60 : 0xFFE8F2D1),
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentCategory = 0;
                              });
                            },
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(widget.string.nearest,
                                    style: TextStyle(
                                        color: Color(currentCategory == 0 ? 0xFFFFFFFF : 0xFF27AE60), fontSize: 14))))),
                    SizedBox(width: 10),
                    Container(
                        decoration: BoxDecoration(
                            color: Color(currentCategory == 1 ? 0xFF27AE60 : 0xFFE8F2D1),
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentCategory = 1;
                              });
                            },
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(widget.string.open_now,
                                    style: TextStyle(
                                        color: Color(currentCategory == 1 ? 0xFFFFFFFF : 0xFF27AE60), fontSize: 14))))),
                    SizedBox(width: 10)
                  ])),
              SizedBox(height: 10),
              FutureBuilder<Position>(
                  future: getPosition(),
                  builder: (context, snapshot) {
                    //print("CURRENT POSITION:");
                    //print(snapshot.data);
                    var position = snapshot.data;
                    double lat = 0, lng = 0;
                    if (position != null) {
                      lat = position.latitude;
                      lng = position.longitude;
                    }
                    return FutureBuilder<String>(
                        future: getBanks(lat, lng),
                        builder: (context, snapshot) {
                          var banks = jsonDecode(snapshot.data!);
                          return Container(
                              height: height - 181,
                              child: GridView.builder(
                                  itemCount: banks.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 8.0),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => BankDetails(widget.context, widget.string,
                                                banks[index]))
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                            child: Stack(children: [
                                              ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: FractionallySizedBox(
                                                      widthFactor: 1,
                                                      heightFactor: 1,
                                                      child: Image.network(
                                                          Global.USERDATA_URL + banks[index]['image_path'],
                                                          width: width / 2 - 8 - 8,
                                                          height: 150,
                                                          fit: BoxFit.fill))),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomLeft,
                                                          colors: [Color(0x00000000), Color(0xFF000000)]))),
                                              Container(
                                                  child: new Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Container(
                                                          margin: EdgeInsets.only(left: 5, right: 5),
                                                          height: 50,
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(banks[index]['title'],
                                                                    style: TextStyle(color: Colors.white, fontSize: 11),
                                                                    maxLines: 2),
                                                                Row(children: [
                                                                  Icon(Ionicons.navigate_outline,
                                                                      color: Colors.white, size: 15),
                                                                  Text(
                                                                      Global.getDistance(
                                                                                  lat,
                                                                                  lng,
                                                                                  double.parse(
                                                                                      banks[index]['latitude']),
                                                                                  double.parse(
                                                                                      banks[index]['longitude']))
                                                                              .toStringAsFixed(2) +
                                                                          " Km",
                                                                      style:
                                                                          TextStyle(color: Colors.white, fontSize: 11))
                                                                ])
                                                              ]))))
                                            ])));
                                  }));
                        });
                  })
            ])));
  }
}
