import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:banksampah/global.dart';
import 'package:banksampah/home.dart';
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

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bank Sampah",
      theme: ThemeData(
          primaryColor: Color(Global.primaryColor),
          accentColor: Color(Global.primaryColor),
          primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
          fontFamily: 'PoppinMedium'),
      //navigatorKey: Global.navigatorKey,
      home: MyHomePage(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> goToHome(context, string) async {
    Global.replaceScreen(context, Home(context, string));
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    return Column(
      children: [
        FutureBuilder<void>(
          future: goToHome(context, string),
          builder: (context, snapshot) {
            return Container();
          }
        ),
        Container(
          color: Colors.white, child: Center(child: Image.asset("assets/images/logo.png", width: 200, height: 200))
        )
      ]
    );
  }
}
