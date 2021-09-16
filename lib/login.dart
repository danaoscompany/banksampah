import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/signup.dart';
import 'package:banksampah/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(Login(null, null));

class Login extends StatefulWidget {
  final context, string;
  Login(this.context, this.string);
  
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool passwordHidden = true;
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  /*final emailController = TextEditingController(text: "danaoscompany@gmail.com");
	final passwordController = TextEditingController(text: "abc");*/

  @override
  void initState() {
    super.initState();
  }

  void signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      //print(error);
    }
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
                  child: Text(string!.text12,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))),
              Container(
                  child: Text(widget.string.text17, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 17)),
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
                  margin: EdgeInsets.only(top: 30),
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
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 40,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(widget.string.forgot_password,
                                      style: TextStyle(
                                          color: Color(Global.mainColor),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))))))),
              GestureDetector(
                  onTap: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text;
                    if (email == "" || password.trim() == "") {
                      Global.alert(context, widget.string.information, widget.string.text35);
                      return;
                    }
                    Global.showProgressDialog(context, widget.string.text41);
                    final response = await http.post(Uri.parse(Global.API_URL + "/user/login"),
                        body: <String, String>{'email': email, 'password': password});
                    Global.dismissProgressDialog(context);
                    var userJSON = json.decode(response.body);
                    var responseCode = userJSON['response_code'];
                    if (responseCode == 1) {
                      Global.write("email", email);
                      Global.write("password", password);
                      Global.write("role", userJSON['role']);
                      //Phoenix.rebirth(context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()),
                          ModalRoute.withName(widget.string.app_name));
                    } else if (responseCode == -1) {
                      Global.alert(context, widget.string.error, widget.string.text42);
                    }
                  },
                  child: Container(
                      width: screenWidth - 15 - 15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(Global.mainColor)),
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(widget.string.login,
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))))),
              Container(
                  width: screenWidth - 15 - 15,
                  height: 50,
                  margin: EdgeInsets.only(top: 10),
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(width: screenWidth - 15 - 15, height: 1, color: Color(0xFFA8A8A8))),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: 80,
                            height: 30,
                            color: Colors.white,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(widget.string.or, style: TextStyle(color: Color(0xFF9FA2B4), fontSize: 16))))),
                  ])),
              GestureDetector(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFF2F3F5)),
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset("assets/images/google.png", width: 27, height: 27),
                        SizedBox(width: 10),
                        Text(widget.string.text18, style: TextStyle(color: Color(0xFF5B5454), fontSize: 17))
                      ]))),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFF2F3F5)),
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset("assets/images/facebook.png", width: 27, height: 27),
                        SizedBox(width: 10),
                        Text(widget.string.text19, style: TextStyle(color: Color(0xFF5B5454), fontSize: 17))
                      ]))),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(widget.string.text20, style: TextStyle(color: Color(0x44000000), fontSize: 16)),
                SizedBox(width: 5),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signup(widget.context,
                        widget.string))
                      );
                    },
                    child: Container(
                        height: 30,
                        child: Align(
                            alignment: Alignment.center,
                            child:
                                Text(widget.string.signup, style: TextStyle(color: Color(Global.mainColor), fontSize: 16))))),
              ]),
              SizedBox(height: 30)
            ])));
  }
}
