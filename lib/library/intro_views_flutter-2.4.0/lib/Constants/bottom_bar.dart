import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constant.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int activeTabNumber = 3;
  DateTime currentBackPressTime;

  chnageTab(int i) {
    setState(() {
      activeTabNumber = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        bottomNavigationBar: Material(
          elevation: 2.0,
          child: Container(
            height: 70.0,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (activeTabNumber != 1) {
                      chnageTab(1);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(
                      1, activeTabNumber, Icons.home, 'Portfolio'),
                ),
                InkWell(
                  onTap: () {
                    if (activeTabNumber != 2) {
                      chnageTab(2);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(2, activeTabNumber,
                      Icons.account_balance_wallet, 'Wallet'),
                ),
                InkWell(
                  onTap: () {
                    if (activeTabNumber != 3) {
                      chnageTab(3);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(3, activeTabNumber,
                      Icons.account_balance_outlined, 'Market'),
                ),
                InkWell(
                  onTap: () {
                    if (activeTabNumber != 4) {
                      chnageTab(4);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(
                      4, activeTabNumber, Icons.notifications, 'Notification'),
                ),
                InkWell(
                  onTap: () {
                    if (activeTabNumber != 5) {
                      chnageTab(5);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: bottomBarItem(5, activeTabNumber, Icons.list, 'More'),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
        return false;
      },
    );
  }

  bottomBarItem(tabNumber, activeIndex, icon, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30.0,
          color: (activeIndex == tabNumber) ? primaryColor : bottomBarGreyColor,
        ),
        SizedBox(height: 5.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.0,
            color: (activeIndex == tabNumber) ? blackColor : bottomBarGreyColor,
          ),
        ),
      ],
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: whiteColor,
      );
      return false;
    } else {
      return true;
    }
  }
}
