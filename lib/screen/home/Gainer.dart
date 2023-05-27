// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, missing_return

import 'dart:async';
import 'dart:convert';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/market/detailCrypto/btcDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wakelock/wakelock.dart';


class gainer extends StatefulWidget {
  final Widget child;
  Map<String, dynamic> currency_data;
  gainer({Key key, this.child, this.currency_data}) : super(key: key);
  _gainerState createState() => _gainerState();
}
class _gainerState extends State<gainer> with TickerProviderStateMixin {
  bool isblink = false;

  String Status = 'E';
  String CurrencyName='USDT';
  var item;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/a.jpg?alt=media&token=e36bbee2-4bfb-4a94-bd53-4055d29358e2");
  static NumberFormat Cr = new NumberFormat("#,##0.00", "en_US");
  bool loadImage = false;


  @override
  void initState() {
    connectToServer();
    Wakelock.enable();

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  var data;
  WebSocketChannel channel_usdt = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );
  Future<void> connectToServer() {
    var jsonString = json.encode(subRequest_usdt);
    channel_usdt.sink.add(jsonString);

  }


  @override
  void dispose() {
    print("njk");
    channel_usdt.sink.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        child: ListView(
          children: <Widget>[
           // Divider(color: Colors.white38,),
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 7.0, bottom: 2.0),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width *0.1),
                    child: Text(
                      "Pair",
                      style: TextStyle(
                          fontSize: 10,
                          color: day==false?Colors.white54:Colors.black54,
                          fontFamily: "IBM Plex Sans"),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: screenSize.width *0.52,),
                        child: Text(
                          "Last Price",
                          style: TextStyle(
                              fontSize: 10,
                              color: day==false?Colors.white54:Colors.black54,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(left:screenSize.width *0.04),
                        child: Text(
                          "24h Chg%",
                          style: TextStyle(
                              fontSize: 10,
                              color:day==false?Colors.white54:Colors.black54,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0.0,
            ),

            ///
            ///
            /// check the condition if image data from server firebase loaded or no
            /// if image loaded true (image still downloading from server)
            /// Card to set card loading animation
            ///
            Currency_data['$CurrencyName'].length > 0 ?_dataLoaded(context):Container(child: Text("Server Issue "),),
          ],
        ));
  }

