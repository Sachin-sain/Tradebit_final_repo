// ignore_for_file: must_be_immutable, camel_case_types

import 'package:exchange/component/market/btcModel.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/history/Order_Detail.dart';
import 'package:exchange/screen/history/Product_History.dart';
import 'package:exchange/screen/history/Trade/Trade.dart';
import 'package:exchange/screen/home/Staking/Holding/holding_tab.dart';
import 'package:exchange/screen/home/home.dart';
import 'package:exchange/screen/home/hotDeals.dart';
import 'package:exchange/screen/intro/login.dart';
import 'package:exchange/screen/market/TabBarBody/btc.dart';
import 'package:exchange/screen/market/detailCrypto/btcDetail.dart';
import 'package:exchange/screen/market/markets.dart';
import 'package:exchange/screen/wallet/wallet.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import '../history/Complete_Order.dart';

class bottomNavBar extends StatefulWidget {
  int index;
  bottomNavBar({this.index});

  _bottomNavBarState createState() => _bottomNavBarState(currentIndex: index);
}

class _bottomNavBarState extends State<bottomNavBar> {
  int currentIndex;
  _bottomNavBarState({this.currentIndex});
  String status;
  String token;
  bool loading = true;

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new home();
        break;
      case 1:
        return  status=="true"? new market():login();
        break;
      case 2:
        return Trade();
        break;
      case 3:
        return  new Product_History() ;
        break;
      case 4:
        // return status == "true" ? wallet() : login();
        return new  wallet();
        break;
      default:
        return new home();
    }
  }

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
    return Scaffold(
        backgroundColor: day == false ? Color(0xff181818) : Colors.white,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : callPage(currentIndex),
         bottomNavigationBar: SizedBox(
           height: 80,
           child: FloatingNavbar(
            selectedBackgroundColor: day == false ? Color(0xff181818) : Colors.grey,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: day == false ? Color(0xff181818) : Colors.white,
            onTap: (int val) => setState(() => currentIndex = val),
            currentIndex: currentIndex,
            items: <FloatingNavbarItem>[
              FloatingNavbarItem(icon: Icons.home,title: "Home",),
              FloatingNavbarItem(icon: Icons.stacked_bar_chart, title: "Market"),
              FloatingNavbarItem(icon: Icons.bubble_chart_outlined, title: "Trade"),
              FloatingNavbarItem(icon: Icons.library_books, title: "Orders"),
              FloatingNavbarItem(icon: Icons.account_balance_wallet, title: "Wallet",),
            ]),
         ),
    );
  }
}
