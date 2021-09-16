import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:banksampah/activity.dart';

class Global {
  static var PROTOCOL = "http";
  /*static var HOST = "192.168.43.254";
  static var API_URL = PROTOCOL + "://" + HOST + "/banksampah/ci_index.php";
  static var USERDATA_URL = PROTOCOL + "://" + HOST + "/banksampah/userdata/";*/
  static var HOST = "ebanksampah.com";
  static var API_URL = PROTOCOL+"://"+HOST+"/banksampah/ci_index.php";
  static var USERDATA_URL = PROTOCOL+"://"+HOST+"/banksampah/userdata/";
  static int USER_ID = 0;
  static String FCM_KEY = "";
  static var mainColor = 0xFF00BE5B;
  static var primaryColor = 0xFF00BE5B;
  static var currentProgressDialog = null;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  // To access current context, use Global.navigatorKey.currentContext!

  static Future<String> read(String name, String defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name) ?? defaultValue;
  }

  static void write(String name, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return await Geolocator.getCurrentPosition();
    } else {
      return await Geolocator.getCurrentPosition();
    }
  }

  static Future<List<dynamic>> getCurrentAddress() async {
    var position = await getCurrentPosition();
    double lat = 0, lng = 0;
    String address = "";
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
    }
    if (kIsWeb) {
      var secondsSinceEpoch = (DateTime.now().millisecondsSinceEpoch / 1000).toInt().toString();
      var key = utf8.encode('uIlfSFu8PKuE79ggOKGgA4h3USmPg98iUJOhuCCVB-OjjXvqP14q-gAb4-6MK3b6vwbN8b8XvzEtZlPIOtwqDA&');
      var bytes = utf8.encode(
          "POST&https%3A%2F%2Faccount.api.here.com%2Foauth2%2Ftoken&grant_type%3Dclient_credentials%26oauth_consumer_key%3D4nu0KabdQ3J1MSW2zflHbg%26oauth_nonce%3DXinyexYCoXbmzluT0MOSVCi8EhPjJh5x%26oauth_signature_method%3DHMAC-SHA256%26oauth_timestamp%3D" +
              secondsSinceEpoch +
              "%26oauth_version%3D1.0");
      var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
      var digest = hmacSha256.convert(bytes);
      var signature = Uri.encodeComponent(base64.encode(digest.bytes));
      final response = await http.post(Uri.parse("https://account.api.here.com/oauth2/token"), headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            'OAuth oauth_consumer_key="4nu0KabdQ3J1MSW2zflHbg", oauth_nonce="XinyexYCoXbmzluT0MOSVCi8EhPjJh5x", oauth_signature="' +
                signature +
                '", oauth_signature_method="HMAC-SHA256", oauth_timestamp="' +
                secondsSinceEpoch +
                '", oauth_version="1.0"'
      }, body: <String, String>{
        'grant_type': 'client_credentials'
      });
      var accessToken = json.decode(response.body)['access_token'];
      final geocodingResponse = await http.get(
          Uri.parse("https://revgeocode.search.hereapi.com/v1/revgeocode?at=" +
              lat.toString() +
              "%2C" +
              lng.toString() +
              "&lang=en-US"),
          headers: {"Authorization": "Bearer " + accessToken});
      var addresses = json.decode(geocodingResponse.body)['items'];
      if (addresses.length > 0) {
        address = addresses[0]['title'];
      }
    } else {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.length > 0) {
        address = placemarks[0].street.toString();
      }
    }
    return [lat, lng, address];
  }

  static Future<String> getAddress(double lat, double lng) async {
    String address = "";
    if (kIsWeb) {
      var secondsSinceEpoch = (DateTime.now().millisecondsSinceEpoch / 1000).toInt().toString();
      var key = utf8.encode('uIlfSFu8PKuE79ggOKGgA4h3USmPg98iUJOhuCCVB-OjjXvqP14q-gAb4-6MK3b6vwbN8b8XvzEtZlPIOtwqDA&');
      var bytes = utf8.encode(
          "POST&https%3A%2F%2Faccount.api.here.com%2Foauth2%2Ftoken&grant_type%3Dclient_credentials%26oauth_consumer_key%3D4nu0KabdQ3J1MSW2zflHbg%26oauth_nonce%3DXinyexYCoXbmzluT0MOSVCi8EhPjJh5x%26oauth_signature_method%3DHMAC-SHA256%26oauth_timestamp%3D" +
              secondsSinceEpoch +
              "%26oauth_version%3D1.0");
      var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
      var digest = hmacSha256.convert(bytes);
      var signature = Uri.encodeComponent(base64.encode(digest.bytes));
      final response = await http.post(Uri.parse("https://account.api.here.com/oauth2/token"), headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            'OAuth oauth_consumer_key="4nu0KabdQ3J1MSW2zflHbg", oauth_nonce="XinyexYCoXbmzluT0MOSVCi8EhPjJh5x", oauth_signature="' +
                signature +
                '", oauth_signature_method="HMAC-SHA256", oauth_timestamp="' +
                secondsSinceEpoch +
                '", oauth_version="1.0"'
      }, body: <String, String>{
        'grant_type': 'client_credentials'
      });
      var accessToken = json.decode(response.body)['access_token'];
      final geocodingResponse = await http.get(
          Uri.parse("https://revgeocode.search.hereapi.com/v1/revgeocode?at=" +
              lat.toString() +
              "%2C" +
              lng.toString() +
              "&lang=en-US"),
          headers: {"Authorization": "Bearer " + accessToken});
      var addresses = json.decode(geocodingResponse.body)['items'];
      if (addresses.length > 0) {
        address = addresses[0]['title'];
      }
    } else {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.length > 0) {
        address = placemarks[0].street.toString();
      }
    }
    return address;
  }

  static void show(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFF666666),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<ProgressDialog> showProgressDialog(BuildContext context, String message) async {
    // Always use await to call this method
    final ProgressDialog pr =
        ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: message,
      borderRadius: 3.0,
      progressWidget: Container(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
    );
    await pr.show();
    currentProgressDialog = pr;
    return pr;
  }

  static Future<ProgressDialog> showLoadingDialog(BuildContext context) async {
    // Always use await to call this method
    final ProgressDialog pr =
        ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      borderRadius: 3.0,
      progressWidget: Container(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
    );
    await pr.show();
    currentProgressDialog = pr;
    return currentProgressDialog;
  }

  static Future<void> dismissProgressDialog(BuildContext context) async {
    if (currentProgressDialog != null) {
      await currentProgressDialog.hide();
    }
    currentProgressDialog = null;
  }

  static void alert(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            })
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void confirm(BuildContext context, String title, String message, VoidCallback callback) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            child: Text(AppLocalizations.of(context)!.no),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }),
        TextButton(
            child: Text(AppLocalizations.of(context)!.yes),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              if (callback != null) callback();
            })
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static String generateRandomNumber(int length) {
    var number = "";
    var random = new Random();
    for (var i = 0; i < 6; i++) {
      number += random.nextInt(9).toString();
    }
    return number;
  }

  static double getDistance(double lat1, double lon1, double lat2, double lon2) {
    print("Getting distance from " +
        lat1.toString() +
        "," +
        lon1.toString() +
        " to " +
        lat2.toString() +
        "," +
        lon2.toString() +
        "...");
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static DateTime getDateTime(TimeOfDay timeOfDay) {
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  static TimeOfDay getTimeOfDayFromString(String formattedTime) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(formattedTime));
  }

  static String getPaddedTime(int? time) {
    return time.toString().padLeft(2, '0');
  }

  static Future onSelectNotification(String? payload) async {
    var data = jsonDecode(payload!);
  }

  static void showNotification(String title, String body, String payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'banksampah', 'Bank Sampah notifications', 'Notifications for Bank Sampah',
        importance: Importance.max, playSound: true, showProgress: true, priority: Priority.high);
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  static void navigate(context, screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static void replaceScreen(context, screen) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
  }

  static CircularProgressIndicator getProgressBar(Color color) {
    return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color), strokeWidth: 6);
  }
}
