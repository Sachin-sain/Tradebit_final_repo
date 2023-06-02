

import 'dart:core';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/history/Product_History.dart';
import 'package:exchange/screen/history/Trade/Trade.dart';
import 'package:exchange/screen/home/home.dart';
import 'package:exchange/screen/intro/login.dart';
import 'package:exchange/screen/market/markets.dart';
import 'package:exchange/screen/wallet/wallet.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import '../history/Complete_Order.dart';

class bottomNavBar extends StatefulWidget {
  int index;
  final String currencyPair;
  final String currencyNeed;
  final String name;
  bool firstTime;
  final String symbol;
  final String price;
  final String change;

  bottomNavBar(
      {this.index,
      this.currencyPair,
      this.currencyNeed,
      this.firstTime = true,
      this.name,
      this.symbol, this.price, this.change});

  _bottomNavBarState createState() => _bottomNavBarState(currentIndex: index);
}

class _bottomNavBarState extends State<bottomNavBar>
    with SingleTickerProviderStateMixin {
  int currentIndex;

  _bottomNavBarState({this.currentIndex});

  String status;
  String token;
  bool loading = true;

  @override
  void initState() {
    Wakelock.enable();
    checkstatus();
    getRate();
    getcompletedata(1);
    print("djkjskkl");
    for (int i = 0; i < marketfamily.length; i++) {
      BTCAPI(CurrencyName: marketfamily[i].toString());
    }

    super.initState();
  }

  checkstatus() async {
    status = await SharedPreferenceClass.GetSharedData("isLogin");
    token = await SharedPreferenceClass.GetSharedData("token");

    setState(() {
      status = status;
      token = token;
      loading = false;
      print("BTC API HIT" + status.toString());
      print("BTC API HIT" + token.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: day == false ? Color(0xff181818) : Colors.white,
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : callPage(currentIndex,
                status: status,
                currencyPair: widget.currencyPair,
                currencyNeed: widget.currencyNeed,
                name: widget.name,
                firstTime: widget.firstTime,
                symbol: widget.symbol,
                change: widget.change,
                price: widget.price),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: FloatingNavbar(
              selectedBackgroundColor:
                  day == false ? Color(0xff181818) : Colors.grey,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              backgroundColor: day == false ? Color(0xff181818) : Colors.white,
              onTap: (int val) => setState(() => currentIndex = val),
              currentIndex: currentIndex,
              items: <FloatingNavbarItem>[
                FloatingNavbarItem(
                  icon: Icons.home,
                  title: "Home",
                ),
                FloatingNavbarItem(
                    icon: Icons.stacked_bar_chart, title: "Market"),
                FloatingNavbarItem(
                    icon: Icons.bubble_chart_outlined, title: "Trade"),
                FloatingNavbarItem(icon: Icons.library_books, title: "Orders"),
                FloatingNavbarItem(
                  icon: Icons.account_balance_wallet,
                  title: "Wallet",
                ),
              ]),
        ),
      ),
    );
  }
}

Widget callPage(int current,
    {String status,
    String currencyPair,
    String currencyNeed,
    String name,
    bool firstTime,
    String symbol,
    final String price,
    final String change}) {
  switch (current) {
    case 0:
      return new home();
      break;
    case 1:
      return  new market() ;
      break;
    case 2:
      return status == "true" ?Trade(
        currencyPair: currencyPair,
        currencyNeed: currencyNeed,
        name: name,
        firstTime:firstTime,
        symbol: symbol,
        change: change,
        price: price,
      ):login();
      break;
    case 3:
      return status == "true" ?new Product_History():login();
      break;
    case 4:
      return status == "true" ? Wallet() : login();
      break;
    default:
      return new home();
  }
}