  Widget _dataLoaded(BuildContext context) {
    return StreamBuilder(
        stream: channel_usdt.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && firsttimegainer==0) {
            return Currency_data['$CurrencyName'].length >0?Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_data['$CurrencyName'].length,
                itemBuilder: (ctx, i) {
                  return carddata(ctx, i);
                },
              ),
            ):Container(child: Text("Server Issue "),);
          }

          else if (snapshot.hasError) {
            return Currency_data['$CurrencyName'].length >0?Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_data['$CurrencyName'].length,
                itemBuilder: (ctx, i) {
                  return carddata(ctx, i);
                },
              ),
            ):Container(child: Text("Server Issue "),);
          } else if (snapshot.connectionState == ConnectionState.active) {
            //place your code here. It will prevent double data call.
            item = json.decode(snapshot.hasData ? snapshot.data : '');
             firsttimegainer=1;
            return  Currency_data['$CurrencyName'].length >0?Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_data['$CurrencyName'].length,
                itemBuilder: (ctx, i) {
                  return card(ctx, i);
                },
              ),
            ):Container(child: Text("Server Issue "),);
          }
          return  Currency_data['$CurrencyName'].length >0?Container(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: Currency_data['$CurrencyName'].length,
              itemBuilder: (ctx, i) {
                return carddata(ctx, i);
              },
            ),
          ):Container(child: Text("Server Issue "),);

        });
  }

  var current_price;
  var last_price;
  var chg_24;
  Widget card(BuildContext ctx, int i) {
    Status = 'E';

    if (Currency_data['$CurrencyName'].keys.elementAt(i) == item['s']) {
      print(item);
      print(item['s']);
      print(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][2]['icon'].toString());
      Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][3]['currentprice'] =item['c'];
      if(double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][3]['currentprice'].toString())==double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][4]['lastprice'].toString())){
        Status='E';
        print("E");
      }else if(double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][3]['currentprice'].toString())>double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][4]['lastprice'].toString())){

        Status='G';
        print("G");
      }else{
        Status='S';
        print("S");
      }

      Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][4]['lastprice'] =item['c'];
      Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg'] = item['P'];

      // print(Currency_data['$CurrencyName'][i][item['s']]);

    }

    return double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
        .toString())>0.0?Padding(
          padding: const EdgeInsets.only(
              right: 3.0, left: 3.0, top: 8.0, bottom:8.0),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    listed=Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][6]['listed'].toString();
                    selectedPair=Currency_data['$CurrencyName'].keys.elementAt(i).toString().split('$CurrencyName')[0].toString()+"USDT";});
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
                      "USDT");
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
                      "USDT");
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
                        familycoin: "USDT",
                      )));

                },
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                child:
                                Currency_data['$CurrencyName'][
                                Currency_data['$CurrencyName']
                                    .keys
                                    .elementAt(i)][2]['icon']!=null? Image.network(
                                  Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][2]['icon']
                                      .toString(),
                                  height: 22.0,
                                  fit: BoxFit.contain,
                                  width: 22.0,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset("assets/image/usdt.png", height: 22.0,
                                        fit: BoxFit.contain,
                                        width: 22.0,),
                                ): Image.asset("assets/image/usdt.png", height: 22.0,
                                  fit: BoxFit.contain,
                                  width: 22.0,)
                            ),
                            Container(
                              width: 100.0,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][1]['pair']
                                        .toString().split(' ')[0],
                                    style: TextStyle(
                                        fontFamily: "IBM Plex Sans", fontSize: 14.5,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  Text(' / USDT',   style: TextStyle(
                                    fontFamily: "IBM Plex Sans", fontSize: 10.5,color: day==false?Colors.white:Colors.black,),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
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
                        SizedBox(width: 25,),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(num.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][3]['currentprice']
                                      .toString()).toString(),
                                    style: TextStyle(
                                        color: Status=='E'?day==false?Colors.white:Colors.black:Status=="G"? Color(0xFF00C087):Colors.redAccent,
                                        fontFamily: "IBM Plex Sans",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  )


                                ],
                              ),


                        ),
                        SizedBox(width:3,height: 20,child: VerticalDivider(color: day==false?Colors.white60:Colors.black45)),

                        Text(
                          Cr.format(double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
                              .toString())) +
                              "%",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
                                  .toString())<
                                  0
                                  ? Colors.redAccent
                                  : Color(0xFF00C087)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ):Column();
  }
  Widget carddata(BuildContext ctx, int i) {

    return double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
        .toString())>0.0?Padding(
          padding: const EdgeInsets.only(
              right: 3.0, left: 3.0, top: 8.0, bottom:8.0),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    listed=Currency_data['$CurrencyName']
                    [Currency_data['$CurrencyName'].keys.elementAt(i)][6]
                    ['listed']
                        .toString();
                    selectedPair=Currency_data['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString()+"USDT";
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
                      "USDT");
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
                      "USDT");

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
                        familycoin: "USDT",
                      )));
                  // Navigator.of(ctx).push(PageRouteBuilder(
                  //     pageBuilder: (_, __, ___) => new btcDetail(
                  //       currency_data: Currency_data['$CurrencyName'][
                  //       Currency_data['$CurrencyName']
                  //           .keys
                  //           .elementAt(i)][0]
                  //       ,
                  //       pair: Currency_data['$CurrencyName']
                  //           .keys
                  //           .elementAt(i)
                  //           .toString()
                  //           .split('$CurrencyName')[0]
                  //           .toString(),
                  //       familycoin: "USDT",
                  //     )));
                },
                child:IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                                child:
                                Currency_data['$CurrencyName'][
                                Currency_data['$CurrencyName']
                                    .keys
                                    .elementAt(i)][2]['icon']!=null? Image.network(
                                  Currency_data['$CurrencyName'][
                                  Currency_data['$CurrencyName']
                                      .keys
                                      .elementAt(i)][2]['icon']
                                      .toString(),
                                  height: 22.0,
                                  fit: BoxFit.contain,
                                  width: 22.0,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset("assets/image/usdt.png", height: 22.0,
                                        fit: BoxFit.contain,
                                        width: 22.0,),
                                ): Image.asset("assets/image/usdt.png", height: 22.0,
                                  fit: BoxFit.contain,
                                  width: 22.0,)
                            ),
                            Container(
                              width: 100.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][1]['pair']
                                            .toString().split(' ')[0],
                                        style: TextStyle(
                                            fontFamily: "IBM Plex Sans", fontSize: 14.5,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.w600),
                                      ),
                                      Text(' / USDT',   style: TextStyle(
                                        fontFamily: "IBM Plex Sans", fontSize: 10.5,color: day==false?Colors.white:Colors.black,),),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
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
                        SizedBox(width: 25,),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child:
                          Text(num.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][3]['currentprice']
                              .toString()).toString(),
                            style: TextStyle(
                                color: Status=='E'?day==false?Colors.white:Colors.black:Status=="G"? Color(0xFF00C087):Colors.redAccent,
                                fontFamily: "IBM Plex Sans",
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),


                        ),
                        SizedBox(width:3,height: 20,child: VerticalDivider(color: day==false?Colors.white60:Colors.black45)),

                        Text(
                          Cr.format(double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
                              .toString())) +
                              "%",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: double.parse(Currency_data['$CurrencyName'][Currency_data['$CurrencyName'].keys.elementAt(i)][5]['24chg']
                                  .toString())<
                                  0
                                  ? Colors.redAccent
                                  : Color(0xFF00C087)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ):Column();
  }
}


Widget loadingCard(BuildContext ctx, int i) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(ctx).hintColor,
                        radius: 13.0,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 15.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(ctx).hintColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 12.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                                color: Theme.of(ctx).hintColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 15.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Theme.of(ctx).hintColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          height: 12.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              color: Theme.of(ctx).hintColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 25.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                      color: Theme.of(ctx).hintColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(color: Colors.white12),
            ),
          )
        ],
      ),
    ),
  );
}

///
///
/// Calling ImageLoaded animation for set a grid layout
///
///
