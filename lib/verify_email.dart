import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/main.dart';
import 'package:banksampah/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

void main() => runApp(VerifyEmail(null, null, "", "", "", "", ""));

class VerifyEmail extends StatefulWidget {
  final context;
  final string;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String address;
  const VerifyEmail(this.context, this.string, this.fullName, this.email, this.phone, this.password, this.address);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends State<VerifyEmail> {
  var string;
  String verificationCode = Global.generateRandomNumber(6);
  final code1Controller = TextEditingController();
  final code2Controller = TextEditingController();
  final code3Controller = TextEditingController();
  final code4Controller = TextEditingController();
  final code5Controller = TextEditingController();
  final code6Controller = TextEditingController();
  final code1FocusNode = FocusNode();
  final code2FocusNode = FocusNode();
  final code3FocusNode = FocusNode();
  final code4FocusNode = FocusNode();
  final code5FocusNode = FocusNode();
  final code6FocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    sendVerificationCode();
  }

  void sendVerificationCode() async {
    Global.show("Sending verification code...");
    final response = await http.post(Uri.parse(Global.API_URL + "/user/send_verification_code"),
        body: <String, String>{'email': widget.email, 'verification_code': verificationCode});
  }

  void checkVerificationCode(BuildContext context) async {
    String code = code1Controller.text +
        code2Controller.text +
        code3Controller.text +
        code4Controller.text +
        code5Controller.text +
        code6Controller.text;
    //print("ENTERED CODE: " + code + ", VERIFICATION CODE: " + verificationCode);
    if (code != verificationCode) {
      Global.show(widget.string.text39);
      return;
    }
    Global.showProgressDialog(context, widget.string.text40);
    final response = await http.post(Uri.parse(Global.API_URL + "/user/verify_user_email"), body: <String, String>{
      'email': widget.email,
    });
    Global.dismissProgressDialog(context);
    Global.write("email", widget.email);
    Global.write("password", widget.password);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(widget.context, widget.string)));
  }

  @override
  Widget build(BuildContext context) {
    string = AppLocalizations.of(context);
    var transparentBorder = new BorderSide(color: Colors.transparent);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(string!.text36,
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(widget.string.text37, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 14), textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0x7FA8A8A8), width: 1)),
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: code1Controller,
                            focusNode: code1FocusNode,
                            maxLength: 1,
                            onChanged: (text) {
                              if (text.length > 0) {
                                code2FocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                            style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(width: 10),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0x7FA8A8A8), width: 1)),
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: code2Controller,
                            focusNode: code2FocusNode,
                            maxLength: 1,
                            onChanged: (text) {
                              if (text.length > 0) {
                                code3FocusNode.requestFocus();
                              } else {
                                code1FocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                            style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(width: 10),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0x7FA8A8A8), width: 1)),
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: code3Controller,
                            focusNode: code3FocusNode,
                            maxLength: 1,
                            onChanged: (text) {
                              if (text.length > 0) {
                                code4FocusNode.requestFocus();
                              } else {
                                code2FocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                            style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(width: 10),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0x7FA8A8A8), width: 1)),
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: code4Controller,
                            focusNode: code4FocusNode,
                            maxLength: 1,
                            onChanged: (text) {
                              if (text.length > 0) {
                                code5FocusNode.requestFocus();
                              } else {
                                code3FocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                            style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(width: 10),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0x7FA8A8A8), width: 1)),
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: code5Controller,
                            focusNode: code5FocusNode,
                            maxLength: 1,
                            onChanged: (text) {
                              if (text.length > 0) {
                                code6FocusNode.requestFocus();
                              } else {
                                code4FocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                            style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    SizedBox(width: 10),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0x7FA8A8A8), width: 1)),
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: code6Controller,
                            focusNode: code6FocusNode,
                            maxLength: 1,
                            onChanged: (text) {
                              if (text.length > 0) {
                                checkVerificationCode(context);
                              } else {
                                code5FocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                            style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center))
                  ]),
                  SizedBox(height: 50),
                  GestureDetector(
                      onTap: () {
                        String code1 = code1Controller.text.trim();
                        String code2 = code1Controller.text.trim();
                        String code3 = code1Controller.text.trim();
                        String code4 = code1Controller.text.trim();
                        String code5 = code1Controller.text.trim();
                        String code6 = code1Controller.text.trim();
                        if (code1 == "" || code2 == "" || code3 == "" || code4 == "" || code5 == "" || code6 == "") {
                          Global.show(widget.string.text38);
                          return;
                        }
                      },
                      child: Container(
                          width: width - 15 - 15,
                          height: 45,
                          margin: EdgeInsets.only(left: 15, right: 15, bottom: 50),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Global.mainColor)),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(widget.string.text25,
                                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)))))
                ])));
  }
}
