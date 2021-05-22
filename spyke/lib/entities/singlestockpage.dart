import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spyke/entities/StockData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spyke/entities/charts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:spyke/entities/network.dart';

class SingleStockPage extends StatefulWidget {
  final ticker;
  final companyname;
  final btnstate;
  SingleStockPage(
      {Key key,
      @required this.ticker,
      @required this.companyname,
      @required this.btnstate})
      : super(key: key);
  @override
  _SingleStockPageState createState() => _SingleStockPageState();
}

class _SingleStockPageState extends State<SingleStockPage> {
  final myController = TextEditingController();
  bool _isLoading = true;
  String weekRange,
      dayRange,
      avgVolume,
      marketCap,
      quotePrice,
      open,
      previousClose,
      volume;

  Timer _timer;
  final keytick = 'favtickers',
      keyname = 'namelist',
      keydelta = 'deltalist',
      keyprice = 'pricelist';
  SharedPreferences favTickers;
  List<String> tickerlist, tempList;
  List<NewsData> news = List<NewsData>();
  bool val;
  @override
  void initState() {
    loaddata();
    loadnewsdata();
  }

  loaddata() async {
    String url =
        'https://testingspyke.herokuapp.com/getquote?stktkr=${widget.ticker.toString()}';
    http.Response response = await http.get(url);
    var stockQuote = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        weekRange = stockQuote['52 Week Range'].toString();
        dayRange = stockQuote["Day's Range"].toString();
        marketCap = stockQuote['Market Cap'].toString();
        avgVolume = stockQuote['Avg. Volume'].toString();
        quotePrice = stockQuote['Quote Price'].toString();
        open = stockQuote['Open'].toString();
        volume = stockQuote['Volume'].toString();
        _isLoading = false;
      });
    }
  }

  loadnewsdata() async {
    String ur = "http://localhost:5000/scrapenews?search=${widget.companyname}";
    fetchnewsdata(ur).then((value) {
      setState(() {
        news.addAll(value);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Image.asset(
                  'assets/images/header.png',
                  fit: BoxFit.contain,
                  height: 100,
                  alignment: Alignment.center,
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              body: Container(
                color: Colors.black,
                child: ListView(physics: ClampingScrollPhysics(), children: [
                  Text(
                    widget.companyname + " (${widget.ticker})",
                    style: TextStyle(
                      fontFamily: "Reem Kufi",
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                      color: Colors.black54,
                      child: TabBar(tabs: [
                        Tab(
                            icon: AutoSizeText("1D",
                                maxFontSize: 25.0,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                minFontSize: 0.0)),
                        Tab(
                            icon: AutoSizeText("1W",
                                maxFontSize: 25.0,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                minFontSize: 0.0)),
                        Tab(
                            icon: AutoSizeText("1M",
                                maxFontSize: 25.0,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                minFontSize: 0.0)),
                        Tab(
                            icon: AutoSizeText("6M",
                                maxFontSize: 25.0,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                minFontSize: 0.0)),
                        Tab(
                            icon: AutoSizeText("1Y",
                                maxFontSize: 25.0,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                minFontSize: 0.0))
                      ])),
                  Container(height: 15.0),
                  Container(
                    height: 250.0,
                    padding: EdgeInsets.only(right: 10.0),
                    child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SimpleTimeSeriesChart(
                            ticker: widget.ticker,
                            period: '1d',
                          ),
                          SimpleTimeSeriesChart(
                              ticker: widget.ticker, period: '7d'),
                          SimpleTimeSeriesChart(
                              ticker: widget.ticker, period: '1m'),
                          SimpleTimeSeriesChart(
                              ticker: widget.ticker, period: '6m'),
                          SimpleTimeSeriesChart(
                              ticker: widget.ticker, period: '1y'),
                        ]),
                  ),
                  (() {
                    if (!_isLoading) {
                      return Text('Stock Details:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ));
                    } else {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }()),
                  (() {
                    if (!_isLoading) {
                      return Text(
                        "    Current Price: ₹ $quotePrice",
                        style: TextStyle(
                            fontFamily: "Reem Kufi",
                            fontSize: 20,
                            color: Colors.white),
                      );
                    }
                  }()),
                  (() {
                    if (!_isLoading) {
                      return Text(
                        "    Day\'s Range: ₹$dayRange",
                        style: TextStyle(
                            fontFamily: "Reem Kufi",
                            fontSize: 20,
                            color: Colors.white),
                      );
                    }
                  }()),
                  (() {
                    if (!_isLoading) {
                      return Text(
                        "    Today's open: ₹$open",
                        style: TextStyle(
                            fontFamily: "Reem Kufi",
                            fontSize: 20,
                            color: Colors.white),
                      );
                    }
                  }()),
                  (() {
                    if (!_isLoading) {
                      return Text(
                        "   52 Week Range: ₹$weekRange",
                        style: TextStyle(
                            fontFamily: "Reem Kufi",
                            fontSize: 20,
                            color: Colors.white),
                      );
                    }
                  }()),
                  (() {
                    if (!_isLoading) {
                      return Text(
                        "    Volume: ₹$volume",
                        style: TextStyle(
                            fontFamily: "Reem Kufi",
                            fontSize: 20,
                            color: Colors.white),
                      );
                    }
                  }()),
                  (() {
                    if (!_isLoading) {
                      return Text(
                        "    Average Volume: ₹$avgVolume",
                        style: TextStyle(
                            fontFamily: "Reem Kufi",
                            fontSize: 20,
                            color: Colors.white),
                      );
                    }
                  }()),
                  Container(
                    margin: EdgeInsets.all(10),
                    color: Colors.grey,
                    child: Text('example'),
                  ),
                ]),
              ),
              floatingActionButton: (() {
                if (widget.btnstate == 'true') {
                  return FloatingActionButton(
                    child: Icon(
                      Icons.delete,
                      size: 30.0,
                    ),
                    tooltip: 'Delete Stock from watchlist',
                    elevation: 10.0,
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _DeleteStockDialog(context));
                    },
                  );
                } else if (widget.btnstate == false) {
                  return FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      size: 30.0,
                    ),
                    tooltip: 'Add Stock to your watchlist',
                    elevation: 5.0,
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _AddStockDialog(context));
                    },
                  );
                }
              }())),
        ));
  }

  Widget _DeleteStockDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Delete Stock'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(widget.companyname), Text('Note:')],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            if (await LocalTickerList.instance
                    .delLocalTickerlist(keytick, widget.ticker) ==
                true) {
              if (await LocalTickerList.instance
                      .delDeltaList(keydelta, myController.text) &&
                  await LocalTickerList.instance
                      .delLocalNamelist(keyname, widget.companyname) &&
                  await LocalTickerList.instance
                          .delPriceList(keyprice, quotePrice.toString()) ==
                      true) {
                return Fluttertoast.showToast(msg: 'Deleted StockData');
              }
              ;
            } else {
              return Fluttertoast.showToast(msg: 'Already in favourites');
            }

            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Add Stock to your watchlist'),
        ),
      ],
    );
  }

  Widget _AddStockDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(quotePrice),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: myController,
            decoration: InputDecoration(
              hintText: 'Enter delta value here',
              suffixIcon: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _deltaInfoDialog(context));
                },
                child: Icon(Icons.info),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            if (await LocalTickerList.instance
                    .setLocalTickerlist(keytick, widget.ticker) ==
                true) {
              if (await LocalTickerList.instance
                      .setDeltaList(keydelta, myController.text) &&
                  await LocalTickerList.instance
                      .setLocalNamelist(keyname, widget.companyname) &&
                  await LocalTickerList.instance
                          .setPriceList(keyprice, quotePrice) ==
                      true) {
                return Fluttertoast.showToast(msg: 'Added to favourites');
              }
              ;
            } else {
              return Fluttertoast.showToast(msg: 'Already in favourites');
            }

            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Add Stock to your watchlist'),
        ),
      ],
    );
  }

  Widget _deltaInfoDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Delta is the "),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
