// ignore_for_file: non_constant_identifier_names, missing_return

import 'dart:convert';

import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'detailCrypto/btcDetail.dart';

class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isblink = false;
  Map<dynamic,Map<dynamic,List<Map<String,dynamic>>>> contactsearch=new Map();

  String Status = 'E';
  String CurrencyName;
  var item;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/a.jpg?alt=media&token=e36bbee2-4bfb-4a94-bd53-4055d29358e2");
  static NumberFormat Cr = new NumberFormat("#,##0.00", "en_US");
  bool loadImage = false;
  Map<dynamic,List<Map<String,dynamic>>> searchmap=Map();
  @override
  void initState() {


    connectToServer();

    super.initState();
  }

  var data;

  WebSocketChannel channel_btc = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );

  Future<void> connectToServer() {
    var jsonString = json.encode(subRequest_btc);
    channel_btc.sink.add(jsonString);
  }
  @override
  void dispose() {
    channel_btc.sink.close();
    Currency_dataold.clear();
    Currency_dataold.addAll(Currency_datasearch);
    firsttimesearch=0;
    firsttimebtc=0;
    firsttimegainer=0;
    firsttimeloser=0;
    print("btcpage2");
    super.dispose();
  }
  onSearchTextChanged(String text) async {
    print("check search data"+text);
    Currency_dataold.clear();
    if (text.isEmpty) {
      setState(() {
        Currency_dataold.addAll(Currency_datasearch);
      });
      return;
    }

    setState(() {
      print("currencykey-----"+Currency_datasearch.keys.toString());
      Currency_dataold.clear();
      for(int i=0;i<marketfamily.length;i++)
        if(marketfamily[i].toString()!="FAV") {
          for (int j = 0; j < Currency_datasearch[marketfamily[i].toString()].length; j++) {
            currency_pair123.clear();
            if(Currency_datasearch[marketfamily[i]][Currency_datasearch[marketfamily[i]]
                .keys.elementAt(j)][0]['currency_name'].contains(text.toUpperCase())){
              setState(() {
                currency_pair123.putIfAbsent(Currency_datasearch[marketfamily[i]]
                    .keys.elementAt(j), () =>Currency_datasearch[marketfamily[i]][Currency_datasearch[marketfamily[i]]
                    .keys.elementAt(j)]);
                print("P a i r ? "+currency_pair123.toString());
                Currency_dataold.putIfAbsent(marketfamily[i].toString(), () => new Map.from(currency_pair123));
              });
            }
          }
        }
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: day==false?Colors.black:Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,left: 15,right: 15),
            child: Card(
              color: day==false?Colors.white12:Colors.white,
              child: TextField(style: TextStyle(
                color: day==false?Colors.white : Colors.black,
              ),
                onChanged: onSearchTextChanged,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: day==false?Colors.grey[900] : Colors.white60,
                    hintText: 'Search Coin...',
                    hintStyle: TextStyle(
                      color: day==false?Colors.white60:Colors.black54,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: day==false?Colors.white:Colors.black,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: day==false?Colors.transparent:Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0,top: 0),
                    child:   Row(
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
                              padding:  EdgeInsets.only(left:screenSize.width *0.03),
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
                  Expanded(child: _dataLoaded(context)),

                ],
              ),
            ),
          ),
        ],
      ));
  }



  Widget _dataLoaded(BuildContext context) {
    return StreamBuilder(
        stream: channel_btc.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingData(context);
          }
          else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.active) {
            //place your code here. It will prevent double data call.
            item = json.decode(snapshot.hasData ? snapshot.data : '');
            print("check iktem data ???" + item.toString());
            return Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_dataold.keys.length,
                itemBuilder: (ctx, i) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: Currency_dataold[Currency_dataold.keys.elementAt(i)].length,
                    itemBuilder: (ctx, j) {
                      return card(ctx, j,Currency_dataold.keys.elementAt(i).toString());
                    },
                  );
                },
              ),
            );
          }
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: Currency_dataold.keys.length,
              itemBuilder: (ctx, i) {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: Currency_dataold[Currency_dataold.keys.elementAt(i)].length,
                  itemBuilder: (ctx, j) {
                    return carddata(ctx, j);
                  },
                );
              },
            ),
          );
        });
  }

  Widget carddata(BuildContext ctx, int i) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding:  EdgeInsets.only(
          right: screenSize.width *0.01, left: screenSize.width *0.01, bottom: 8.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                listed=Currency_dataold['$CurrencyName']
                [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
                ['listed']
                    .toString();
                selectedPair=Currency_dataold['$CurrencyName']
                    .keys
                    .elementAt(i)
                    .toString()
                    .split('$CurrencyName')[0]
                    .toString()+CurrencyName.toString();
              });
              open_order(Currency_dataold['$CurrencyName']
              [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
              ['listed']
                  .toString(),Currency_dataold['$CurrencyName']
                  .keys
                  .elementAt(i)
                  .toString()
                  .split('$CurrencyName')[0]
                  .toString().toUpperCase(),CurrencyName.toString().toUpperCase());
              OrdersHistory(Currency_dataold['$CurrencyName']
              [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
              ['listed']
                  .toString(),Currency_dataold['$CurrencyName']
                  .keys
                  .elementAt(i)
                  .toString()
                  .split('$CurrencyName')[0]
                  .toString().toUpperCase(),CurrencyName.toString().toUpperCase());
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new btcDetail(
                    currency_data: {"currency_name":Currency_dataold['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString(), "PRICE":  num.parse(Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][3]['currentprice']
                        .toString()).toString(),
                      "HIGHDAY": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][10]['high']
                          .toString(),
                      "LOWDAY": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][9]['low']
                          .toString(), "24chg": "0.0","listed":Currency_dataold['$CurrencyName']
                      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
                      ['listed']
                          .toString(),
                      "decimal_currency":
                      Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][7]
                      ['decimal_currency']
                          .toString(),
                      "decimal_pair": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][8]['decimal_pair']
                          .toString()

                    },
                    pair: Currency_dataold['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString(),
                    familycoin: CurrencyName.toString(),
                  )));
            },
            child:  IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(top: 0,bottom: 8,right: screenSize.width *0.03),
                    child: Row(
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
                          width: 95.0,
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
                                  Text(' / '+CurrencyName.toString(),  style: TextStyle(
                                    fontFamily: "IBM Plex Sans", fontSize: 10.5,color: day==false?Colors.white:Colors.black,),),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
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
                  Spacer(),
                  Padding(
                    padding:  EdgeInsets.only(right: screenSize.width *0.04),
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
                  Padding(
                    padding:  EdgeInsets.only(right: screenSize.width *0.03),
                    child: SizedBox(width:3,height: 20,child: VerticalDivider(color: day==false?Colors.white60:Colors.black45,)),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: screenSize.width *0.01),
                    child: Text(
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
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget card(BuildContext ctx, int i, String CurrencyName) {
    final screenSize = MediaQuery.of(context).size;

    Status = 'E';
    if (Currency_dataold['$CurrencyName'].keys.elementAt(i) == item['s']) {
      Currency_dataold['$CurrencyName']
      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][3]
      ['currentprice'] = item['c'];
      if (double.parse(Currency_dataold['$CurrencyName']
      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][3]
      ['currentprice']
          .toString()) ==
          double.parse(Currency_dataold['$CurrencyName']
          [Currency_dataold['$CurrencyName'].keys.elementAt(i)][4]
          ['lastprice']
              .toString())) {
        Status = 'E';
      } else if (double.parse(Currency_dataold['$CurrencyName']
      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][3]
      ['currentprice']
          .toString()) >
          double.parse(Currency_dataold['$CurrencyName']
          [Currency_dataold['$CurrencyName'].keys.elementAt(i)][4]
          ['lastprice']
              .toString())) {
        Status = 'G';
      } else {
        Status = 'S';
      }
      //
      Currency_dataold['$CurrencyName']
      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][4]
      ['lastprice'] = item['c'];
      // Currency_data['$CurrencyName']
      // [Currency_data['$CurrencyName'].keys.elementAt(i)][6]
      // ['vol'] = mainmethod(double.parse(item['q']));

      Currency_dataold['$CurrencyName']
      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][5]['24chg'] =
      item['P'];
    }
      return Padding(
      padding:  EdgeInsets.only(
          right: screenSize.width *0.01, left: screenSize.width *0.01, bottom: 8.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                listed=Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]['listed'].toString();
                selectedPair=Currency_dataold['$CurrencyName'].keys.elementAt(i).toString().split('$CurrencyName')[0].toString()+CurrencyName.toString();});
              open_order(Currency_dataold['$CurrencyName']
              [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
              ['listed']
                  .toString(),Currency_dataold['$CurrencyName']
                  .keys
                  .elementAt(i)
                  .toString()
                  .split('$CurrencyName')[0]
                  .toString().toUpperCase(),CurrencyName.toString().toUpperCase());
              OrdersHistory(Currency_dataold['$CurrencyName']
              [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
              ['listed']
                  .toString(),Currency_dataold['$CurrencyName']
                  .keys
                  .elementAt(i)
                  .toString()
                  .split('$CurrencyName')[0]
                  .toString().toUpperCase(),CurrencyName.toString().toUpperCase());
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new btcDetail(

                    currency_data: Currency_dataold['$CurrencyName'][
                    Currency_dataold['$CurrencyName'].keys.elementAt(i)][3].containsKey("currentprice")? {
                      "currency_name": Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)
                          .toString()
                          .split('$CurrencyName')[0]
                          .toString(), "PRICE": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][3]['currentprice'].toString(),   "HIGHDAY": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][10]['high']
                          .toString(),
                      "LOWDAY": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][9]['low']
                          .toString(),"24chg": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][5]['24chg'].toString(),"listed":Currency_dataold['$CurrencyName']
                      [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
                      ['listed']
                          .toString(), "decimal_currency":
                      Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][7]
                      ['decimal_currency']
                          .toString(),
                      "decimal_pair": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][8]['decimal_pair']
                          .toString()}:
                    {"currency_name": Currency_dataold['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString(), "PRICE": "0.0", "HIGHDAY":"0.0", "LOWDAY": "0.0","24chg": "0.0","listed":Currency_dataold['$CurrencyName']
                    [Currency_dataold['$CurrencyName'].keys.elementAt(i)][6]
                    ['listed']
                        .toString(),
                      "decimal_currency":
                      Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][7]
                      ['decimal_currency']
                          .toString(),
                      "decimal_pair": Currency_dataold['$CurrencyName'][
                      Currency_dataold['$CurrencyName']
                          .keys
                          .elementAt(i)][8]['decimal_pair']
                          .toString()},
                    pair: Currency_dataold['$CurrencyName']
                        .keys
                        .elementAt(i)
                        .toString()
                        .split('$CurrencyName')[0]
                        .toString(),
                    familycoin: CurrencyName.toString(),
                  )));
            },
            child:  IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(top:0,bottom: 8,right: screenSize.width *0.03),
                    child: Row(
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
                          width: 95.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][1]['pair']
                                        .toString().split(' ')[0],
                                    style: TextStyle(
                                        fontFamily: "IBM Plex Sans", fontSize: 14.5,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.w600),
                                  ),
                                  Text(' / '+CurrencyName.toString(),  style: TextStyle(
                                    fontFamily: "IBM Plex Sans", fontSize: 10.5,color: day==false?Colors.white:Colors.black,),),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  double.parse(Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][5]['24chg']
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
                    padding:  EdgeInsets.only(right: screenSize.width *0.04),
                    child:
                    Text(num.parse(Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][3]['currentprice']
                        .toString()).toString(),
                      style: TextStyle(
                          color: Status=='E'?day==false?Colors.white:Colors.black:Status=="G"? Color(0xFF00C087):Colors.redAccent,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),


                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: screenSize.width *0.03),
                    child: SizedBox(width:3,height: 20,child: VerticalDivider(color: day==false?Colors.white60:Colors.black45,)),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: screenSize.width *0.01),
                    child: Text(
                      Cr.format(double.parse(Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][5]['24chg']
                          .toString())) +
                          "%",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: double.parse(Currency_dataold['$CurrencyName'][Currency_dataold['$CurrencyName'].keys.elementAt(i)][5]['24chg']
                              .toString())<
                              0
                              ? Colors.redAccent
                              : Color(0xFF00C087)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
Widget _loadingData(BuildContext context) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 20,
      itemBuilder: (ctx, i) {
        return
          //_data!=null?savedCard(ctx, i):
          loadingCard(ctx, i);
      },
    ),
  );
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
