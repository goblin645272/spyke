import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'StockData.dart';
import 'package:flutter/services.dart' show rootBundle;

List<StockData> parseStockData(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var allstockdata = list.map((model) => StockData.fromJson(model)).toList();
  return allstockdata;
}

Future<List<StockData>> fetchpost() async {
  try {
    final response = await rootBundle.loadString('assets/json/ticker.json');
    return compute(parseStockData, response);
  } catch (e) {
    print(e);
  }
}

Future<List<GraphData>> fetchgraphdata(String ticker, String period) async {
  String url =
      "https://testingspyke.herokuapp.com/historicaldata/$period?stktkr=$ticker";
  final response = await http.get(url);
  return compute(parsegraphdata, response.body);
}

List<GraphData> parsegraphdata(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var allstockdata = list.map((model) => GraphData.fromJson(model)).toList();
  return allstockdata;
}

List<GraphData> createchart(List<GraphData> info) {
  List<GraphData> serieslist = [];
  for (int i = 0; i < info.length; i++) {
    if (info[i].volume == null) {
      serieslist.add(GraphData(
          timestamp: info[i].timestamp,
          close: info[i].close,
          open: info[i].open,
          high: info[i].high,
          low: info[i].low));
    } else if (info[i].volume.isFinite) {
      serieslist.add(GraphData(
          timestamp: info[i].timestamp,
          adjclose: info[i].adjclose,
          volume: info[i].volume,
          close: info[i].close,
          open: info[i].open,
          high: info[i].high,
          low: info[i].low));
    } else {
      null;
    }
  }
  return serieslist;
}

Future<List<StockNotifInfo>> fetchnotifdata(String url) async {
  final response = await http.get(url);
  return compute(parsenotifdata, response.body);
}

List<StockNotifInfo> parsenotifdata(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var allstockdata =
      list.map((model) => StockNotifInfo.fromJson(model)).toList();
  return allstockdata;
}

Future<List<NewsData>> fetchnewsdata(String url) async {
  final response = await http.get(url);
  return compute(parsenewsdata, response.body);
}

List<NewsData> parsenewsdata(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var allstockdata = list.map((model) => NewsData.fromJson(model)).toList();
  return allstockdata;
}

Future<List<LongTerm>> fetchdayenddata(String url) async {
  final response = await http.get(url);
  return compute(parsedayenddata, response.body);
}

List<LongTerm> parsedayenddata(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var allstockdata = list.map((model) => LongTerm.fromJson(model)).toList();
  return allstockdata;
}

Future<List<LiveStock>> fetchLivedata(String url) async {
  final response = await http.get(url);
  return compute(parseLivedata, response.body);
}

List<LiveStock> parseLivedata(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var allstockdata = list.map((model) => LiveStock.fromJson(model)).toList();
  return allstockdata;
}
