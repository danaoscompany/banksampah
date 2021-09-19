import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:banksampah/global.dart';
import 'package:banksampah/verify_email.dart';
import 'package:banksampah/activity.dart';
import 'package:banksampah/bank_sampah.dart';
import 'dart:developer';
import 'screens/news.dart';
import 'screens/map.dart';
import 'package:banksampah/login.dart';
import 'package:banksampah/test.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:page_indicator/page_indicator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jiffy/src/enums/units.dart';
import 'package:geocoder/geocoder.dart';
import 'package:crypto/crypto.dart';
import 'package:banksampah/bank_details.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:banksampah/components/screen_arguments.dart';

void main() {
  runApp(Home(null, null));
}

class Home extends StatefulWidget {
  final context, string;
  Home(this.context, this.string);
  
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String userName = "Guest User", email = "", password = "";
  var currentBottomMenuIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    email = await Global.read("email", "");
    password = await Global.read("password", "");
    //print("SAVED EMAIL: " + email + ", PASSWORD: " + password);
    if (email != null && email.trim() != "" && password != null && password.trim() != "") {
      final response = await http.post(Uri.parse(Global.API_URL + "/user/login"),
          body: <String, String>{'email': email, 'password': password});
      var userJSON = json.decode(response.body);
      var responseCode = userJSON['response_code'];
      if (responseCode == 1) {
        Global.USER_ID = int.parse(userJSON['id']);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            userName = userJSON['name'];
            email = userJSON['email'];
          });
        });
      } else if (responseCode == -1) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            userName = "Guest User";
            email = "";
          });
        });
      }
    }
  }

  _getNavigationContent(int index) {
    if (index == 0) {
      return News(widget.context, widget.string);
    } else if (index == 1) {
      return Map();
    }
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

  Future<String> getNearestBanks(double lat, double lng) async {
    if (lat == null || lng == null) {
      return "[]";
    }
    final response = await http.post(Uri.parse(Global.API_URL + "/user/get_nearest_banks"), body: <String, String>{
      'latitude': lat.toString(),
      'longitude': lng.toString(),
    });
    return response.body;
  }

  Future<String> getInformations() async {
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_informations"));
    return response.body;
  }

  Future<String> getMaterials() async {
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_news"));
    return response.body;
  }

  double getDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void onBottomNavigationSelected(int index) async {
    setState(() {
      currentBottomMenuIndex = index;
    });
    if (email != null && email.trim() != "" && password != null && password.trim() != "") {
      if (currentBottomMenuIndex == 0) {
        Navigator.pushReplacement(widget.context, MaterialPageRoute(builder: (context) => Home(widget.context, widget.string)));
      } else if (currentBottomMenuIndex == 1) {
        Navigator.pushReplacement(widget.context, MaterialPageRoute(builder: (context) => Activity(widget.context, widget.string, null, null, null)));
      } else if (currentBottomMenuIndex == 2) {
      } else if (currentBottomMenuIndex == 3) {}
    } else {
      Navigator.push(widget.context, MaterialPageRoute(builder: (context) => Login(widget.context, widget.string)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder<Position>(
        future: getPosition(),
        builder: (context, snapshot) {
          var position = snapshot.data;
          double lat = 0, lng = 0;
          if (position != null) {
            lat = position.latitude;
            lng = position.longitude;
          }
          return FutureBuilder<String>(
              future: getNearestBanks(lat, lng),
              builder: (context, snapshot) {
                var banks = jsonDecode(snapshot.data!);
                return Scaffold(
                  body: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Container(
                            width: width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF27AE60),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(children: [
                              SizedBox(height: 25),
                              Text(widget.string!.text20,
                                  style: TextStyle(
                                    color: Color(0x4CFFFFFF),
                                    fontSize: 17,
                                  )),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.string.text12, style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 1),
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text(userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 10),
                            ])),
                        SizedBox(height: 20),
                        Stack(children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(widget.string.text14,
                                      style:
                                          TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)))),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BankSampah(widget.context,
                                      widget.string))
                                    );
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      height: 50,
                                      child: Text(widget.string.view_all,
                                          style: TextStyle(
                                              color: Color(Global.mainColor),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)))))
                        ]),
                        SizedBox(height: 5),
                        Container(
                            height: 100,
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: banks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //print("IMAGE URL:");
                                  //print(Global.USERDATA_URL + banks[index]['image_path']);
                                  var imageURL = Global.USERDATA_URL + banks[index]['image_path'];
                                  return Container(
                                      width: 100,
                                      height: 250,
                                      margin: EdgeInsets.only(left: 5, right: 5),
                                      child: GestureDetector(
                                          onTap: () {
                                            /*Global.navigatorKey.currentState!.pushNamed('/bank_details',
                                            	arguments: ScreenArguments(jsonEncode({
                                            		'bank': banks[index]
                                            	}))
                                            );*/
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => BankDetails(widget.context, widget.string,
                                                  banks[index]))
                                                );
                                          },
                                          child: Stack(children: [
                                            Container(
                                                child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.network(imageURL,
                                                  width: 100.0, height: 250.0, fit: BoxFit.fill),
                                            )),
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: Container(
                                                    width: 100,
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomLeft,
                                                            colors: [Color(0x00000000), Color(0xFF000000)])))),
                                            Container(
                                                width: 100,
                                                height: 250,
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
                                                                    getDistance(
                                                                                lat,
                                                                                lng,
                                                                                double.parse(banks[index]['latitude']),
                                                                                double.parse(banks[index]['longitude']))
                                                                            .toStringAsFixed(2) +
                                                                        " Km",
                                                                    style: TextStyle(color: Colors.white, fontSize: 11))
                                                              ])
                                                            ]))))
                                          ])));
                                })),
                        SizedBox(height: 10, child: Container(color: Color(0xFFF2F3F5))),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Text(widget.string.text15,
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
                        FutureBuilder<String>(
                            future: getInformations(),
                            builder: (context, snapshot) {
                              //print("ALL INFORMATIONS:");
                              //print(snapshot.data!);
                              var informations = jsonDecode(snapshot.data!);
                              return Container(
                                  height: 200,
                                  margin: EdgeInsets.only(top: 5),
                                  child: PageIndicatorContainer(
                                      align: IndicatorAlign.bottom,
                                      length: informations.length,
                                      indicatorSpace: 20.0,
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                      indicatorColor: Color(0xFFA8A8A8),
                                      indicatorSelectorColor: Color(0xFF27AE60),
                                      shape: IndicatorShape.circle(size: 12),
                                      child: PageView.builder(itemBuilder: (context, index) {
                                        return Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 35),
                                            child: Stack(children: [
                                              ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: Image.network(
                                                      Global.USERDATA_URL + informations[index]['image_path'],
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 240,
                                                      fit: BoxFit.fill)),
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 240,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomLeft,
                                                          colors: [Color(0x00000000), Color(0xFF000000)]))),
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 200,
                                                  child: Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Container(
                                                          height: 50,
                                                          margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(informations[index]['title'],
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold),
                                                                    maxLines: 1),
                                                                SizedBox(height: 5),
                                                                Text(
                                                                    Jiffy(informations[index]['date'])
                                                                        .format("d MMMM yyyy"),
                                                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                                                    maxLines: 1)
                                                              ]))))
                                            ]));
                                      })));
                            }),
                        SizedBox(height: 10, child: Container(color: Color(0xFFF2F3F5))),
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Text(widget.string.text16,
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
                        FutureBuilder<String>(
                            future: getMaterials(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Container(width: 0, height: 0);
                              }
                              var materials = jsonDecode(snapshot.data!);
                              //print("ALL MATERIALS:");
                              //print(materials);
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: materials.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        padding: EdgeInsets.all(8),
                                        child: Row(children: [
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.network(Global.USERDATA_URL + materials[index]['image_path'],
                                                  width: 100, height: 100, fit: BoxFit.fill)),
                                          SizedBox(width: 10),
                                          Expanded(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(Jiffy(materials[index]['date']).format("d MMMM yyyy"),
                                                style: TextStyle(
                                                    color: Color(Global.mainColor),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                                textAlign: TextAlign.left),
                                            Text(materials[index]['title'],
                                                style: TextStyle(
                                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                                maxLines: 3,
                                                textAlign: TextAlign.left)
                                          ]))
                                        ]));
                                  });
                            })
                      ])),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: currentBottomMenuIndex,
                    onTap: onBottomNavigationSelected,
                    items: [
                      BottomNavigationBarItem(
                        icon: new Image.asset(
                            currentBottomMenuIndex == 0 ? "assets/images/home_selected.png" : "assets/images/home.png",
                            width: 20,
                            height: 20),
                        title: new Text(widget.string.home,
                            style: TextStyle(
                                color: currentBottomMenuIndex == 0 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                                fontWeight: currentBottomMenuIndex == 0 ? FontWeight.bold : FontWeight.normal)),
                      ),
                      BottomNavigationBarItem(
                        icon: new Image.asset(
                            currentBottomMenuIndex == 1
                                ? "assets/images/activity_selected.png"
                                : "assets/images/activity.png",
                            width: 20,
                            height: 20),
                        title: new Text(widget.string.activity,
                            style: TextStyle(
                                color: currentBottomMenuIndex == 1 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                                fontWeight: currentBottomMenuIndex == 1 ? FontWeight.bold : FontWeight.normal)),
                      ),
                      BottomNavigationBarItem(
                        icon: new Image.asset(
                            currentBottomMenuIndex == 2
                                ? "assets/images/message_selected.png"
                                : "assets/images/message.png",
                            width: 20,
                            height: 20),
                        title: new Text(widget.string.message,
                            style: TextStyle(
                                color: currentBottomMenuIndex == 2 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                                fontWeight: currentBottomMenuIndex == 2 ? FontWeight.bold : FontWeight.normal)),
                      ),
                      BottomNavigationBarItem(
                        icon: new Image.asset(
                            currentBottomMenuIndex == 3 ? "assets/images/user_selected.png" : "assets/images/user.png",
                            width: 20,
                            height: 20),
                        title: new Text(widget.string.profile,
                            style: TextStyle(
                                color: currentBottomMenuIndex == 3 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                                fontWeight: currentBottomMenuIndex == 3 ? FontWeight.bold : FontWeight.normal)),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
