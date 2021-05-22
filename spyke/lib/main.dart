import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:spyke/entities/StockData.dart';
import 'package:spyke/entities/localnotifications.dart';
import 'dart:ui';
import 'package:spyke/pages/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:spyke/entities/network.dart';
import 'dart:convert';

void callback() async {
  if ((DateTime.now().weekday == 7 || DateTime.now().weekday == 6) == false) {
    AndroidAlarmManager.periodic(Duration(minutes: 1), 2, apiminute);
    AndroidAlarmManager.oneShotAt(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            16, 0, 0),
        3,
        apiend);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final int weeklyid = 0;
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
      const Duration(hours: 24), weeklyid, callback,
      startAt: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 9, 0, 0),
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spyke',
      home: MyLoadingPage(),
    );
  }
}

class MyLoadingPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      backgroundColor: Colors.black,
      image: Image.asset('assets/gifs/loadingscreen.gif'),
      photoSize: 200.0,
      loaderColor: Colors.white,
      navigateAfterSeconds: HomePage(),
      loadingText: Text(
        'Loading your Future',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

fetchliveprice(int x, List t) async {
  var pricejson = await http
      .get("https://testingspyke.herokuapp.com/getliveprice?stktkr=${t[x]}");
  var resp = json.decode(pricejson.body);
  return resp['stockprice'];
}

apiminute() async {
  final keytick = 'favtickers', keydelta = 'deltalist', keyprice = 'pricelist';
  var t = await LocalTickerList.instance.displayLocalTickerList(keytick);
  var d = await LocalTickerList.instance.displayDeltaList(keydelta);
  var p = await LocalTickerList.instance.displayPriceList(keyprice);
  var x = t.toString().replaceAll(' ', '');
  x = x.replaceAll('[', '');
  x = x.replaceAll(']', '');
  var y = p.toString().replaceAll(' ', '');
  y = y.replaceAll('[', '');
  y = y.replaceAll(']', '');
  var z = d.toString().replaceAll(' ', '');
  z = z.replaceAll('[', '');
  z = z.replaceAll(']', '');
  String url = 'https://testingspyke.herokuapp.com/getmath/$x/$y/$z';
  fetchnotifdata(url).then((value) {
    for (var i in value) {
      if (i.w && i.x) {
        fetchliveprice(i.shareN, t).then((value1) {
          var g = value1;
          LocalNotification.Initializer();
          LocalNotification.ShowPositiveDeltaNotif(DateTime.now(), t[i.shareN],
              g.toString(), d[i.shareN].toString(), 'Positively');
        });
      } else if (i.w && !i.x) {
        fetchliveprice(i.shareN, t).then((value1) {
          var g = value1;
          LocalNotification.Initializer();
          LocalNotification.ShowPositiveDeltaNotif(DateTime.now(), t[i.shareN],
              g.toString(), d[i.shareN].toString(), 'Negatively');
        });
      }
    }
  });
  var a = DateTime.now().compareTo(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 0, 0));
  if (a == 0 || a == 1) {
    await AndroidAlarmManager.cancel(2);
  }
}

apiend() async {
  final keytick = 'favtickers';
  var q = await LocalTickerList.instance.displayLocalTickerList(keytick);
  var l = q.toString().replaceAll(' ', '');
  l = l.replaceAll('[', '');
  l = l.replaceAll(']', '');
  String u = 'https://testingspyke.herokuapp.com/getmath/$l';
  fetchdayenddata(u).then((value) {
    int count = 0;
    for (var i in value) {
      count++;

      if (i.change == true && i.pos == false) {
        fetchliveprice(count, q).then((value1) {
          LocalNotification.Initializer();
          LocalNotification.ShowDayendNotif(DateTime.now(), 'invest in',
              q[count].toString(), value1.toString());
        });
      } else if (i.change == true && i.pos == true) {
        fetchliveprice(count, q).then((value1) {
          LocalNotification.Initializer();
          LocalNotification.ShowDayendNotif(DateTime.now(), 'pull out from',
              q[count].toString(), value1.toString());
        });
      } else if (i.change == false) {
        null;
      }
    }
  });
}
