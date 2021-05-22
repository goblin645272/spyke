import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'About us',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Reem Kufi", fontSize: 30, color: Colors.white),
            ),
            Container(
              child: Text(
                "Stock trading is considered a tedious job, with constant monitoring of your stocks a must to earn the highest value.\n Until now, Spyke is an algorithmic tool that detects a fall, rise of your stocks by parameters you set and notifies you about the same.\n We call this paramenter the delta. Spyke will also notify you with the top headlines of the stock and incase there is high fluctuations in a stock over a long period of time.",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    color: Colors.white, fontFamily: "Reem Kufi", fontSize: 20),
              ),
            ),
            Text(
              "V7.3019",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontFamily: "Reem Kufi", fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
