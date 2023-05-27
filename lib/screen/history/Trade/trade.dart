import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/screen/history/Trade/Buy.dart';
import 'package:exchange/screen/history/Trade/drawer.dart';
import 'package:exchange/screen/history/Trade/price.dart';
import 'package:flutter/material.dart';

import '../../../config/constantClass.dart';
import '../Complete_Order.dart';
import '../Open_Orders.dart';
import 'Sell.dart';

class Trade extends StatefulWidget {
  final String symbol;
  bool firstTime;
  final String name;
  final String currencyNeed;
  final String currencyPair;
  final String price;
  final String change;

  Trade(
      {Key key,
      this.symbol,
      this.firstTime = true,
      this.name,
      this.currencyNeed,
      this.currencyPair, this.price, this.change})
      : super(key: key);
  @override
  State<Trade> createState() => _TradeState();
}

class _TradeState extends State<Trade> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    getData();
    setState(() {
    firstTime = widget.firstTime;

    });
    super.initState();
  }

  bool firstTime = true;
  String change = '';
  List fav = [];
  List usdt = [];
  List eth = [];
  List btc = [];
  List trx = [];
  List currency = [];
  List btclist = [];
  String price;
  int current = 0;
  bool isbuySelected = true;
  TabController _tabController;

  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          MyDrawer(btcList: btclist, eth: eth, fav: fav, trx: trx, usdt: usdt),
      backgroundColor: day == false ? Colors.black : Color(0xfff6f6f6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 5, bottom: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                alignment: Alignment.centerLeft,
                height: 20,
                width: 400,
                color: day == false ? Color(0xff181818) : Colors.white,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerLeft,
                height: 50,
                width: 400,
                color: day == false ? Color(0xff181818) : Colors.white,
                child: Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: day == false ? Colors.white : Color(0xff0a0909),
                    ),
                    Builder(
                      builder: (context) => GestureDetector(
                          onTap: () {
                            setState(() {
                              Scaffold.of(context).openDrawer();
                            });
                          },
                          child: Text(
                           firstTime ? 'BTCUSDT' : widget.name,
                            style: TextStyle(
                                color: day == false
                                    ? Colors.white
                                    : Color(0xff0a0909),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                         '${firstTime ? change : widget.change}%',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: day == false ? Color(0xff181818) : Colors.white,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 15,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            "  Candlestick",
                            style: TextStyle(
                                color: day == false
                                    ? Colors.white
                                    : Color(0xff0a0909),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 375,
                          width: 200,
                          color:
                              day == false ? Color(0xff181818) : Colors.white,
                          child: Expanded(
                            child: Container(
                              child: DefaultTabController(
                                length: 2,
                                child: Card(
                                  color: day == false
                                      ? Color(0xff181818)
                                      : Color(0xffffffff),
                                  child: new Scaffold(
                                    backgroundColor: day == false
                                        ? Color(0xff181818)
                                        : Color(0xffffffff),
                                    appBar: PreferredSize(
                                      preferredSize: Size.fromHeight(
                                          5.0), // here the desired height
                                      child: Container(
                                        color: day == false
                                            ? Color(0xff181818)
                                            : Color(0xffffffff),
                                        child: new AppBar(
                                          backgroundColor: day == false
                                              ? Color(0xff181818)
                                              : Color(0xffffffff),
                                          elevation: 0.0,
                                          centerTitle: true,
                                          flexibleSpace: Container(
                                            color: day == false
                                                ? Color(0xff181818)
                                                : Color(0xffffffff),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                child: new ButtonsTabBar(
                                                  onTap: (i) {
                                                    setState(() {
                                                      current = i;
                                                    });
                                                  },
                                                  backgroundColor: current == 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  unselectedBackgroundColor:
                                                      Colors.grey,
                                                  contentPadding:
                                                      EdgeInsets.only(left: 30),
                                                  tabs: [
                                                    new Tab(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 30),
                                                            child: Text(
                                                              "Buy",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "IBM Plex Sans",
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    new Tab(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 30.0,
                                                            ),
                                                            child: Text(
                                                              "Sell",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "IBM Plex Sans",
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          automaticallyImplyLeading: false,
                                        ),
                                      ),
                                    ),
                                    body: Container(
                                      color: day == false
                                          ? Color(0xff181818)
                                          : Color(0xffffffff),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: new TabBarView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          controller: _tabController,
                                          children: [
                                            buy(
                                              pairCurrency: widget.currencyPair,
                                              currencyneed: widget.currencyNeed,
                                              price: widget.price,
                                              isFirstTime: widget.firstTime,
                                            ),
                                            Sell(
                                              currencyneed: widget.currencyNeed,
                                              pairCurrency: widget.currencyPair,
                                              price: widget.price,
                                              firstTime: widget.firstTime,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 375,
                      width: 182,
                      color: day == false ? Color(0xff181818) : Colors.white,
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 90),
                              height: 15,
                              width: 66,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                children: [
                                  Text(
                                    "  Expand",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Color(0xff0a0909),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 20,
                                    color: day == false
                                        ? Colors.white
                                        : Color(0xff0a0909),
                                  )
                                ],
                              )),
                          Expanded(
                              child: Price(
                            currency: currency,
                            symbol: widget.symbol,
                            firstTime: widget.firstTime,
                            currencyNeed: widget.currencyNeed,
                            pair: widget.currencyPair,
                          )),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3.4,
                color: day == false ? Color(0xff181818) : Colors.white,
                child: Expanded(
                  child: Container(
                    child: DefaultTabController(
                      length: 3,
                      child: Card(
                        color: day == false
                            ? Color(0xff181818)
                            : Color(0xffffffff),
                        child: new Scaffold(
                          backgroundColor: day == false
                              ? Color(0xff181818)
                              : Color(0xffffffff),
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(
                                20.0), // here the desired height
                            child: Container(
                              color: day == false
                                  ? Color(0xff181818)
                                  : Color(0xffffffff),
                              child: new AppBar(
                                backgroundColor: day == false
                                    ? Color(0xff181818)
                                    : Color(0xffffffff),
                                elevation: 0.0,
                                centerTitle: true,
                                flexibleSpace: Container(
                                  color: day == false
                                      ? Color(0xff181818)
                                      : Color(0xffffffff),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      child: new TabBar(
                                        isScrollable: true,
                                        labelPadding: EdgeInsets.all(10),
                                        controller: _tabController,
                                        indicatorPadding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        indicatorColor: Color(0xfff9bf30),
                                        labelColor: day == false
                                            ? Colors.white
                                            : Colors.grey,
                                        // indicatorColor: Colors.blue,
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decorationThickness: 2,
                                            decorationColor: Color(0xfff9bf30)),
                                        unselectedLabelStyle: TextStyle(
                                            fontWeight: FontWeight.w600),
                                        unselectedLabelColor: day == false
                                            ? Colors.white60
                                            : Colors.black45,

                                        indicatorSize: TabBarIndicatorSize.tab,

                                        tabs: [
                                          new Tab(
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 5.0),
                                                  child: Text(
                                                    "Open Orders",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "IBM Plex Sans",
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          new Tab(
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 10.0),
                                                  child: Text(
                                                    "Open History",
                                                    style: TextStyle(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                automaticallyImplyLeading: false,
                              ),
                            ),
                          ),
                          body: Container(
                            color: day == false
                                ? Color(0xff181818)
                                : Color(0xffffffff),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: new TabBarView(
                                controller: _tabController,
                                children: [
                                  RemainingopenOrders(),
                                  CompleteopenOrders(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    final Map<String, String> paramDic = {
      "": "",
    };
    try {
      final response =
          await APIMainClassbinance(APIClasses.currencyget, paramDic, "Get");
      if (response?.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          currency.add(data['data']);
          data['data']['FAV']?.forEach((item) {
            fav.add(item);
          });
          data['data']['USDT']?.forEach((item) {
            usdt.add(item);
            change = item['change'];
          });
          data['data']['ETH']?.forEach((item) {
            eth.add(item);
          });
          data['data']['TRX']?.forEach((item) {
            trx.add(item);
          });
          data['data']['BTC']?.forEach((item) {
            btclist.add(item);
          });

        });
      } else {
        throw Exception('Unable to fetch data ');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
