import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/login.dart';
import 'package:banksampah/select_location.dart';
import 'package:banksampah/verify_email.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;

void main() => runApp(CompleteSignupBS(null, null));

class CompleteSignupBS extends StatefulWidget {
  final context, string;
  CompleteSignupBS(this.context, this.string);
  
  @override
  CompleteSignupBSState createState() => CompleteSignupBSState();
}

class CompleteSignupBSState extends State<CompleteSignupBS> {
  bool passwordHidden = true;
  Completer<GoogleMapController> _controller = Completer();
  String selectedAddress = "";
  double selectedLat = 0, selectedLng = 0;
  GoogleMapController? mapController = null;
  /*final bankNameController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  final phoneController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  final addressController = TextEditingController(text: "");*/
  final bankNameController = TextEditingController(text: "Bank Sampah 1");
  final emailController = TextEditingController(text: "danaos.apps@gmail.com");
  final phoneController = TextEditingController(text: "081123456782");
  final passwordController = TextEditingController(text: "abc");
  final addressController = TextEditingController(text: "Jakarta");

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<dynamic> result = await Global.getCurrentAddress();
    setState(() {
      selectedLat = result[0];
      selectedLng = result[1];
      selectedAddress = result[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var transparentBorder = new BorderSide(color: Colors.transparent);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 100, left: 15, right: 15),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  child: Text(string!.text27,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))),
              Container(
                  child: Text(widget.string.text28, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 17)),
                  margin: EdgeInsets.only(top: 4)),
              Container(
                  width: MediaQuery.of(context).size.width - 15 - 15,
                  height: 50,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0x4D9FA2B4)), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(
                        width: 40,
                        margin: EdgeInsets.only(left: 20),
                        child: Image.asset("assets/images/full_name.png", width: 20, height: 20)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextField(
                      cursorColor: Color(Global.mainColor),
                      controller: bankNameController,
                      decoration: InputDecoration(
                          hintText: widget.string.text32,
                          hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                          border: new UnderlineInputBorder(borderSide: transparentBorder),
                          enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                          focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                    ))
                  ])),
              Container(
                  width: MediaQuery.of(context).size.width - 15 - 15,
                  height: 50,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0x4D9FA2B4)), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(
                        width: 40,
                        margin: EdgeInsets.only(left: 20),
                        child: Image.asset("assets/images/email.png", width: 20, height: 20)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextField(
                      cursorColor: Color(Global.mainColor),
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: widget.string.email,
                          hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                          border: new UnderlineInputBorder(borderSide: transparentBorder),
                          enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                          focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                    ))
                  ])),
              Container(
                  width: MediaQuery.of(context).size.width - 15 - 15,
                  height: 50,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0x4D9FA2B4)), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(
                        width: 40,
                        margin: EdgeInsets.only(left: 20),
                        child: Image.asset("assets/images/phone.png", width: 20, height: 20)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextField(
                      cursorColor: Color(Global.mainColor),
                      controller: phoneController,
                      decoration: InputDecoration(
                          hintText: widget.string.phone,
                          hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                          border: new UnderlineInputBorder(borderSide: transparentBorder),
                          enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                          focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                    ))
                  ])),
              Container(
                  width: MediaQuery.of(context).size.width - 15 - 15,
                  height: 50,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0x4D9FA2B4)), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(
                        width: 40,
                        margin: EdgeInsets.only(left: 20),
                        child: Image.asset("assets/images/lock.png", width: 25, height: 25)),
                    SizedBox(width: 10),
                    Container(
                        width: MediaQuery.of(context).size.width - 102,
                        child: Stack(children: [
                          Container(
                              width: MediaQuery.of(context).size.width - 102,
                              height: 40,
                              child: TextField(
                                cursorColor: Color(Global.mainColor),
                                obscureText: passwordHidden,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    hintText: widget.string.password,
                                    hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                                    border: new UnderlineInputBorder(borderSide: transparentBorder),
                                    enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                    focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      passwordHidden = !passwordHidden;
                                    });
                                  },
                                  child: Container(
                                      width: 50,
                                      height: 50,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              passwordHidden
                                                  ? "assets/images/view_password.png"
                                                  : "assets/images/hide_password.png",
                                              width: 20,
                                              height: 20)))))
                        ]))
                  ])),
              Container(
                  width: MediaQuery.of(context).size.width - 15 - 15,
                  height: 50,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0x4D9FA2B4)), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(
                        width: 40,
                        margin: EdgeInsets.only(left: 20),
                        child: Image.asset("assets/images/map_marker.png", width: 20, height: 20)),
                    SizedBox(width: 10),
                    Flexible(
                        child: TextField(
                      cursorColor: Color(Global.mainColor),
                      controller: addressController,
                      decoration: InputDecoration(
                          hintText: widget.string.address,
                          hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                          border: new UnderlineInputBorder(borderSide: transparentBorder),
                          enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                          focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                    ))
                  ])),
              SizedBox(height: 30),
              FutureBuilder<List<dynamic>>(
                  future: Global.getCurrentAddress(),
                  builder: (context, snapshot) {
                    double lat = snapshot.data![0];
                    double lng = snapshot.data![1];
                    String address = snapshot.data![2];
                    //print("LAT:");
                    //print(lat);
                    //print("LNG:");
                    //print(lng);
                    //print("ADDRESS:");
                    //print(address);
                    return Row(children: [
                      Stack(children: [
                        Container(
                            width: 100,
                            height: 100,
                            child: GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: false,
                                myLocationEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(selectedLat, selectedLng),
                                  zoom: 14.4746,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  setState(() {
                                    mapController = controller;
                                  });
                                })),
                        Container(
                            width: 100,
                            height: 100,
                            child: Align(
                                alignment: Alignment.center,
                                child: Image.asset("assets/images/map_pin.png", width: 20, height: 20)))
                      ]),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            LatLng result = await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => SelectLocation(widget.context, widget.string)));
                            var address = await Global.getAddress(result.latitude, result.longitude);
                            setState(() {
                              selectedLat = result.latitude;
                              selectedLng = result.longitude;
                              selectedAddress = address;
                            });
                            mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                bearing: 192.8334901395799,
                                target: LatLng(selectedLat, selectedLng),
                                tilt: 59.440717697143555,
                                zoom: 19.151926040649414)));
                          },
                          child: Container(
                              width: screenWidth - 15 - 15 - 100 - 10,
                              child: Stack(children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(widget.string.text29, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 17)),
                                  Text(selectedAddress,
                                      style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))
                                ]),
                                Align(alignment: Alignment.centerRight, child: Icon(Ionicons.chevron_forward_outline))
                              ])))
                    ]);
                  }),
              GestureDetector(
                  onTap: () async {
                    final bankName = bankNameController.text;
                    final email = emailController.text;
                    final phone = phoneController.text;
                    final password = passwordController.text;
                    final address = addressController.text;
                    if (bankName.trim() == "" ||
                        email.trim() == "" ||
                        phone.trim() == "" ||
                        password.trim() == "" ||
                        address.trim() == "") {
                      Global.alert(context, widget.string.information, widget.string.text35);
                      return;
                    }
                    Global.showLoadingDialog(context);
                    final response = await http.post(Uri.parse(Global.API_URL + "/user/signup_as_bsu"),
                        body: <String, String>{
                          'name': bankName,
                          'email': email,
                          'phone': phone,
                          'password': password,
                          'address': address
                        });
                    Global.dismissProgressDialog(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyEmail(context, widget.string, bankName, email, phone, password, address)));
                  },
                  child: Container(
                      width: screenWidth - 15 - 15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Global.mainColor)),
                      margin: EdgeInsets.only(top: 30),
                      height: 50,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(widget.string.signup,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))),
            ])));
  }
}
