// ignore_for_file: must_be_immutable, camel_case_types, unused_local_variable

import 'package:exchange/screen/wallet/tabs/deposit.dart';
import 'package:exchange/screen/wallet/tabs/withdraw.dart';
import 'package:flutter/material.dart';

import '../../config/constantClass.dart';

class walletDetail extends StatefulWidget {
  String currency;
  String currencySymbol;
  List network;
  String qty;
  int index;

  walletDetail(
      {Key key,
      this.currency,
      this.network,
      this.qty,
      this.index,
      this.currencySymbol})
      : super(key: key);

  _walletDetailState createState() => _walletDetailState();
}

class _walletDetailState extends State<walletDetail>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    print("WHY NOTR ");
    print(widget.network.toString());
    _tabController =
        new TabController(length: 2, vsync: this, initialIndex: widget.index);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 55),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: day == false ? Colors.white : Colors.black,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Market",
                    style: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontFamily: "IBM Plex Sans",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.5),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xfff9bf30),
                    ),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    indicatorWeight: 5.45,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor:
                        day == false ? Colors.white54 : Colors.black54,
                    indicatorPadding: EdgeInsets.all(8.0),
                    tabs: [
                      new Tab(
                        child: Text(
                          "Deposit",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      new Tab(
                          child: Text(
                        "Withdraw",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ))
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          deposit(
                              network: widget.network, name: widget.currency),
                          withDraw(
                              network: widget.network,
                              currency: widget.currency,
                              currencySymbol: widget.currencySymbol,
                              qty: widget.qty),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
