import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/login.dart';
import 'package:banksampah/complete_signup_nasabah.dart';
import 'package:banksampah/complete_signup_bs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(Signup(null, null));

class Signup extends StatefulWidget {
  final context, string;
  Signup(this.context, this.string);
  
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  int selectedRole = 0;

  @override
  void initState() {
    super.initState();
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
                  child: Text(string!.text20,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))),
              Container(
                  child: Text(widget.string.text21, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 17)),
                  margin: EdgeInsets.only(top: 4)),
              Container(
                  width: screenWidth - 15 - 15,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0x4D9FA2B4)), borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(top: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Stack(children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRole = 0;
                            });
                          },
                          child: Container(
                              width: screenWidth - 15 - 15,
                              padding: EdgeInsets.all(14),
                              child: Text(widget.string.text22, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 16)))),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(top: 14, right: 10),
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0x7FA8A8A8)),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: selectedRole == 0 ? Color(Global.mainColor) : Colors.transparent)))))
                    ]),
                    Container(margin: EdgeInsets.only(left: 10, right: 10), color: Color(0x7FA8A8A8), height: 1),
                    Stack(children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRole = 1;
                            });
                          },
                          child: Container(
                              width: screenWidth - 15 - 15,
                              padding: EdgeInsets.all(14),
                              child: Text(widget.string.text23, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 16)))),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(top: 14, right: 10),
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0x7FA8A8A8)),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: selectedRole == 1 ? Color(Global.mainColor) : Colors.transparent)))))
                    ]),
                    Container(margin: EdgeInsets.only(left: 10, right: 10), color: Color(0x7FA8A8A8), height: 1),
                    Stack(children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRole = 2;
                            });
                          },
                          child: Container(
                              width: screenWidth - 15 - 15,
                              padding: EdgeInsets.all(14),
                              child: Text(widget.string.text24, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 16)))),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(top: 14, right: 10),
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0x7FA8A8A8)),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: selectedRole == 2 ? Color(Global.mainColor) : Colors.transparent)))))
                    ])
                  ])),
              GestureDetector(
                  onTap: () {
                    if (selectedRole == 0) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompleteSignupNasabah(widget.context, widget.string)));
                    } else if (selectedRole == 1) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompleteSignupBS(widget.context, widget.string)));
                    } else if (selectedRole == 2) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompleteSignupBS(widget.context, widget.string)));
                    }
                  },
                  child: Container(
                      width: screenWidth - 15 - 15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Global.mainColor)),
                      margin: EdgeInsets.only(top: 40),
                      height: 50,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(widget.string.text25,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))),
              SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(widget.string.text26, style: TextStyle(color: Color(0x44000000), fontSize: 16)),
                SizedBox(width: 5),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login(widget.context, widget.string)));
                    },
                    child: Container(
                        height: 30,
                        child: Align(
                            alignment: Alignment.center,
                            child:
                                Text(widget.string.login, style: TextStyle(color: Color(Global.mainColor), fontSize: 16))))),
              ]),
              SizedBox(height: 30)
            ])));
  }
}
