// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, missing_return

import 'dart:async';
import 'dart:convert';
import 'package:wakelock/wakelock.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/market/detailCrypto/btcDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../config/APIClasses.dart';

class btc extends StatefulWidget {
  final Widget child;
  String familycurrency_name;
  Map<String, dynamic> currency_data;

  btc({Key key, this.child, this.currency_data, this.familycurrency_name})
      : super(key: key);

  _btcState createState() => _btcState();
}

class _btcState extends State<btc> with TickerProviderStateMixin {
  bool isblink = false;

  String Status = 'E';
  String CurrencyName;
  var item;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/a.jpg?alt=media&token=e36bbee2-4bfb-4a94-bd53-4055d29358e2");
  static NumberFormat Cr = new NumberFormat("#,##0.00", "en_US");
  bool loadImage = false;

  @override
  void initState() {
    Wakelock.enable();
    CurrencyName = widget.familycurrency_name;
    connectToServer();

    super.initState();
  }

  WebSocketChannel channel_btc = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );
  WebSocketChannel channel_btc_own = IOWebSocketChannel.connect(
    Uri.parse(APIClasses.websocket_url),
  );

  Future<void> connectToServer() {
    var jsonString;
    var jsonStringown;
    if (widget.familycurrency_name == "INR") {
      jsonString = json.encode(subRequest_inr);
      jsonStringown = json.encode(subRequest_btc_owninr);
    } else {
      jsonString = json.encode(subRequest_btc);
      jsonStringown = json.encode(subRequest_btc_own);
    }
    channel_btc.sink.add(jsonString);
    channel_btc_own.sink.add(jsonStringown);
  }

  @override
  void dispose() {
    channel_btc.sink.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print("Con //././ " + Connection.toString());
    final screenSize = MediaQuery.of(context).size;
    return Connection == "nointernet"
        ? interneterror()
        : Container(
            child: ListView(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.1),
                    child: Text(
                      "Pair",
                      style: TextStyle(
                          fontSize: 10,
                          color: day == false ? Colors.white54 : Colors.black54,
                          fontFamily: "IBM Plex Sans"),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenSize.width * 0.52,
                        ),
                        child: Text(
                          "Last Price",
                          style: TextStyle(
                              fontSize: 10,
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.02),
                        child: Text(
                          "24h Chg%",
                          style: TextStyle(
                              fontSize: 10,
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 0.0,
              ),
              _dataLoaded(context),
            ],
          ));
  }

  Widget _dataLoaded(BuildContext context) {
    return StreamBuilder(
        stream: channel_btc.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_data['$CurrencyName'].length,
                itemBuilder: (ctx, i) {
                  // print("CONFIRM--=-=-==   "+Currency_data['$CurrencyName'].toString());
                  return carddata(ctx, i);
                },
              ),
            );
          }
          // else if(snapshot.connectionState == ConnectionState.waiting && firsttimebtc==1){
          //   return Container(
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       primary: false,
          //       itemCount: Currency_data['$CurrencyName'].length,
          //       itemBuilder: (ctx, i) {
          //         // print("CONFIRM--=-=-==   "+Currency_data['$CurrencyName'].toString());
          //         return carddata(ctx, i);
          //       },
          //     ),
          //   );
          // }
          else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.active) {
            //place your code here. It will prevent double data call.
            item = json.decode(snapshot.hasData ? snapshot.data : '');
            // print("check iktem data ???" + item.toString());
            firsttimebtc = 1;

            return Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_data['$CurrencyName'].length,
                itemBuilder: (ctx, i) {
                  // print("CONFIRM--=-=-==   "+Currency_data['$CurrencyName'].toString());
                  return card(ctx, i);
                },
              ),
            );
          }
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: Currency_data['$CurrencyName'].length,
              itemBuilder: (ctx, i) {
                return carddata(ctx, i);
              },
            ),
          );
        });
  }

  Widget carddata(BuildContext ctx, int i) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          right: screenSize.width * 0.01,
          left: screenSize.width * 0.01,
          bottom: 8.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                print("P A I " +
                    Currency_data['$CurrencyName'][
                            Currency_data['$CurrencyName']
                                .keys
                                .elementAt(i)][7]['decimal_currency']
                        .toString());
                listed = Currency_data['$CurrencyName']
                            [Currency_data['$CurrencyName'].keys.elementAt(i)]
                        [6]['listed']
                    .toString();
                selectedPair = Currency_data['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString() +
                    widget.familycurrency_name;
              });
              open_order(
                  Currency_data['$CurrencyName']
                              [Currency_data['$CurrencyName'].keys.elementAt(i)]
                          [6]['listed']
                      .toString(),
                  Currency_data['$CurrencyName']
                      .keys
                      .elementAt(i)
                      .toString()
                      .split('$CurrencyName')[0]
                      .toString()
                      .toUpperCase(),
                  widget.familycurrency_name.toUpperCase());
              OrdersHistory(
                  Currency_data['$CurrencyName']
                              [Currency_data['$CurrencyName'].keys.elementAt(i)]
                          [6]['listed']
                      .toString(),
                  Currency_data['$CurrencyName']
                      .keys
                      .elementAt(i)
                      .toString()
                      .split('$CurrencyName')[0]
                      .toString()
                      .toUpperCase(),
                  widget.familycurrency_name.toUpperCase());
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new btcDetail(
                        currency_data: {
                          "currency_name": Currency_data['$CurrencyName']
                              .keys
                              .elementAt(i)
                              .toString()
                              .split('$CurrencyName')[0]
                              .toString(),
                          "PRICE": num.parse(Currency_data['$CurrencyName'][
                                      Currency_data['$CurrencyName']
                                          .keys
                                          .elementAt(i)][3]['currentprice']
                                  .toString())
                              .toString(),
                          "HIGHDAY": Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][10]['high']
                              .toString(),
                          "LOWDAY": Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][9]['low']
                              .toString(),
                          "24chg": Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][5]['24chg']
                              .toString(),
                          "listed": Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][6]['listed']
                              .toString(),
                          "decimal_currency": Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][7]['decimal_currency']
                              .toString(),
                          "decimal_pair": Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][8]['decimal_pair']
                              .toString(),
                          "vol": "0.0"
                        },
                        pair: Currency_data['$CurrencyName']
                            .keys
                            .elementAt(i)
                            .toString()
                            .split('$CurrencyName')[0]
                            .toString(),
                        familycoin: widget.familycurrency_name,
                      )));
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8, bottom: 8, right: screenSize.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][2]['icon'] !=
                                    null
                                ? Image.network(
                                    Currency_data['$CurrencyName'][
                                            Currency_data['$CurrencyName']
                                                .keys
                                                .elementAt(i)][2]['icon']
                                        .toString(),
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                    width: 22.0,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/image/usdt.png",
                                      height: 22.0,
                                      fit: BoxFit.contain,
                                      width: 22.0,
                                    ),
                                  )
                                : Image.asset(
                                    "assets/image/usdt.png",
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                    width: 22.0,
                                  )),
                        Container(
                          width: 95.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    Currency_data['$CurrencyName'][
                                            Currency_data['$CurrencyName']
                                                .keys
                                                .elementAt(i)][1]['pair']
                                        .toString()
                                        .split(' ')[0],
                                    style: TextStyle(
                                        fontFamily: "IBM Plex Sans",
                                        fontSize: 14.5,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '/' + widget.familycurrency_name,
                                    style: TextStyle(
                                      fontFamily: "IBM Plex Sans",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.5,
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  double.parse(Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][5]['24chg']
                              .toString()) <
                          0
                      ? Icon(
                          Icons.trending_down,
                          size: 30,
                          color: Colors.redAccent,
                        )
                      : Icon(
                          Icons.trending_up,
                          size: 30,
                          color: Color(0xFF00C087),
                        ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.05),
                    child: Text(
                      num.parse(Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][3]['currentprice']
                              .toString())
                          .toString(),
                      style: TextStyle(
                          color: Status == 'E'
                              ? day == false
                                  ? Colors.white
                                  : Colors.black
                              : Status == "G"
                                  ? Color(0xFF00C087)
                                  : Colors.redAccent,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.03),
                    child: SizedBox(
                        width: 3,
                        height: 20,
                        child: VerticalDivider(
                          color: day == false ? Colors.white60 : Colors.black45,
                        )),
                  ),
                  Container(
                    width: screenSize.width * 0.12,
                    child: Text(
                      Cr.format(double.parse(Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][5]['24chg']
                              .toString())) +
                          "%",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          fontFamily: 'IBM Plex Sans',
                          color: double.parse(Currency_data['$CurrencyName'][
                                          Currency_data['$CurrencyName']
                                              .keys
                                              .elementAt(i)][5]['24chg']
                                      .toString()) <
                                  0
                              ? Colors.redAccent
                              : Color(0xFF00C087)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 65,right: 65),
          //   child: Divider(color:day==false?Color(0xff8b8b8b):Colors.black54),
          // ),
        ],
      ),
    );
  }

  Widget card(BuildContext ctx, int i) {
    final screenSize = MediaQuery.of(context).size;

    Status = 'E';

    if (Currency_data['$CurrencyName'].keys.elementAt(i) == item['s']) {
      Currency_data['$CurrencyName']
              [Currency_data['$CurrencyName'].keys.elementAt(i)][3]
          ['currentprice'] = item['c'];
      if (double.parse(Currency_data['$CurrencyName']
                      [Currency_data['$CurrencyName'].keys.elementAt(i)][3]
                  ['currentprice']
              .toString()) ==
          double.parse(Currency_data['$CurrencyName']
                      [Currency_data['$CurrencyName'].keys.elementAt(i)][4]
                  ['lastprice']
              .toString())) {
        Status = 'E';
      } else if (double.parse(Currency_data['$CurrencyName']
                      [Currency_data['$CurrencyName'].keys.elementAt(i)][3]
                  ['currentprice']
              .toString()) >
          double.parse(Currency_data['$CurrencyName']
                      [Currency_data['$CurrencyName'].keys.elementAt(i)][4]
                  ['lastprice']
              .toString())) {
        Status = 'G';
      } else {
        Status = 'S';
      }
      //
      Currency_data['$CurrencyName']
              [Currency_data['$CurrencyName'].keys.elementAt(i)][4]
          ['lastprice'] = item['c'];
      Currency_data['$CurrencyName']
              [Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg'] =
          item['P'];
    }

    return Padding(
      padding: EdgeInsets.only(
          right: screenSize.width * 0.01,
          left: screenSize.width * 0.01,
          bottom: 8.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
            
              setState(() {
                listed = Currency_data['$CurrencyName']
                            [Currency_data['$CurrencyName'].keys.elementAt(i)]
                        [6]['listed']
                    .toString();
                selectedPair = Currency_data['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString() +
                    widget.familycurrency_name;
              });
              open_order(
                  Currency_data['$CurrencyName']
                              [Currency_data['$CurrencyName'].keys.elementAt(i)]
                          [6]['listed']
                      .toString(),
                  Currency_data['$CurrencyName']
                      .keys
                      .elementAt(i)
                      .toString()
                      .split('$CurrencyName')[0]
                      .toString()
                      .toUpperCase(),
                  widget.familycurrency_name.toUpperCase());
              OrdersHistory(
                  Currency_data['$CurrencyName']
                              [Currency_data['$CurrencyName'].keys.elementAt(i)]
                          [6]['listed']
                      .toString(),
                  Currency_data['$CurrencyName']
                      .keys
                      .elementAt(i)
                      .toString()
                      .split('$CurrencyName')[0]
                      .toString()
                      .toUpperCase(),
                  widget.familycurrency_name.toUpperCase());
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new btcDetail(
                        currency_data: Currency_data['$CurrencyName'][
                                    Currency_data['$CurrencyName']
                                        .keys
                                        .elementAt(i)][3]
                                .containsKey("currentprice")
                            ? {
                                "currency_name": Currency_data['$CurrencyName']
                                    .keys
                                    .elementAt(i)
                                    .toString()
                                    .split('$CurrencyName')[0]
                                    .toString(),
                                "PRICE": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][3]['currentprice']
                                    .toString(),
                                "HIGHDAY": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][10]['high']
                                    .toString(),
                                "LOWDAY": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][9]['low']
                                    .toString(),
                                "24chg": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][5]['24chg']
                                    .toString(),
                                "listed": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][6]['listed']
                                    .toString(),
                                "decimal_currency":
                                    Currency_data['$CurrencyName'][
                                                Currency_data['$CurrencyName']
                                                    .keys
                                                    .elementAt(i)][7]
                                            ['decimal_currency']
                                        .toString(),
                                "decimal_pair": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][8]['decimal_pair']
                                    .toString()
                              }
                            : {
                                "currency_name": Currency_data['$CurrencyName']
                                    .keys
                                    .elementAt(i)
                                    .toString()
                                    .split('$CurrencyName')[0]
                                    .toString(),
                                "PRICE": "0.0",
                                "HIGHDAY": "0.0",
                                "LOWDAY": "0.0",
                                "24chg": "0.0",
                                "listed": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][6]['listed']
                                    .toString(),
                                "decimal_currency":
                                    Currency_data['$CurrencyName'][
                                                Currency_data['$CurrencyName']
                                                    .keys
                                                    .elementAt(i)][7]
                                            ['decimal_currency']
                                        .toString(),
                                "decimal_pair": Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][8]['decimal_pair']
                                    .toString(),
                                "vol": "0.0"
                              },
                        pair: Currency_data['$CurrencyName']
                            .keys
                            .elementAt(i)
                            .toString()
                            .split('$CurrencyName')[0]
                            .toString(),
                        familycoin: widget.familycurrency_name,
                      )));
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8, bottom: 8, right: screenSize.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 10.0),
                            child: Currency_data['$CurrencyName'][
                                        Currency_data['$CurrencyName']
                                            .keys
                                            .elementAt(i)][2]['icon'] !=
                                    null
                                ? Image.network(
                                    Currency_data['$CurrencyName'][
                                            Currency_data['$CurrencyName']
                                                .keys
                                                .elementAt(i)][2]['icon']
                                        .toString(),
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                    width: 22.0,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/image/usdt.png",
                                      height: 22.0,
                                      fit: BoxFit.contain,
                                      width: 22.0,
                                    ),
                                  )
                                : Image.asset(
                                    "assets/image/usdt.png",
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                    width: 22.0,
                                  )),
                        Container(
                          width: 95.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    Currency_data['$CurrencyName'][
                                            Currency_data['$CurrencyName']
                                                .keys
                                                .elementAt(i)][1]['pair']
                                        .toString()
                                        .split(' ')[0],
                                    style: TextStyle(
                                        fontFamily: "IBM Plex Sans",
                                        fontSize: 14.5,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '/' + widget.familycurrency_name,
                                    style: TextStyle(
                                      fontFamily: "IBM Plex Sans",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.5,
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  double.parse(Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][5]['24chg']
                              .toString()) <
                          0
                      ? Icon(
                          Icons.trending_down,
                          size: 30,
                          color: Colors.redAccent,
                        )
                      : Icon(
                          Icons.trending_up,
                          size: 30,
                          color: Color(0xFF00C087),
                        ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.03),
                    child: Text(
                      num.parse(Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][3]['currentprice']
                              .toString())
                          .toString(),
                      style: TextStyle(
                          color: Status == 'E'
                              ? day == false
                                  ? Colors.white
                                  : Colors.black
                              : Status == "G"
                                  ? Color(0xFF00C087)
                                  : Colors.redAccent,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.05),
                    child: SizedBox(
                        width: 3,
                        height: 20,
                        child: VerticalDivider(
                          color: day == false ? Colors.white60 : Colors.black45,
                        )),
                  ),
                  Container(
                    width: screenSize.width * 0.12,
                    child: Text(
                      Cr.format(double.parse(Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][5]['24chg']
                              .toString())) +
                          "%",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          fontFamily: 'IBM Plex Sans',
                          color: double.parse(Currency_data['$CurrencyName'][
                                          Currency_data['$CurrencyName']
                                              .keys
                                              .elementAt(i)][5]['24chg']
                                      .toString()) <
                                  0
                              ? Colors.redAccent
                              : Color(0xFF00C087)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 65,right: 65),
          //   child: Divider(color:day==false?Color(0xff8b8b8b):Colors.black54),
          // ),
        ],
      ),
    );
  }
}
