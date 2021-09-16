import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';
import 'news_tab.dart';

void main() => runApp(News(null, null));

class News extends StatefulWidget {
  final context, string;
  News(this.context, this.string);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> getNewsCategories() async {
    //print("Getting data from " + Global.API_URL + "/user/get_news_categories");
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_news_categories"),
        headers: {"Accept": "application/json", "Content-Type": "application/json"});
    //print("Data received from server:");
    //print(response.body);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getNewsCategories(),
        builder: (context, snapshot) {
          var categories = jsonDecode(snapshot.data!);
          List<Widget> tabs = [];
          List<Widget> tabViews = [];
          for (var i = 0; i < categories.length; i++) {
            tabs.add(Tab(text: categories[i]['category_en']));
            tabViews.add(NewsTab(widget.context, widget.string, int.parse(categories[i]['id'])));
          }
          //print("ALL TABS:");
          //print(tabs);
          return Container(
              child: DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 52),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    color: Color(0xFFFFFFFF),
                    margin: const EdgeInsets.all(10.0),
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Color(0xFFFF0000),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(Global.mainColor),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: tabs,
                    ),
                  )),
              body: TabBarView(
                children: tabViews,
              ),
            ),
          ));
        });
  }
}
