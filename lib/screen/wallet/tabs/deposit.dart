// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../config/constantClass.dart';

class deposit extends StatefulWidget {
  List network;
  String name;

  deposit({Key key, this.network, this.name});

  _depositState createState() => _depositState();
}

class _depositState extends State<deposit> {
  TextEditingController valuecontroller = new TextEditingController();
  bool save = false;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: widget.network.length,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 5.0),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Color(0xff17394f), Color(0xff17394f)])),
                labelColor: Colors.white,
                unselectedLabelColor:
                    day == false ? Colors.white38 : Colors.black38,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  letterSpacing: 1.5,
                ),
                labelStyle: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
                // indicatorPadding: EdgeInsets.all(2.0),
                tabs: <Widget>[
                  for (int i = 0; i < widget.network.length; i++)
                    new Tab(
                      child: Text(
                        widget.network[i]['token_type'].toString(),
                        style: TextStyle(fontFamily: "IBM Plex Sans"),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                // decoration: BoxDecoration(
                //    color: day==false?Colors.transparent:Color(0xff143047),
                //     borderRadius: BorderRadius.all(Radius.circular(10.0))),

                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    for (int i = 0; i < widget.network.length; i++) deposit(i),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  Widget deposit(int i) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.network[i]['wallet_address'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: save == false
                    ? day == false
                        ? Colors.white
                        : Colors.black.withOpacity(0.7)
                    : Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "IBM Plex Sans",
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          InkWell(
            onTap: () {
              setState(() {
                save = true;
              });

              Clipboard.setData(ClipboardData(
                      text: widget.network[i]['wallet_address'].toString()))
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Referral Link Copied")));
                setState(() {
                  save = false;
                });
              });

              // setState(() {
              //   save=false;
              // });
            },
            child: Container(
              height: 40.0,
              width: 150.0,
              color: day == false ? Colors.white10 : Color(0xff173b52),
              child: Center(
                child: Text(
                  "COPY ADDRESS",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "SCAN QR CODE",
            style: TextStyle(
              color: save == false ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: "IBM Plex Sans",
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          QrImage(
            backgroundColor: Colors.white,
            data: widget.network[i]['wallet_address'].toString(),
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(
            height: 25.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Min Deposit ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
              Text(
                widget.network[i]['deposit_min'].toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Expected Arrival ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "15 Network Confirmation",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Expected Lock ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "15 Network Confirmation",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
              ),
              Text("Warning",
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: "IBM Plex Sans",
                      fontSize: 14.0)),
            ],
          ),
          Divider(
            color: day == false ? Colors.white54 : Colors.black54,
          ),
          Text(
              '''● Send Only Using The ${widget.network[i]['token_type'].toString()} Network. Using Any Other Network Will Result In Loss Of Funds.''',
              style: TextStyle(
                  color: day == false ? Colors.white : Colors.black,
                  fontFamily: "IBM Plex Sans",
                  fontSize: 10.0)),
          Text(
              '''● Deposit Only ${widget.name} To This Deposit Address. Depositing Any Other Asset Will Result In A Loss Of Funds.''',
              style: TextStyle(
                  color: day == false ? Colors.white : Colors.black,
                  fontFamily: "IBM Plex Sans",
                  fontSize: 10.0))
        ],
      ),
    );
  }
}
