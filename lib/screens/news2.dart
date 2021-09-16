import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';
import 'news_tab.dart';

void main() => runApp(News());

class News extends StatefulWidget {
  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<News> {
  @override
  void initState() {
    super.initState();
    String languageCode = Platform.localeName.split('_')[0];
    //print("LANGUAGE CODE:");
    //print(languageCode);
  }

  Future<String> getNewsCategories() async {
    //print("Getting data from " + Global.API_URL + "/user/get_news_categories");
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_news_categories"));
    //print("Data received from server:");
    //print(response.body);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue);
  }

  /*@override
  Widget build(BuildContext context) {
  	return FutureBuilder<String>(
    future: getNewsCategories(),
    builder: (context, snapshot) {
    	var categories = jsonDecode(snapshot.data!);
    	List<Widget> tabs = [];
    	List<Widget> tabViews = [];
    	for (var i=0; i<categories.length; i++) {
    		tabs.add(Tab(text: categories[i]['category_en']));
    		tabViews.add(NewsTab(int.parse("1")));
    	}
    	//print("ALL TABS:");
    	//print(tabs);
    	return Container(
	        child: DefaultTabController(
	  			length: tabs.length,
	  			child: Scaffold(
	    			appBar: PreferredSize(preferredSize: Size(MediaQuery.of(context).size.width, 52),
	    				child: Container(width: MediaQuery.of(context).size.width, height: 52, color: Color(0xFFFFFFFF),
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
	            		)
	            	),
	            	body: TabBarView(
            			children: tabViews,
          			),
	  			),
			)
		);
    });
  }*/
}
