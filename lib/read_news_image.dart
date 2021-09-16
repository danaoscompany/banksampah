import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:jiffy/src/enums/units.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(ReadNewsImage(null, null, ""));

class ReadNewsImage extends StatefulWidget {
  final context, string, news;
  const ReadNewsImage(this.context, this.string, this.news);

  @override
  ReadNewsImageState createState() => ReadNewsImageState();
}

class ReadNewsImageState extends State<ReadNewsImage> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var newsJSON = jsonDecode(widget.news);
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            string!.text10,
            style: new TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
              width: screenWidth,
              height: 400,
              padding: EdgeInsets.only(left: 100, right: 100),
              color: Colors.black,
              child: FittedBox(
                child: Image.network(
                  Global.USERDATA_URL + newsJSON['image_path'],
                  fit: BoxFit.fitWidth,
                ),
                fit: BoxFit.fill,
              )),
          SizedBox(height: 15),
          Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(newsJSON['title'],
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(newsJSON['content'], style: TextStyle(color: Colors.black, fontSize: 16))),
          SizedBox(height: 50),
        ])),
      ),
    );
  }
}
