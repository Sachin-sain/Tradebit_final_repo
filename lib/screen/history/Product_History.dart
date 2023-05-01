// ignore_for_file: camel_case_types

import 'package:candlesticks/candlesticks.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/history/Complete_Order.dart';
import 'package:exchange/screen/history/Open_Orders.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class Product_History extends StatefulWidget {
  @override
  _Product_HistoryState createState() => _Product_HistoryState();
}

class _Product_HistoryState extends State<Product_History> {
  @override
  void initState() {
    Wakelock.enable();

    super.initState();
  }

  List<Candle> candles = [];
  String interval = "1m";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 2,
        child: new Scaffold(
            backgroundColor: day == false ? Colors.black : Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.05, left: 10, right: 10),
                  child: Text(
                    "Product History",
                    style: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontFamily: "IBM Plex Sans",
                        fontWeight: FontWeight.w600,
                        fontSize: 22.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Card(
                    color: day == false ? Colors.transparent : Colors.white,
                    shadowColor: Colors.black,
                    child: new TabBar(
                      labelPadding: EdgeInsets.zero,
                      // labelColor: Theme.of(context).primaryColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffc79509),
                      ),
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w600),
                      unselectedLabelStyle: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400),
                      unselectedLabelColor:
                          day == false ? Colors.white38 : Colors.black45,

                      tabs: [
                        new Tab(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Open Order",
                              style: TextStyle(fontFamily: "IBM Plex Sans"),
                            ),
                          ),
                        ),
                        new Tab(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Completed",
                              style: TextStyle(fontFamily: "IBM Plex Sans"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 0),
                    child: Card(
                      shadowColor: Color(0xFF656565).withOpacity(0.8),
                      color: day == false ? Colors.transparent : Colors.white,
                      child: TabBarView(
                        children: <Widget>[
                          RemainingopenOrders(),
                          CompleteopenOrders(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
