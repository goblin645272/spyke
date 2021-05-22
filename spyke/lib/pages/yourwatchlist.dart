import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spyke/entities/StockData.dart';
import 'package:http/http.dart' as http;
import 'package:spyke/entities/network.dart';
import 'dart:convert';
import 'package:spyke/pages/singlestockpage.dart';
import 'dart:async';

class YourWatchList extends StatefulWidget {
  @override
  _YourWatchListState createState() => _YourWatchListState();
}

class _YourWatchListState extends State<YourWatchList> {
  var watchlist, namelist, pricelist, deltalist;
  List<GraphData> ndata = List<GraphData>();
  List<LiveStock> liveprice = List<LiveStock>();
  final keytick = 'favtickers',
      keyname = 'namelist',
      keydelta = 'deltalist',
      keyprice = 'pricelist';
  bool _isLoading = true;
  Timer __timer;
  @override
  void initState() {
    load1data();
    __timer = Timer.periodic(Duration(seconds: 20), (timer) => load1data());
    super.initState();
  }

  load1data() async {
    watchlist = await LocalTickerList.instance.displayLocalTickerList(keytick);
    namelist = await LocalTickerList.instance.displayLocalNameList(keyname);
    deltalist = await LocalTickerList.instance.displayDeltaList(keydelta);
    pricelist = await LocalTickerList.instance.displayPriceList(keyprice);
    var x = watchlist.toString().replaceAll(' ', '');
    x = x.replaceAll('[', '');
    x = x.replaceAll(']', '');
    String url = 'https://testingspyke.herokuapp.com/getliveprice/$x';
    fetchLivedata(url).then((value) {
      liveprice.addAll(value);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: (() {
              if (_isLoading) {
                if (watchlist == null) {
                  return Center(
                    child: Text(
                      'No Stocks added, please add some',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else if (!_isLoading) {
                return _gridView();
              }
            }())));
  }

  _gridView() {
    return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 2.3,
        children: List.generate(watchlist.length, (index) {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green[900], Colors.greenAccent[400]]),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
                title: Text(
                  namelist[index] + '  (' + watchlist[index] + ')',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "Reem Kufi"),
                ),
                subtitle: Text(
                  'Price when added: ' +
                      '₹' +
                      pricelist[index] +
                      '\nDelta  set: ' +
                      deltalist[index],
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Reem Kufi"),
                ),
                trailing: Container(
                    padding: EdgeInsets.only(top: 29),
                    child: Text(
                      "₹" + liveprice[index].stockprice.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 25, color: Colors.green[950]),
                    )),
                onTap: () {
                  _sendDataToStockPage(context, index);
                }),
          );
        }));
  }

  _sendDataToStockPage(BuildContext context, index) {
    final ticker1 = watchlist[index];
    final cmpnyname = namelist[index];
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SingleStockPage(
            ticker: ticker1,
            companyname: cmpnyname,
            btnstate: 'true',
          ),
        ));
  }
}
