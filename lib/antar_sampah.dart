import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(AntarSampah(null, null, null));

class AntarSampah extends StatefulWidget {
  final context, string, bank;
  const AntarSampah(this.context, this.string, this.bank);

  @override
  AntarSampahState createState() => AntarSampahState();
}

class AntarSampahState extends State<AntarSampah> {
  var string;
  var width;
  var height;
  var transparentBorder;
  final queryController = TextEditingController(text: "");
  bool checked = true;
  var categories = [];
  var selectedCategories = [];
  var lastSelectedBankID = 0;
  bool isPressing = false;
  var selectedBank;
  TimeOfDay selectedStartTime = new TimeOfDay(hour: 06, minute: 00);
  TimeOfDay selectedEndTime = new TimeOfDay(hour: 08, minute: 00);

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      selectedBank = widget.bank;
    });
    setupCategories();
  }

  void setupCategories() async {
    final _categories = jsonDecode(await getCategories());
    print("ALL CATEGORIES:");
    print(_categories);
    for (var i = 0; i < _categories.length; i++) {
      _categories[i]['weight'] = 1.0;
    }
    setState(() {
      categories = _categories;
    });
  }

  Future<String> getBanks() async {
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_banks"));
    return response.body;
  }

  Future<String> getCategories() async {
    final response = await http.post(Uri.parse(Global.API_URL + "/user/get_default_categories"),
        body: <String, String>{'bank_id': selectedBank['id']});
    return response.body;
  }

  void chooseBankSampah() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(height: 12),
              Text(widget.string.text80, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Container(
                  width: width - 12 - 12,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    SizedBox(width: 12),
                    Icon(Ionicons.search, color: Color(0xFFA8A8A8)),
                    SizedBox(width: 12),
                    Container(
                        width: width - 12 - 12 - 12 - 30 - 12,
                        height: 50,
                        child: TextField(
                            cursorColor: Color(Global.mainColor),
                            controller: queryController,
                            decoration: InputDecoration(
                                hintText: widget.string.text81,
                                hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                                border: new UnderlineInputBorder(borderSide: transparentBorder),
                                enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder))))
                  ])),
              SizedBox(width: 20),
              FutureBuilder<String>(
                  future: getBanks(),
                  builder: (context, snapshot) {
                    var banks = jsonDecode(snapshot.data!);
                    return Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: banks.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: width - 12 - 12,
                                  height: 45,
                                  margin: EdgeInsets.only(top: 6, bottom: 6),
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                  child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        Navigator.pop(context);
                                        print("BANK ID: " + banks[index]['id'].toString());
                                        print("LAST SELECTED BANK ID: " + lastSelectedBankID.toString());
                                        if (lastSelectedBankID != int.parse(banks[index]['id'])) {
                                          setState(() {
                                            selectedCategories = [];
                                            selectedBank = banks[index];
                                          });
                                          await Global.showProgressDialog(context, widget.string.loading);
                                          setupCategories();
                                          Global.dismissProgressDialog(context);
                                        }
                                        setState(() {
                                          lastSelectedBankID = int.parse(banks[index]['id']);
                                          selectedBank = banks[index];
                                        });
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 12, right: 12),
                                          child: Stack(children: [
                                            Positioned.fill(
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(banks[index]['title']))),
                                            Positioned.fill(
                                                child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Icon(Ionicons.chevron_forward)))
                                          ]))));
                            }));
                  })
            ])
          ]);
        });
  }

  void chooseCategory(bool resetCheckedList) {
    if (resetCheckedList) {
      for (var i = 0; i < categories.length; i++) {
        categories[i]['checked'] = false;
      }
    }
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: false,
        context: context,
        builder: (BuildContext context) {
          return Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 12),
                Text(widget.string.text79, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 70),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return StatefulBuilder(builder: (BuildContext context, setState) {
                            return Container(
                                width: width - 12 - 12,
                                height: 45,
                                margin: EdgeInsets.only(top: 6, bottom: 6),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    child: Stack(children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(categories[index]['name_id'],
                                              style: TextStyle(color: Colors.black))),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Checkbox(
                                              value: categories[index]['checked'] == null
                                                  ? false
                                                  : (categories[index]['checked']),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  categories[index]['checked'] = newValue!;
                                                });
                                              }))
                                    ])));
                          });
                        }))
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: width - 12 - 12,
                    height: 45,
                    margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    decoration: BoxDecoration(color: Color(0xFF27AE60), borderRadius: BorderRadius.circular(12)),
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          var _selectedCategories = [];
                          for (var i = 0; i < categories.length; i++) {
                            if (categories[i]['checked'] != null && categories[i]['checked'] == true) {
                              _selectedCategories.add(categories[i]);
                              if (resetCheckedList) {
                                _selectedCategories[i]['weight'] = 1;
                              }
                            }
                          }
                          setState(() {
                            selectedCategories = _selectedCategories;
                          });
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Text(widget.string.save,
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))))))
          ]);
        });
    /*showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: false,
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Stack(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SizedBox(height: 12),
                  Text(widget.string.text79, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  FutureBuilder<String>(
                      future: getCategories(),
                      builder: (context, snapshot) {
                        var categories = jsonDecode(snapshot.data!);
                        var categoriesChecked = List<bool>.filled(categories.length, true);
                        return StatefulBuilder(builder: (BuildContext context, setState) {
                          return Padding(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: GestureDetector(
                                  child: ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: categories.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: width - 12 - 12,
                                            height: 45,
                                            margin: EdgeInsets.only(top: 6, bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                            child: Padding(
                                                padding: EdgeInsets.only(left: 12, right: 12),
                                                child: Stack(children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(categories[index]['name_id'])),
                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Checkbox(
                                                          value: categories[index]['checked'] == null
                                                              ? false
                                                              : (categories[index]['checked']),
                                                          onChanged: (newValue) {
                                                            setState(() {
                                                              categories[index]['checked'] = newValue!;
                                                            });
                                                          }))
                                                ])));
                                      })));
                        });
                      })
                ]),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: width - 12 - 12,
                        height: 45,
                        margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                        decoration: BoxDecoration(color: Color(0xFF27AE60), borderRadius: BorderRadius.circular(12)),
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {},
                            child: Center(
                                child: Text(widget.string.save,
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))))))
              ]);
            },
          );
        });*/
  }

  Widget getCategoryList() {
    if (selectedCategories.length > 0) {
      return ListView.builder(
          primary: false,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selectedCategories.length,
          itemBuilder: (context, index) {
            return Container(
                width: width - 12 - 12,
                height: 70,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selectedCategories[index]['name_id'],
                                style: TextStyle(color: Colors.black, fontSize: 14)),
                            Text(
                                "Rp" +
                                    new NumberFormat("#,###", "en_US")
                                        .format(double.parse(selectedCategories[index]['price'])) +
                                    "/kg",
                                style: TextStyle(color: Color(Global.mainColor), fontSize: 14))
                          ])),
                  Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Listener(
                            child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: selectedCategories[index]['is_min_pressed'] == true
                                        ? Color(0xFFAAAAAA)
                                        : Color(0xFFE9E9E9)),
                                child: Icon(Ionicons.remove)),
                            onPointerDown: (event) => setState(() {
                                  selectedCategories[index]['is_min_pressed'] = true;
                                }),
                            onPointerUp: (event) {
                              setState(() {
                                selectedCategories[index]['is_min_pressed'] = false;
                                if (selectedCategories[index]['weight'] != null &&
                                    selectedCategories[index]['weight'] > 0) {
                                  selectedCategories[index]['weight'] -= 0.5;
                                } else {
                                  Global.confirm(context, widget.string.confirmation, widget.string.text82, () {
                                    setState(() {
                                      selectedCategories.removeAt(index);
                                    });
                                  });
                                }
                              });
                            }),
                        SizedBox(width: 8),
                        Text(selectedCategories[index]['weight'].toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") +
                            " kg"),
                        SizedBox(width: 8),
                        Listener(
                            child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: selectedCategories[index]['is_add_pressed'] == true
                                        ? Color(0xFFAAAAAA)
                                        : Color(0xFFE9E9E9)),
                                child: Icon(Ionicons.add)),
                            onPointerDown: (event) => setState(() {
                                  selectedCategories[index]['is_add_pressed'] = true;
                                }),
                            onPointerUp: (event) {
                              setState(() {
                                selectedCategories[index]['is_add_pressed'] = false;
                                selectedCategories[index]['weight'] += 0.5;
                              });
                            })
                      ]))
                ]));
          });
    } else {
      return Container(
          width: width - 12 - 12,
          height: 50,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                chooseCategory(true);
              },
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(width: 12),
                        Text(widget.string.text79, style: TextStyle(color: Colors.black, fontSize: 15))
                      ])),
                ),
                Align(alignment: Alignment.centerRight, child: Icon(Ionicons.chevron_forward))
              ])));
    }
  }

  double getTotalIncome() {
    double price = 0;
    for (var category in selectedCategories) {
      price += (category['weight'] * double.parse(category['price']));
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    string = AppLocalizations.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    transparentBorder = new BorderSide(color: Colors.transparent);
    return Scaffold(
        appBar: AppBar(
            title: Text(string!.text76, style: TextStyle(color: Colors.white)),
            backgroundColor: Color(Global.mainColor),
            iconTheme: IconThemeData(color: Colors.white)),
        backgroundColor: Color(0xFFF9F9F9),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.string.text77, style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(height: 8),
                  Container(
                      width: width - 12 - 12,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            chooseBankSampah();
                          },
                          child: Stack(children: [
                            Positioned.fill(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    SizedBox(width: 12),
                                    Image.asset("assets/images/map_marker.png", width: 25, height: 25),
                                    SizedBox(width: 12),
                                    Text(selectedBank != null ? selectedBank['title'] : '',
                                        style: TextStyle(color: Colors.black, fontSize: 15))
                                  ])),
                            ),
                            Align(alignment: Alignment.centerRight, child: Icon(Ionicons.chevron_forward))
                          ]))),
                  SizedBox(height: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.string.text78, style: TextStyle(color: Colors.black, fontSize: 16)),
                        Container(
                            height: 30,
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  chooseCategory(false);
                                },
                                child: Center(
                                    child: Text(widget.string.text84,
                                        style: TextStyle(color: Color(Global.mainColor), fontSize: 15)))))
                      ]),
                  SizedBox(height: 8),
                  getCategoryList(),
                  SizedBox(height: 20),
                  (() {
                    if (selectedCategories.length > 0) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.string.text83,
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                            width: width - 12 - 12,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(children: [
                                  for (var category in selectedCategories)
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(
                                          category['name_id'] +
                                              " x" +
                                              category['weight'].toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                                          style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 14)),
                                      Text(
                                          "Rp" +
                                              new NumberFormat("#,###", "en_US")
                                                  .format(category['weight'] * double.parse(category['price']))
                                                  .toString(),
                                          style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 14))
                                    ]),
                                  SizedBox(height: 8),
                                  Container(width: width - 12 - 12 - 12 - 12, height: 1, color: Color(0xFFA8A8A8)),
                                  SizedBox(height: 8),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(widget.string.text85, style: TextStyle(color: Colors.black, fontSize: 14)),
                                    Text("Rp" + new NumberFormat("#,###", "en_US").format(getTotalIncome()).toString(),
                                        style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 14))
                                  ])
                                ]))),
                        SizedBox(height: 20),
                        Text(widget.string.text86,
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                            width: width - 12 - 12,
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        var times = [
                                          {'startHour': 6, 'endHour': 8},
                                          {'startHour': 8, 'endHour': 10},
                                          {'startHour': 10, 'endHour': 12},
                                          {'startHour': 12, 'endHour': 14},
                                          {'startHour': 14, 'endHour': 16},
                                          {'startHour': 16, 'endHour': 18},
                                          {'startHour': 18, 'endHour': 20},
                                          {'startHour': 20, 'endHour': 22},
                                          {'startHour': 22, 'endHour': 24}
                                        ];
                                        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          SizedBox(height: 20),
                                          Text(widget.string.text89,
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Expanded(
                                              child: ListView.builder(
                                                  itemCount: times.length,
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                        width: width - 12 - 12,
                                                        height: 45,
                                                        margin: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(12)),
                                                        child: GestureDetector(
                                                            behavior: HitTestBehavior.translucent,
                                                            onTap: () {
                                                              setState(() {
                                                                selectedStartTime = TimeOfDay(
                                                                    hour: times[index]['startHour']!, minute: 00);
                                                                selectedEndTime = TimeOfDay(
                                                                    hour: times[index]['endHour']!, minute: 00);
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Icon(Ionicons.time, color: Color(Global.mainColor)),
                                                                  SizedBox(width: 12),
                                                                  Text(
                                                                      Global.getPaddedTime(times[index]['startHour']) +
                                                                          ".00 - " +
                                                                          Global.getPaddedTime(
                                                                              times[index]['endHour']) +
                                                                          ".00",
                                                                      style: TextStyle(
                                                                          color: Color(0xFFA8A8A8), fontSize: 15))
                                                                ])));
                                                  }))
                                        ]);
                                      });
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                            Icon(Ionicons.time_outline, color: Color(Global.mainColor)),
                                            SizedBox(width: 12),
                                            Text(
                                                Jiffy(Global.getDateTime(selectedStartTime)).format('HH.mm') +
                                                    " - " +
                                                    Jiffy(Global.getDateTime(selectedEndTime)).format('HH.mm'),
                                                style: TextStyle(color: Colors.black))
                                          ]),
                                          Icon(Ionicons.chevron_forward_outline)
                                        ])))),
                        SizedBox(height: 20),
                        Container(
                            width: width - 12 - 12,
                            height: 45,
                            decoration:
                                BoxDecoration(color: Color(Global.mainColor), borderRadius: BorderRadius.circular(8)),
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                            padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(widget.string.text90,
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(height: 20),
                                              Text(widget.string.text91,
                                                  style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 14)),
                                              SizedBox(height: 24),
                                              Container(
                                                  width: width - 16 - 16,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      color: Color(Global.mainColor),
                                                      borderRadius: BorderRadius.circular(8)),
                                                  child: GestureDetector(
                                                      behavior: HitTestBehavior.translucent,
                                                      onTap: () async {
                                                        await Global.showProgressDialog(context, widget.string.text63);
                                                        for (var i = 0; i < selectedCategories.length; i++) {
                                                          setState(() {
                                                            selectedCategories[i]['weight_controller'] = null;
                                                            selectedCategories[i]['item_count_controller'] = null;
                                                          });
                                                        }
                                                        print("SET DATE:");
                                                        print(DateFormat('yyyy-MM-dd HH:mm:ss')
                                                            .format(Global.getDateTime(selectedStartTime)));
                                                        var selectedItems = [];
                                                        for (var i = 0; i < selectedCategories.length; i++) {
                                                          selectedItems.add({
                                                            'item_id': selectedCategories[i]['id'],
                                                            'weight': selectedCategories[i]['weight'],
                                                            'item': selectedCategories[i],
                                                            'count': 0
                                                          });
                                                        }
                                                        final response = await http.post(
                                                            Uri.parse(Global.API_URL + "/user/add_transaction"),
                                                            body: <String, String>{
                                                              'user_id': Global.USER_ID.toString(),
                                                              'bank_id': widget.bank['id'].toString(),
                                                              'items': jsonEncode(selectedItems),
                                                              'date': DateFormat('yyyy-MM-dd HH:mm:ss')
                                                                  .format(Global.getDateTime(selectedStartTime))
                                                            });
                                                        print("add_transaction response:");
                                                        print(response.body);
                                                        await Global.dismissProgressDialog(context);
                                                        Navigator.pop(context);
                                                        Global.replaceScreen(context, Activity(context, widget.string, null, null, null));
                                                      },
                                                      child: Align(
                                                          alignment: Alignment.center,
                                                          child: Text(widget.string.text92,
                                                              style: TextStyle(color: Colors.white, fontSize: 17)))))
                                            ]));
                                      });
                                },
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(widget.string.text52, style: TextStyle(color: Colors.white, fontSize: 17)))))
                      ]);
                    } else {
                      return Container();
                    }
                  }()),
                ]))));
  }
}
