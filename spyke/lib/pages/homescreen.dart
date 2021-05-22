import 'package:spyke/pages/stocksall.dart';
import 'package:spyke/pages/aboutus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:spyke/pages/yourwatchlist.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spyke',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Image.asset(
                'assets/images/header.png',
                fit: BoxFit.contain,
                height: 100,
                alignment: Alignment.center,
              ),
            ),
            backgroundColor: Colors.black,
            bottom: TabBar(
              indicator: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.indigo[900], Colors.lightBlue[500]]),
                borderRadius: BorderRadius.circular(50),
              ),
              tabs: [
                Tab(
                  child: Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                    child: Text(
                  'All Stocks',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
                Tab(
                    child: Text(
                  'About Us',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              YourWatchList(),
              AllStocks(),
              AboutUs(),
            ],
          ),
        ),
      ),
    );
  }
}
