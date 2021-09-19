import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/choose_item.dart';
import 'package:banksampah/login.dart';
import 'package:banksampah/kurs_calculator.dart';
import 'package:banksampah/antar_sampah.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(BankDetails(null, null, null));

class BankDetails extends StatefulWidget {
  final context, string, bank;
  const BankDetails(this.context, this.string, this.bank);

  @override
  BankDetailsState createState() => BankDetailsState();
}

class BankDetailsState extends State<BankDetails> {
  double distance = 0.0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var position = await Global.getCurrentPosition();
    //print("MY LATITUDE: " + position.latitude.toString());
    //print("MY LONGITUDE: " + position.longitude.toString());
    //print("BANK LATITUDE: " + widget.bank['latitude']);
    //print("BANK LONGITUDE: " + widget.bank['longitude']);
    //double distance = Global.getDistance(-6.2293867,106.6894296,-7.2754438,112.6426427);
    double _distance = Global.getDistance(position.latitude, position.longitude, double.parse(widget.bank['latitude']),
        double.parse(widget.bank['longitude']));
    //print("DISTANCE: " + _distance.toString());
    setState(() {
      distance = _distance;
    });
  }

  Future<String> getExchangeRates() async {
    final response =
        await http.post(Uri.parse(Global.API_URL + "/user/get_exchange_rates"), body: <String, String>{'limit': "5"});
    return response.body;
  }

  Future<String> getBankAdmins() async {
    final response =
        await http.post(Uri.parse(Global.API_URL + "/user/get_bank_admins"), body: <String, String>{'limit': "5"});
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var transparentBorder = new BorderSide(color: Colors.transparent);
    var images = widget.bank['images'];
    //print("ALL BANK IMAGES:");
    //print(images);
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.bank['title'], style: TextStyle(color: Colors.white)),
            backgroundColor: Color(Global.mainColor),
            iconTheme: IconThemeData(color: Colors.white)),
        backgroundColor: Color(0xFFE5E5E5),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              width: width,
              height: 300,
              child: PageIndicatorContainer(
                  align: IndicatorAlign.bottom,
                  length: images.length,
                  indicatorSpace: 20.0,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  indicatorColor: Color(0xFFFFFFFF),
                  indicatorSelectorColor: Color(Global.mainColor),
                  shape: IndicatorShape.circle(size: 12),
                  child: PageView.builder(itemBuilder: (context, index) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(Global.USERDATA_URL + "banksampah/userdata/" + images[index]['image_path'],
                            width: MediaQuery.of(context).size.width, height: 240, fit: BoxFit.fill));
                  }))),
          Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Color(Global.mainColor), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Container(
                    width: (width - 15 - 15) * 0.33 - 2,
                    child: GestureDetector(
                        onTap: () {
                          launch("tel://" + widget.bank['phone']);
                        },
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Icon(Ionicons.call_outline, color: Colors.white),
                          SizedBox(height: 8),
                          Text(string!.text45,
                              style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center)
                        ]))),
                Container(width: 1, height: 80, color: Color(0x7FFFFFFF)),
                Container(
                  width: (width - 15 - 15) * 0.33 - 2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Icon(Ionicons.time_outline, color: Colors.white),
                    SizedBox(height: 8),
                    Text(widget.bank['open_hour'] + " - " + widget.bank['close_hour'],
                        style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center)
                  ]),
                ),
                Container(width: 1, height: 80, color: Color(0x7FFFFFFF)),
                Container(
                  width: (width - 15 - 15) * 0.33 - 2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Icon(Ionicons.map, color: Colors.white),
                    SizedBox(height: 8),
                    Text(distance.toStringAsFixed(2) + " km",
                        style: TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center)
                  ]),
                )
              ])),
          Container(
              padding: EdgeInsets.all(15),
              width: width,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.string.address, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
                Text(widget.bank['address'], style: TextStyle(color: Color(0xFF747474), fontSize: 14)),
              ])),
          Container(
              width: width,
              child: Stack(children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 50,
                        child: GestureDetector(
                            onTap: () {},
                            child: Text(widget.string.text47,
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))))),
                Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        margin: EdgeInsets.only(right: 15),
                        height: 50,
                        child: GestureDetector(
                            onTap: () {},
                            child: Text(widget.string.text48,
                                style: TextStyle(color: Color(Global.mainColor), fontWeight: FontWeight.bold)))))
              ])),
          Container(
              padding: EdgeInsets.all(15),
              width: width,
              child: Text(widget.string.text47,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(children: [
                FutureBuilder<String>(
                    future: getExchangeRates(),
                    builder: (context, snapshot) {
                      var exchangeRates = json.decode(snapshot.data!);
                      //print("EXCHANGE RATES:");
                      //print(exchangeRates);
                      return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3, crossAxisSpacing: 20, mainAxisSpacing: 20, crossAxisCount: 2),
                          physics: NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: exchangeRates.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                                height: 60,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Image.network(Global.USERDATA_URL + "banksampah/userdata/" + exchangeRates[index]['icon'],
                                      width: 35, height: 35),
                                  Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 60,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(exchangeRates[index]['title_id'],
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.fade),
                                            Text("Rp" + exchangeRates[index]['price'].toString() + "/kg",
                                                style: TextStyle(color: Color(Global.mainColor), fontSize: 14),
                                                overflow: TextOverflow.fade)
                                          ]))
                                ]));
                          });
                    }),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                    decoration: BoxDecoration(color: Color(0x1127AE60), borderRadius: BorderRadius.circular(10)),
                    height: 45,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => KursCalculator(widget.context, widget.string,
                            widget.bank))
                          );
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(widget.string.text50,
                                style: TextStyle(
                                    color: Color(Global.mainColor), fontWeight: FontWeight.bold, fontSize: 17)))))
              ])),
          Container(
              padding: EdgeInsets.all(15),
              width: width,
              child: Text(widget.string.text51,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
          FutureBuilder<String>(
              future: getBankAdmins(),
              builder: (context, snapshot) {
                var bankAdmins = json.decode(snapshot.data!);
                //print("BANK ADMINS:");
                //print(bankAdmins);
                return Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1, crossAxisSpacing: 20, mainAxisSpacing: 20, crossAxisCount: 2),
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: bankAdmins.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                  onTap: () {
                                    launch("tel://" + bankAdmins[index]['phone']);
                                  },
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                              Global.USERDATA_URL + "banksampah/userdata/" + bankAdmins[index]['profile_picture'],
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                        SizedBox(height: 10),
                                        Text(bankAdmins[index]['role']['role_id'],
                                            style: TextStyle(color: Color(Global.mainColor), fontSize: 13)),
                                        Text(bankAdmins[index]['name'],
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10),
                                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Ionicons.call_outline, color: Colors.black),
                                          SizedBox(width: 8),
                                          Text(bankAdmins[index]['phone'],
                                              style: TextStyle(color: Colors.black, fontSize: 13))
                                        ])
                                      ])));
                        }));
              }),
          SizedBox(height: 20),
          Container(
              width: width,
              height: 45,
              child: Stack(children: [
                Container(
                    margin: EdgeInsets.only(left: 15, right: 70),
                    width: width - 15 - 70,
                    height: 45,
                    decoration: BoxDecoration(color: Color(Global.mainColor), borderRadius: BorderRadius.circular(8)),
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (Global.USER_ID == 0) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login(widget.context, widget.string)));
                          } else {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseItem(bank)));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AntarSampah(widget.context, widget.string,
                              widget.bank))
                            );
                          }
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(widget.string.text52, style: TextStyle(color: Colors.white, fontSize: 17))))),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        width: 45,
                        height: 45,
                        margin: EdgeInsets.only(right: 15),
                        child: Center(child: Icon(Ionicons.chatbox_ellipses_outline, color: Colors.white)),
                        decoration: BoxDecoration(color: Color(0xFFDB9E35), borderRadius: BorderRadius.circular(8))))
              ])),
          SizedBox(height: 20)
        ])));
  }
}
