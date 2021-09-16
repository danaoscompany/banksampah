import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/activity.dart';
import 'package:banksampah/components/RegExInputFormatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';

void main() => runApp(CompleteRequestDetails(null, null, null, null));

class CompleteRequestDetails extends StatefulWidget {
  final context, string, bank, items;
  const CompleteRequestDetails(this.context, this.string, this.bank, this.items);

  @override
  CompleteRequestDetailsState createState() => CompleteRequestDetailsState();
}

class CompleteRequestDetailsState extends State<CompleteRequestDetails> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    String languageCode = Platform.localeName.split('_')[0];
    String countryCode = Platform.localeName.split('_')[1];
    //print("LANGUAGE CODE:");
    //print(languageCode);
    //print("COUNTRY CODE:");
    //print(countryCode);
    setState(() {
      for (var i = 0; i < widget.items.length; i++) {
        widget.items[i]['weight_controller'] = TextEditingController(text: "0");
        widget.items[i]['item_count_controller'] =
            TextEditingController(text: widget.items[i]['item_count'].toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var transparentBorder = new BorderSide(color: Colors.transparent);
    RegExInputFormatter _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
    return Scaffold(
        appBar: AppBar(
            title: Text(string!.text59, style: TextStyle(color: Colors.white)),
            backgroundColor: Color(Global.mainColor),
            iconTheme: IconThemeData(color: Colors.white)),
        backgroundColor: Color(0xFFEEEEEE),
        body: Stack(children: [
          SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, bottom: 69),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 16),
                        Text(widget.string.text60,
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        GestureDetector(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2018, 3, 5),
                                  maxTime: DateTime(2019, 6, 7),
                                  onChanged: (date) {}, onConfirm: (_date) async {
                                setState(() {
                                  selectedDate = _date;
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                            },
                            child: Container(
                                height: 45,
                                padding: EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(width: 1, color: Color(0x7F888888))),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [Text(Jiffy(selectedDate).format('d MMMM yyyy HH:mm:ss'))]))),
                        SizedBox(height: 12),
                        Text(widget.string.text61,
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: width - 15 - 15,
                                  margin: EdgeInsets.only(top: 4, bottom: 4),
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Row(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(Global.USERDATA_URL + widget.items[index]['image'],
                                            height: 100, width: 100, fit: BoxFit.fill)),
                                    SizedBox(width: 16),
                                    Container(
                                        width: 300,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text(widget.items[index]['name_id'], maxLines: 2),
                                          SizedBox(height: 8),
                                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Text(widget.string.weight, style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(width: 8),
                                            Container(
                                                width: 100,
                                                height: 40,
                                                color: Color(0xFFEEEEEE),
                                                child: TextField(
                                                    decoration: InputDecoration(
                                                        hintText: "",
                                                        hintStyle: TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                                        border: new UnderlineInputBorder(borderSide: transparentBorder),
                                                        enabledBorder:
                                                            new UnderlineInputBorder(borderSide: transparentBorder),
                                                        focusedBorder:
                                                            new UnderlineInputBorder(borderSide: transparentBorder)),
                                                    controller: widget.items[index]['weight_controller'],
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    inputFormatters: [_amountValidator],
                                                    keyboardType: TextInputType.numberWithOptions(
                                                      decimal: true,
                                                      signed: false,
                                                    ))),
                                            SizedBox(width: 8),
                                            Text(widget.string.kg, style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(width: 16),
                                            Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Color(Global.mainColor),
                                                    borderRadius: BorderRadius.circular(4)),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      int itemCount = widget.items[index]['item_count'];
                                                      if (itemCount == null) {
                                                        itemCount = 0;
                                                      }
                                                      if (itemCount > 0) {
                                                        itemCount--;
                                                      }
                                                      setState(() {
                                                        widget.items[index]['item_count'] = itemCount;
                                                      });
                                                      var controller = widget.items[index]['item_count_controller'];
                                                      if (controller != null) {
                                                        controller.text = itemCount.toString();
                                                      }
                                                    },
                                                    child: Center(
                                                        child: Icon(Ionicons.remove, color: Colors.white, size: 15)))),
                                            SizedBox(width: 5),
                                            Container(
                                                width: 30,
                                                height: 30,
                                                color: Color(0xFFEEEEEE),
                                                child: TextField(
                                                    cursorColor: Color(Global.mainColor),
                                                    decoration: InputDecoration(
                                                        hintText: "",
                                                        hintStyle: TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                                        border: new UnderlineInputBorder(borderSide: transparentBorder),
                                                        enabledBorder:
                                                            new UnderlineInputBorder(borderSide: transparentBorder),
                                                        focusedBorder:
                                                            new UnderlineInputBorder(borderSide: transparentBorder)),
                                                    controller: widget.items[index]['item_count_controller'],
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    inputFormatters: [_amountValidator],
                                                    keyboardType: TextInputType.numberWithOptions(
                                                      decimal: true,
                                                      signed: false,
                                                    ))),
                                            SizedBox(width: 5),
                                            Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Color(Global.mainColor),
                                                    borderRadius: BorderRadius.circular(4)),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      int itemCount = widget.items[index]['item_count'];
                                                      if (itemCount == null) {
                                                        itemCount = 0;
                                                      }
                                                      itemCount++;
                                                      setState(() {
                                                        widget.items[index]['item_count'] = itemCount;
                                                      });
                                                      var controller = widget.items[index]['item_count_controller'];
                                                      if (controller != null) {
                                                        controller.text = itemCount.toString();
                                                      }
                                                    },
                                                    child: Center(
                                                        child: Icon(Ionicons.add, color: Colors.white, size: 15))))
                                          ])
                                        ]))
                                  ]));
                            })
                      ]))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: width - 15 - 15,
                  height: 45,
                  decoration: BoxDecoration(color: Color(Global.mainColor), borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                      onTap: () async {
                        bool allWeightsEntered = true;
                        bool allItemCountsEntered = true;
                        var selectedItems = [];
                        Global.showProgressDialog(context, widget.string.loading);
                        for (var i = 0; i < widget.items.length; i++) {
                          final weightController = widget.items[i]['weight_controller'];
                          final itemCountController = widget.items[i]['item_count_controller'];
                          var weight;
                          var itemCount;
                          if (weightController != null) {
                            weight = weightController.text;
                            if (weight == null || weight.trim() == "" || double.parse(weight) == 0.0) {
                              allWeightsEntered = false;
                              Global.show(widget.string.text62);
                              break;
                            } else {
                              weight = double.parse(weight);
                            }
                          }
                          if (itemCountController != null) {
                            itemCount = itemCountController.text;
                            if (itemCount == null || itemCount.trim() == "" || int.parse(itemCount) == 0) {
                              allItemCountsEntered = false;
                              Global.show(widget.string.text64);
                              break;
                            } else {
                              itemCount = int.parse(itemCount);
                            }
                          }
                          final response = await http.post(Uri.parse(Global.API_URL + "/user/get_item_by_id"),
                              body: <String, String>{'id': widget.items[i]['id'].toString()});
                          final itemJSON = jsonDecode(response.body);
                          selectedItems.add({
                            'item_id': widget.items[i]['id'],
                            'item': itemJSON,
                            'weight': weight,
                            'count': itemCount
                          });
                        }
                        Global.dismissProgressDialog(context);
                        if (allWeightsEntered && allItemCountsEntered) {
                          //print("SELECTED ITEMS DATA:");
                          //print(selectedItems);
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Activity(selectedDate, widget.bank, selectedItems)));*/
                        }
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(widget.string.text25,
                              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))))))
        ]));
  }
}
