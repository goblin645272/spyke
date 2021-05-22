import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spyke/entities/StockData.dart';
import 'package:spyke/entities/network.dart';
import 'package:spyke/pages/singlestockpage.dart';

class AllStocks extends StatefulWidget {
  @override
  _AllStocksState createState() => _AllStocksState();
}

class _AllStocksState extends State<AllStocks> {
  List<StockData> _datas = List<StockData>();
  List<StockData> _datadisplay = List<StockData>();
  bool _isloading = true;

  @override
  void initState() {
    fetchpost().then((value) {
      if (mounted) {
        setState(() {
          _isloading = false;
          _datas.addAll(value);
          _datadisplay = _datas;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (!_isloading) {
              return index == 0 ? _searchBar() : _listItem(index - 1);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          itemCount: _datadisplay.length + 1,
        ));
  }

  _searchBar() {
    return Theme(
        data: new ThemeData(
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Company name',
                border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                _datadisplay = _datas.where((StockData) {
                  var compnyname = StockData.companyName.toLowerCase();
                  return compnyname.contains(text);
                }).toList();
              });
            },
          ),
        ));
  }

  _listItem(index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        _datadisplay[index].companyName,
        style: TextStyle(
            color: Colors.white, fontFamily: "Reem Kufi", fontSize: 20),
      ),
      subtitle: Text(
        _datadisplay[index].ticker,
        style: TextStyle(
            color: Colors.white, fontFamily: "Reem Kufi", fontSize: 17),
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        _sendDataToStockPage(context, index);
      },
    );
  }

  _sendDataToStockPage(BuildContext context, index) {
    String ticker1 = _datadisplay[index].ticker;
    String cmpnyname = _datadisplay[index].companyName;
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SingleStockPage(
            ticker: ticker1,
            companyname: cmpnyname,
            btnstate: false,
          ),
        ));
  }
}
