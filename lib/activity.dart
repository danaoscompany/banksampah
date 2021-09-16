import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:banksampah/components/screen_arguments.dart';
import 'package:banksampah/main.dart';
import 'package:banksampah/home.dart';
import 'package:banksampah/login.dart';

void main() => runApp(Activity(null, null, null, null, null));

class Activity extends StatefulWidget {
  final context, string, date, bank, details;
  Activity(this.context, this.string, this.date, this.bank, this.details);

  @override
  ActivityState createState() => ActivityState();
}

class ActivityState extends State<Activity> with TickerProviderStateMixin {
  var currentBottomMenuIndex = 1;
  var onGoingActivities = [];
  var cancelledActivities = [];
  var activities = [];
  double adminFee = 0.0;
  double totalCash = 0.0;
  var string, width, height;
  final reasonController = TextEditingController(text: "");
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    tabController.addListener(() {
      var index = tabController.index;
      if (index == 0) {
        setState(() {
          activities = onGoingActivities;
        });
      } else if (index == 2) {
        setState(() {
          activities = cancelledActivities;
        });
      }
      print("ACTIVITIES:");
      print(activities);
    });
    initData();
  }

  void initData() async {
    var response = await http.get(Uri.parse(Global.API_URL + "/user/get_settings"));
    final settings = jsonDecode(response.body);
    setState(() {
      adminFee = double.parse(settings['admin_fee']);
    });
    getTransactions('waiting_request_received');
    getTransactions('cancelled');
    setState(() {
      activities = onGoingActivities;
    });
    if (widget.details != null) {
      confirmPayment();
    }
  }

  void getTransactions(String status) async {
    var response = await http.post(Uri.parse(Global.API_URL + "/user/get_transactions"),
        body: <String, String>{'user_id': Global.USER_ID.toString(), 'status': status});
    if (status == 'waiting_request_received') {
      setState(() {
        onGoingActivities = jsonDecode(response.body);
      });
    } else if (status == 'cancelled') {
      setState(() {
        cancelledActivities = jsonDecode(response.body);
      });
    }
    print("ONGOING TRANSACTIONS:");
    print(onGoingActivities);
    print("CANCELLED TRANSACTIONS:");
    print(cancelledActivities);
    for (var i = 0; i < onGoingActivities.length; i++) {
      double totalCash = 0.0;
      if (onGoingActivities[i]['items'] != null) {
        for (var j = 0; j < onGoingActivities[i]['items'].length; j++) {
          totalCash += (onGoingActivities[i]['items'][j]['count'] *
              double.parse(onGoingActivities[i]['items'][j]['item']['price']));
        }
      }
      totalCash += adminFee;
      setState(() {
        onGoingActivities[i]['total_cash'] = totalCash;
      });
    }
    for (var i = 0; i < cancelledActivities.length; i++) {
      double totalCash = 0.0;
      if (cancelledActivities[i]['items'] != null) {
        for (var j = 0; j < cancelledActivities[i]['items'].length; j++) {
          totalCash += (cancelledActivities[i]['items'][j]['count'] *
              double.parse(cancelledActivities[i]['items'][j]['item']['price']));
        }
      }
      totalCash += adminFee;
      setState(() {
        cancelledActivities[i]['total_cash'] = totalCash;
      });
    }
  }

  void confirmPayment() {
    showBottomDialog(context, 0, "confirm_payment");
  }

  Widget getBottomDialogButton(BuildContext context, int index, String type) {
    var transparentBorder = new BorderSide(color: Colors.transparent);
    String status = activities[index]['status'];
    print("CURRENT STATUS:");
    print(status);
    if (type == "show_details") {
      return Row(children: [
        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: Color(0xFFDB4235), borderRadius: BorderRadius.circular(12)),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              SizedBox(height: 24),
                              Text(widget.string.text71,
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 12),
                              TextField(
                                cursorColor: Color(Global.mainColor),
                                controller: reasonController,
                                decoration: InputDecoration(
                                    hintText: widget.string.text72,
                                    hintStyle: TextStyle(fontSize: 15, color: Color(0xFFA8A8A8)),
                                    border: new UnderlineInputBorder(borderSide: transparentBorder),
                                    enabledBorder: new UnderlineInputBorder(borderSide: transparentBorder),
                                    focusedBorder: new UnderlineInputBorder(borderSide: transparentBorder)),
                              ),
                              Container(width: width - 16 - 16, height: 1, color: Color(0x88A8A8A8)),
                              SizedBox(height: 24),
                              Container(
                                  width: width - 16 - 16,
                                  height: 50,
                                  decoration:
                                      BoxDecoration(color: Color(0xFFDB4235), borderRadius: BorderRadius.circular(12)),
                                  child: GestureDetector(
                                      onTap: () async {
                                        final reason = reasonController.text.trim();
                                        if (reason == "") {
                                          Global.show(widget.string.text74);
                                          return;
                                        }
                                        Global.showProgressDialog(context, widget.string.text75);
                                        final response = await http.post(
                                            Uri.parse(Global.API_URL + "/user/cancel_transaction_request"),
                                            body: <String, String>{'id': activities[index]['id']});
                                        Global.dismissProgressDialog(context);
                                        getTransactions('waiting_request_received');
                                      },
                                      child: Center(
                                          child: Text(widget.string.text73,
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)))))
                            ]));
                      });
                },
                child: Center(child: Image.asset("assets/images/slash.png", width: 22, height: 22)))),
        SizedBox(width: 12),
        Container(
            width: width - 15 - 15 - 50 - 16,
            height: 50,
            decoration: BoxDecoration(color: Color(0xFFF2F3F5), borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(
                    status == 'waiting_request_received'
                        ? widget.string.text56
                        : status == 'waiting_bs_confirmation'
                            ? widget.string.text57
                            : status == 'waiting_transaction_confirmation'
                                ? widget.string.text68
                                : '',
                    style: TextStyle(color: Color(0xFF9FA2B4), fontSize: 17, fontWeight: FontWeight.bold))))
      ]);
    } else if (type == "confirm_payment") {
      return Row(children: [
        Container(
            width: width - 15 - 20,
            height: 50,
            decoration: BoxDecoration(color: Color(0xFF27AE60), borderRadius: BorderRadius.circular(12)),
            child: GestureDetector(
                onTap: () async {
                  Global.showProgressDialog(context, widget.string.text63);
                  for (var i = 0; i < widget.details.length; i++) {
                    setState(() {
                      widget.details[i]['weight_controller'] = null;
                      widget.details[i]['item_count_controller'] = null;
                    });
                  }
                  print("add_transaction details:");
                  print(Global.USER_ID.toString());
                  print(widget.bank['id'].toString());
                  print(jsonEncode(widget.details));
                  print(Jiffy(widget.date).format('yyyy-MM-dd HH:mm:ss'));
                  print("===========================");
                  final response =
                      await http.post(Uri.parse(Global.API_URL + "/user/add_transaction"), body: <String, String>{
                    'user_id': Global.USER_ID.toString(),
                    'bank_id': widget.bank['id'].toString(),
                    'items': jsonEncode(widget.details),
                    'date': Jiffy(widget.date).format('yyyy-MM-dd HH:mm:ss')
                  });
                  print("add_transaction response:");
                  print(response.body);
                  Global.dismissProgressDialog(context);
                  getTransactions('waiting_request_received');
                },
                child: Center(
                    child: Text(widget.string.text70,
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)))))
      ]);
    }
    return Container(width: 0, height: 0);
  }

  void showBottomDialog(BuildContext context, int index, String type) {
    Future<void> future = showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.string.text65, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 12)),
                SizedBox(height: 4),
                Stack(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(type == "confirm_payment" ? widget.bank['title'] : activities[index]['bank']['title'],
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(Jiffy().format('d MMM yyyy, HH:mm a'),
                          style: TextStyle(color: Color(0xFF747474), fontSize: 13)))
                ]),
                SizedBox(height: 16),
                Container(width: width - 16 - 16, height: 1, color: Color(0xFFE9E9E9)),
                SizedBox(height: 16),
                Text(widget.string.text66, style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 12)),
                SizedBox(height: 12),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: (type == "confirm_payment") ? widget.details.length : activities[index]['items'].length,
                    itemBuilder: (context, index2) {
                      return Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Stack(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    (type == "confirm_payment")
                                        ? widget.details[index2]['item']['name_id']
                                        : activities[index]['items'][index2]['item']['name_id'],
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black))),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "Rp" +
                                        new NumberFormat("#,###", "en_US").format(type == "confirm_payment"
                                            ? (widget.details[index]['count'] *
                                                double.parse(widget.details[index]['item']['price']))
                                            : (activities[index]['items'][index2]['count'] *
                                                double.parse(activities[index]['items'][index2]['item']['price']))) +
                                        ",-",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)))
                          ]));
                    }),
                SizedBox(height: 4),
                Stack(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.string.text69,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text("Rp" + new NumberFormat("#,###", "en_US").format(adminFee) + ",-",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)))
                ]),
                SizedBox(height: 16),
                Container(width: width - 16 - 16, height: 1, color: Color(0xFFE9E9E9)),
                SizedBox(height: 16),
                Stack(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.string.text67,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          "Rp" +
                              (new NumberFormat("#,###", "en_US")
                                      .format(type == "confirm_payment" ? 0 : activities[index]['total_cash']) +
                                  ",-"),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)))
                ]),
                SizedBox(height: 32),
                getBottomDialogButton(context, index, type)
              ]));
        });
    future.then((void value) => {
          // dismissBottomDialog(context, value)
        });
  }

  void dismissBottomDialog(BuildContext context, void value) {
    Navigator.of(context).pop();
  }

  void onBottomNavigationSelected(int index) async {
    setState(() {
      currentBottomMenuIndex = index;
    });
    String email = await Global.read("email", "");
    String password = await Global.read("password", "");
    if (email != null && email.trim() != "" && password != null && password.trim() != "") {
      if (currentBottomMenuIndex == 0) {
        Navigator.pushReplacement(widget.context, MaterialPageRoute(builder: (context) => Home(widget.context, widget.string)));
      } else if (currentBottomMenuIndex == 1) {
        Navigator.pushReplacement(
            widget.context, MaterialPageRoute(builder: (context) => Activity(widget.context, widget.string, null, null, null)));
      } else if (currentBottomMenuIndex == 2) {
      } else if (currentBottomMenuIndex == 3) {}
    } else {
      Navigator.push(widget.context, MaterialPageRoute(builder: (context) => Login(widget.context, widget.string)));
    }
  }

  Future<String> getActivities(String status) async {
    final response = await http.post(Uri.parse(Global.API_URL + "/user/get_transactions"),
        body: <String, String>{'user_id': Global.USER_ID.toString(), 'status': status});
    return response.body;
  }

  Future<double> getAdminFee() async {
    final response = await http.get(Uri.parse(Global.API_URL + "/user/get_settings"));
    print("get_settings response:");
    print(response.body);
    final settings = jsonDecode(response.body);
    double adminFee = double.parse(settings['admin_fee']);
    return adminFee;
  }

  Future<void> onRefresh() async {
    getTransactions('waiting_request_received');
  }

  @override
  Widget build(BuildContext context) {
    string = AppLocalizations.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    List<Widget> tabs = [];
    List<Widget> tabViews = [];
    tabs.add(Container(height: 45, child: Tab(text: string!.text54)));
    if (onGoingActivities.length > 0) {
      tabViews.add(Container(
          child: RefreshIndicator(
              key: new GlobalKey<RefreshIndicatorState>(),
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: onGoingActivities.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                          onTap: () {
                            showBottomDialog(context, index, "show_details");
                          },
                          child: ListTile(
                              title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(onGoingActivities[index]['bank']['title'],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                RichText(
                                    text: TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: widget.string.status + ": ", style: TextStyle(color: Color(Global.mainColor))),
                                    new TextSpan(
                                        text: onGoingActivities[index]['status'] == 'waiting_request_received'
                                            ? widget.string.text56
                                            : '',
                                        style: TextStyle(color: Color(0xFFDB9E35))),
                                  ],
                                ))
                              ]),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(Jiffy().format('d MMM yyyy HH:mm'),
                                      style: TextStyle(color: Color(0xFF747474), fontSize: 12))))));
                },
              ))));
    } else {
      tabViews.add(Container(color: Colors.white));
    }
    tabs.add(Container(height: 45, child: Tab(text: widget.string.done)));
    tabViews.add(Container(color: Colors.white));
    tabs.add(Container(height: 45, child: Tab(text: widget.string.cancelled)));
    if (cancelledActivities.length > 0) {
      tabViews.add(Container(
          width: 100,
          height: 100,
          child: RefreshIndicator(
              key: new GlobalKey<RefreshIndicatorState>(),
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: cancelledActivities.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                          onTap: () {
                            showBottomDialog(context, index, "show_details");
                          },
                          child: ListTile(
                              title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(cancelledActivities[index]['bank']['title'],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                RichText(
                                    text: TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: widget.string.status + ": ", style: TextStyle(color: Color(Global.mainColor))),
                                    new TextSpan(
                                        text:
                                            cancelledActivities[index]['status'] == 'cancelled' ? widget.string.cancelled : '',
                                        style: TextStyle(color: Color(0xFFDB9E35))),
                                  ],
                                ))
                              ]),
                              subtitle: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(Jiffy().format('d MMM yyyy HH:mm'),
                                      style: TextStyle(color: Color(0xFF747474), fontSize: 12))))));
                },
              ))));
    } else {
      tabViews.add(Container(color: Colors.white));
    }
    tabs.add(Container(height: 45, child: Tab(text: widget.string.text55)));
    tabViews.add(Container(color: Colors.white));
    return Container(
        color: Colors.white,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 109),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 139,
                    color: Color(0xFFFFFFFF),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, top: 40),
                          child: Text(widget.string.activity,
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))),
                      SizedBox(height: 10),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: TabBar(
                              isScrollable: true,
                              indicatorColor: Color(0xFFFF0000),
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0x55E8F2D1),
                              ),
                              labelColor: Color(Global.mainColor),
                              unselectedLabelColor: Color(0xFFA8A8A8),
                              controller: tabController,
                              tabs: tabs)),
                      SizedBox(height: 5)
                    ]))),
            body: TabBarView(children: tabViews, controller: tabController),
            bottomNavigationBar:
                BottomNavigationBar(currentIndex: currentBottomMenuIndex, onTap: onBottomNavigationSelected, items: [
              BottomNavigationBarItem(
                  icon: new Image.asset(
                      currentBottomMenuIndex == 0 ? "assets/images/home_selected.png" : "assets/images/home.png",
                      width: 20,
                      height: 20),
                  title: new Text(
                    widget.string.home,
                    style: TextStyle(
                        color: currentBottomMenuIndex == 0 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                        fontWeight: currentBottomMenuIndex == 0 ? FontWeight.bold : FontWeight.normal),
                  )),
              BottomNavigationBarItem(
                  icon: new Image.asset(
                      currentBottomMenuIndex == 1
                          ? "assets/images/briefcase_selected.png"
                          : "assets/images/briefcase.png",
                      width: 20,
                      height: 20),
                  title: new Text(
                    widget.string.activity,
                    style: TextStyle(
                        color: currentBottomMenuIndex == 1 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                        fontWeight: currentBottomMenuIndex == 1 ? FontWeight.bold : FontWeight.normal),
                  )),
              BottomNavigationBarItem(
                  icon: new Image.asset(
                      currentBottomMenuIndex == 2 ? "assets/images/message_selected.png" : "assets/images/message.png",
                      width: 20,
                      height: 20),
                  title: new Text(
                    widget.string.message,
                    style: TextStyle(
                        color: currentBottomMenuIndex == 2 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                        fontWeight: currentBottomMenuIndex == 2 ? FontWeight.bold : FontWeight.normal),
                  )),
              BottomNavigationBarItem(
                  icon: new Image.asset(
                      currentBottomMenuIndex == 3 ? "assets/images/user_selected.png" : "assets/images/user.png",
                      width: 20,
                      height: 20),
                  title: new Text(
                    widget.string.profile,
                    style: TextStyle(
                        color: currentBottomMenuIndex == 3 ? Color(Global.mainColor) : Color(0xFFA8A8A8),
                        fontWeight: currentBottomMenuIndex == 3 ? FontWeight.bold : FontWeight.normal),
                  ))
            ])));
  }
}
