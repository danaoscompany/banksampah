import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:jiffy/src/enums/units.dart';

void main() => runApp(NewsTab(0));

class NewsTab extends StatefulWidget {
  final int categoryID;
  const NewsTab(this.categoryID);

  @override
  NewsTabState createState() => NewsTabState();
}

class NewsTabState extends State<NewsTab> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> getNewsByCategoryID() async {
    final response =
        await http.post(Uri.parse(Global.API_URL + "/user/get_news_by_category_id"), body: <String, String>{
      'category_id': "1",
    });
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getNewsByCategoryID(),
        builder: (context, snapshot) {
          //print("NEWS CONTENTS:");
          var newsJSON = jsonDecode(snapshot.data!);
          List<Widget> news = [];
          for (var i = 0; i < newsJSON.length; i++) {
            news.add(ListTile(
                title: Text(newsJSON[i]['title'], style: new TextStyle(fontWeight: FontWeight.bold), maxLines: 3),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(Global.USERDATA_URL + newsJSON[i]['image_path'],
                      width: 100.0, height: 100.0, fit: BoxFit.fitWidth),
                ),
                subtitle: Text(Jiffy(newsJSON[i]['date']).format('dd/MM/yyyy hh:mm'))));
          }
          return Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: news,
              ));
        });
  }
}
