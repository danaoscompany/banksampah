import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/activity.dart';
import 'package:banksampah/complete_request_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ionicons/ionicons.dart';

void main() => runApp(ChooseItem(null, null, null));

class ChooseItem extends StatefulWidget {
  final context, string, bank;
  const ChooseItem(this.context, this.string, this.bank);

  @override
  ChooseItemState createState() => ChooseItemState();
}

class ChooseItemState extends State<ChooseItem> {
  var categories = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final response = await getItemCategories();
    var _categories = json.decode(response);
    for (var i = 0; i < _categories.length; i++) {
      _categories[i]['item_count'] = 0;
    }
    setState(() {
      categories = _categories;
    });
  }

  Future<String> getItemCategories() async {
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_item_categories"));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var transparentBorder = new BorderSide(color: Colors.transparent);
    return Scaffold(
        appBar: AppBar(
            title: Text(string!.text53, style: TextStyle(color: Colors.white)),
            backgroundColor: Color(Global.mainColor),
            iconTheme: IconThemeData(color: Colors.white)),
        backgroundColor: Colors.white,
        body: Stack(children: [
          Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 50),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1, crossAxisSpacing: 20, mainAxisSpacing: 20, crossAxisCount: 2),
                  physics: ScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext ctx, index) {
                    if (categories.length == 0) {
                      return Container(width: 0, height: 0);
                    }
                    var itemCount = categories[index]['item_count'];
                    if (itemCount == null) {
                      itemCount = 0;
                    }
                    return Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                            onTap: () {},
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(Global.USERDATA_URL + categories[index]['image'].toString(),
                                      height: 103, fit: BoxFit.fill),
                                  SizedBox(height: 10),
                                  Text(categories[index]['name_id'].toString(),
                                      style: TextStyle(color: Colors.black, fontSize: 14)),
                                  SizedBox(height: 10),
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Color(Global.mainColor), borderRadius: BorderRadius.circular(4)),
                                        child: Center(child: Icon(Ionicons.remove, color: Colors.white, size: 15))),
                                    SizedBox(width: 5),
                                    Container(
                                        width: 30,
                                        height: 30,
                                        color: Color(0xFFEEEEEE),
                                        child: TextField(
                                            cursorColor: Color(Global.mainColor),
                                            decoration: InputDecoration(
                                                hintText: itemCount.toString(),
                                                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF444444)),
                                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center)),
                                    SizedBox(width: 5),
                                    Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Color(Global.mainColor), borderRadius: BorderRadius.circular(4)),
                                        child: GestureDetector(
                                            onTap: () {
                                              var _categories = categories;
                                              int itemCount = _categories[index]['item_count'];
                                              if (itemCount == null) {
                                                itemCount = 1;
                                              } else {
                                                itemCount = itemCount + 1;
                                              }
                                              _categories[index]['item_count'] = itemCount;
                                              setState(() {
                                                categories = _categories;
                                              });
                                            },
                                            child: Center(child: Icon(Ionicons.add, color: Colors.white, size: 15))))
                                  ])
                                ])));
                  })),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: width - 15 - 15,
                  height: 45,
                  decoration: BoxDecoration(color: Color(Global.mainColor), borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                      onTap: () {
                        var selectedItems = [];
                        for (var i = 0; i < categories.length; i++) {
                          var itemCount = categories[i]['item_count'];
                          if (itemCount == null) {
                            itemCount = 0;
                          }
                          if (itemCount > 0) {
                            selectedItems.add(categories[i]);
                          }
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompleteRequestDetails(widget.context, widget.string, widget.bank, selectedItems)));
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(widget.string.text25,
                              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))))))
        ]));
  }
}
