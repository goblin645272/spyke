import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveStock {
  double stockprice;

  LiveStock({this.stockprice});

  LiveStock.fromJson(Map<String, dynamic> json) {
    stockprice = json['stockprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockprice'] = this.stockprice;
    return data;
  }
}

class StockData {
  String companyName;
  String ticker;

  StockData({this.companyName, this.ticker});

  StockData.fromJson(Map<String, dynamic> json) {
    companyName = json['CompanyName'];
    ticker = json['Ticker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyName'] = this.companyName;
    data['Ticker'] = this.ticker;
    return data;
  }
}

class LocalTickerList {
  LocalTickerList._privateConstructor();
  static final LocalTickerList instance = LocalTickerList._privateConstructor();
  List<String> tempList = [];

  setLocalTickerlist(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    if (tickerList.getStringList(key) == null) {
      tempList.add(value);
      tickerList.setStringList(key, tempList);
      return true;
    } else {
      tempList.clear();
      tempList.addAll(tickerList.getStringList(key));
      if (!tempList.contains(value)) {
        tempList.add(value);
        tickerList.setStringList(key, tempList);
        return true;
      } else {
        return false;
      }
    }
  }

  delLocalTickerlist(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    tempList.addAll(tickerList.getStringList(key));
    tempList.remove(value);
    tickerList.setStringList(key, tempList);
    return true;
  }

  displayLocalTickerList(String key) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    return tickerList.getStringList(key);
  }

  setLocalNamelist(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();

    tempList.clear();
    if (tickerList.getStringList(key) == null) {
      tempList.add(value);
      tickerList.setStringList(key, tempList);
    } else {
      tempList.clear();
      tempList.addAll(tickerList.getStringList(key));
      tempList.add(value);
      tickerList.setStringList(key, tempList);
    }

    return true;
  }

  delLocalNamelist(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    tempList.addAll(tickerList.getStringList(key));
    tempList.remove(value);
    tickerList.setStringList(key, tempList);
    return true;
  }

  displayLocalNameList(String key) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    return tickerList.getStringList(key);
  }

  setDeltaList(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    if (tickerList.getStringList(key) == null) {
      tempList.add(value);
      tickerList.setStringList(key, tempList);
    } else {
      tempList.clear();
      tempList.addAll(tickerList.getStringList(key));
      tempList.add(value);
      tickerList.setStringList(key, tempList);
    }
    return true;
  }

  delDeltaList(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    tempList.addAll(tickerList.getStringList(key));
    tempList.remove(value);
    tickerList.setStringList(key, tempList);
    return true;
  }

  displayDeltaList(String key) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    return tickerList.getStringList(key);
  }

  setPriceList(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    if (tickerList.getStringList(key) == null) {
      tempList.add(value);
      tickerList.setStringList(key, tempList);
    } else {
      tempList.clear();
      tempList.addAll(tickerList.getStringList(key));
      tempList.add(value);
      tickerList.setStringList(key, tempList);
    }
    return true;
  }

  delPriceList(String key, String value) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    tempList.clear();
    tempList.addAll(tickerList.getStringList(key));
    tempList.remove(value);
    tickerList.setStringList(key, tempList);
    return true;
  }

  displayPriceList(String key) async {
    SharedPreferences tickerList = await SharedPreferences.getInstance();
    return tickerList.getStringList(key);
  }
}

class chartdata {
  var timestamp;
  double open;
  double high;
  double low;
  double close;
  double adjclose;
  double volume;

  chartdata(
      {this.timestamp,
      this.open,
      this.high,
      this.low,
      this.close,
      this.adjclose,
      this.volume});

  chartdata.fromJson(Map<String, dynamic> json) {
    timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    adjclose = json['adjclose'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['open'] = this.open;
    data['high'] = this.high;
    data['low'] = this.low;
    data['close'] = this.close;
    data['adjclose'] = this.adjclose;
    data['volume'] = this.volume;
    return data;
  }
}

class GraphData {
  var timestamp;
  double open;
  double high;
  double low;
  double close;
  double adjclose;
  double volume;

  GraphData(
      {this.open,
      this.high,
      this.adjclose,
      this.close,
      this.low,
      this.timestamp,
      this.volume});

  GraphData.fromJson(Map<String, dynamic> json) {
    timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    adjclose = json['adjclose'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['open'] = this.open;
    data['high'] = this.high;
    data['low'] = this.low;
    data['close'] = this.close;
    data['adjclose'] = this.adjclose;
    data['volume'] = this.volume;
    return data;
  }
}

class StockNotifInfo {
  int shareN;
  DateTime timestamp;
  bool w;
  bool x;

  StockNotifInfo({this.shareN, this.timestamp, this.w, this.x});

  StockNotifInfo.fromJson(Map<String, dynamic> json) {
    shareN = json['share_n'];
    timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
    w = json['w'];
    x = json['x'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['share_n'] = this.shareN;
    data['timestamp'] = this.timestamp;
    data['w'] = this.w;
    data['x'] = this.x;
    return data;
  }
}

class NewsData {
  String url;
  String headline;
  String dateTime;

  NewsData({this.url, this.headline, this.dateTime});

  NewsData.fromJson(Map<String, dynamic> json) {
    url = json['URL'];
    headline = json['Headline'];
    dateTime = json['Date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['URL'] = this.url;
    data['Headline'] = this.headline;
    data['Date_time'] = this.dateTime;
    return data;
  }
}

class LongTerm {
  bool change;
  bool pos;
  double indi;

  LongTerm({this.change, this.pos, this.indi});

  LongTerm.fromJson(Map<String, dynamic> json) {
    change = json['change'];
    pos = json['pos'];
    indi = json['indi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['change'] = this.change;
    data['pos'] = this.pos;
    data['indi'] = this.indi;
    return data;
  }
}
