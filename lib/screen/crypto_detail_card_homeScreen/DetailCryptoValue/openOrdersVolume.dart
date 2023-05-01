// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, missing_return

import 'dart:convert';
import 'dart:math';


import 'package:exchange/component/CardDetail/AmountSell.dart';
import 'package:exchange/component/CardDetail/BuyAmount.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../config/APIClasses.dart';

String SYMBOL = "";

class openOrdersVolume extends StatefulWidget {
  final Widget child;
  String symbol;
  String familyicon;
  String pairicon;
  String listed;
  double rate;
  openOrdersVolume({Key key, this.child,this.symbol,this.familyicon,this.pairicon,this.listed,this.rate}) : super(key: key);

  _openOrdersVolumeState createState() => _openOrdersVolumeState();
}

class _openOrdersVolumeState extends State<openOrdersVolume> {
  List OrderVol=[];

  static NumberFormat Cr = new NumberFormat("###0.0000", "en_US");
  static NumberFormat Crone = new NumberFormat("###0.0", "en_US");


  @override
  void initState() {
    if (widget.symbol.contains('ξ')) {
      widget.symbol = 'ETH';
      SYMBOL = widget.symbol.toLowerCase();
    } else {
      SYMBOL = widget.symbol.toLowerCase();
      print("check syu 2 " + SYMBOL.toString());
    }
    connectToServer();

    print(widget.listed+SYMBOL+widget.familyicon)   ;

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }


  var item;
  WebSocketChannel channel_usdt = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );
  WebSocketChannel channel_usdtOwn =IOWebSocketChannel.connect(
    Uri.parse(APIClasses.websocket_url),
  );


  Future<void> connectToServer() {
    var jsonString;
    if(widget.familyicon=="INR"){
      widget.listed=='true'?
      jsonString= json.encode({
        'method': "ADD",
        'params': [
          widget.symbol.toLowerCase()+'usdt@depth',
        ],
        'id': 3,
      }) :
      jsonString= json.encode({
        'method': "SUBSCRIBE",
        'params': [
          widget.symbol.toLowerCase()+'usdt@depth20@1000ms',
        ],
        'id': 3,
      });
      print("jsjhs"+jsonString.toString());
    }else{
      widget.listed=='true'?
      jsonString = json.encode({
        'method': "ADD",
        'params': [
          widget.pairicon.toLowerCase()+'@depth@1000ms',
        ],
        'id': 3,
      }) : jsonString = json.encode({
        'method': "SUBSCRIBE",
        'params': [
          widget.pairicon.toLowerCase()+'@depth20@1000ms',
        ],
        'id': 3,
      });
      print("MPOT"+jsonString.toString());
    }

    widget.listed=='true'?channel_usdtOwn.sink.add(jsonString):channel_usdt.sink.add(jsonString);

  }

  @override
  void dispose() {
    // firsttimeordervol = 0;
    channel_usdt.sink.close();
    channel_usdtOwn.sink.close();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    double mediaQuery = MediaQuery
        .of(context)
        .size
        .width / 2.2;
    var size = MediaQuery
        .of(context)
        .size;
    return Container(
      color:Colors.transparent,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Divider(color:  day==false?Colors.white38:Colors.black45,),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, bottom: 7.0,top: 5),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          "Buy Amount",
                          style: TextStyle(
                              color:day==false?Colors.white:Colors.black,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                      Text(
                        "Price",
                        style: TextStyle(
                            color: day==false?Colors.white:Colors.black, fontFamily: "IBM Plex Sans"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Amount Sell",
                          style: TextStyle(
                              color:day==false?Colors.white:Colors.black,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
             StreamBuilder(
                stream: widget.listed=='true'?channel_usdtOwn.stream:channel_usdt.stream,
                builder: (context, snapshot) {
                  print("CHECK CHECKKK  "+snapshot.data.toString());

                  if (snapshot.connectionState == ConnectionState.waiting  ) {
                    print("check ckecl weaitin");
                    return anotherbuYlist.length>0 || othersellList.length>0 ?Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          // height: 300.0,
                            width: mediaQuery,
                            child:ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: anotherbuYlist.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return _buyAmount(mediaQuery, anotherbuYlist[i]);
                              },
                            )
                        ),
                        SizedBox(width: 5,),
                        Container(
                          //height: 300.0,
                            width: mediaQuery,
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: othersellList.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return _amountSell(mediaQuery, othersellList[i]);
                              },
                            )
                        )
                      ],):_loadingData(context);
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  if (snapshot.connectionState == ConnectionState.active && !snapshot.data.toString().contains("result") && snapshot.data.toString().contains("lastUpdateId")) {
                    firsttimeordervol=1;
                    item = json.decode(snapshot.hasData ? snapshot.data : '');
                    print("=-=-=-"+item['bids'].length.toString());
                    print("=-=-=-"+item['asks'].length.toString());
                    anotherbuYlist.clear();
                    othersellList.clear();
                    List<double> buys=[];
                    List<double> asks=[];

                    if(item.length>0) {
                      double large_value = 0.0;
                      //try {
//buy
                      for (int i = 0; i < item['bids'].length; i++) {
                        anotherbuYlist.add(buyAmount(
                          price: Cr.format(double.parse(item['bids'][i][0].toString())).toString(),
                          value:  Cr.format(double.parse(item['bids'][i][1].toString()))
                              .toString()
                        ));
                        othersellList.add(amountSell(
                          price: Cr.format(double.parse(item['asks'][i][0].toString()))
                              .toString(),
                          value: Cr.format(double.parse(item['asks'][i][1].toString()))
                              .toString()
                        ));
                        // anotherbuYlist[i].price =
                        //     Cr.format(double.parse(item['bids'][i][0].toString())).toString();
                        // anotherbuYlist[i].value =
                        //     Cr.format(double.parse(item['bids'][i][1].toString()))
                        //         .toString();
                        // othersellList[i].price =
                        //     Cr.format(double.parse(item['asks'][i][0].toString()))
                        //         .toString();
                        // othersellList[i].value =
                        //     Cr.format(double.parse(item['asks'][i][1].toString()))
                        //         .toString();

                        buys.add(double.parse(item['bids'][i][1]));
                        asks.add(double.parse(item['asks'][i][1]));
                        large_value =
                        buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);
                        anotherbuYlist[i].percent =
                            Cr.format(double.parse(anotherbuYlist[i].value) / large_value)
                                .toString();
                        othersellList[i].percent =
                            Cr.format(double.parse(othersellList[i].value) / large_value)
                                .toString();
                      }
                    }
                    return anotherbuYlist.length>0 || othersellList.length>0 ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          // height: 300.0,
                          width: mediaQuery,
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount:  anotherbuYlist.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _buyAmount(mediaQuery, anotherbuYlist[i]);
                            },
                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          // height: 300.0,
                          width: mediaQuery,
                          child: othersellList.length>0? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: othersellList.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              print("checklength"+othersellList.length.toString());
                              return _amountSell(mediaQuery, othersellList[i]);
                            },
                          ):Text(""),
                        ),
                      ],):Center(
                  child: Padding(
                  padding:  EdgeInsets.only(top: size.height*0.3),
                  child: Text("No orders get placed yet..."),
                  ),
                  );
                  }
                  return anotherbuYlist.length>0 || othersellList.length>0 ?Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Container(
                        // height: 300.0,
                        width: mediaQuery,
                        child:ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: anotherbuYlist.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            return _buyAmount(mediaQuery, anotherbuYlist[i]);
                          },
                        )
                      ),
                      SizedBox(width: 5,),
                      Container(
                        //height: 300.0,
                        width: mediaQuery,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: othersellList.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            return _amountSell(mediaQuery, othersellList[i]);
                          },
                        )
                      )
                    ],):Center(
                    child: Padding(
                      padding:  EdgeInsets.only(top: size.height*0.3),
                      child: Text("No orders get placed yet..."),
                    ),
                  );
                })



          ]),
    );
  }
  Widget _buyAmount(double _width, buyAmount item) {

    print("checkpercent"+item.percent.toString());
    print("checkvalue"+item.value.toString());
    print("checknumber"+item.number.toString());
    print("checkprice"+item.price.toString());

    double price=double.parse(item.price)*widget.rate;

    return Padding(
      padding: const EdgeInsets.only(left:00,bottom: 0.0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              color: Colors.green.withOpacity(0.2),
              width: _width* double.parse(Crone.format(double.parse(item.percent))), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
              height: 25,
            ),
          ),
          Container(
            width: _width,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  item.value.toString(),
                  style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 12.0,color: day==false?Colors.white:Colors.black,),
                ),
                Text(
                  widget.familyicon=="INR"? Cr.format(price).toString():item.price.toString(),
                  style: TextStyle(
                      color: Colors.green[600],
                      fontWeight: FontWeight.w700,
                      fontFamily: "IBM Plex Sans",
                      fontSize: 12.0),
                ),
              ],),
          ),

        ],
      ),
    );
  }

  Widget _amountSell(double _width, amountSell item) {
    double price=double.parse(item.price)*widget.rate;

    return Padding(
      padding: const EdgeInsets.only(right:00,bottom: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: _width,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.familyicon=="INR"? Cr.format(price).toString():item.price.toString(),
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      fontFamily: "IBM Plex Sans",
                      fontSize: 12.0),
                ),
                Text(
                  item.value.toString(),
                  style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 12.0,color: day==false?Colors.white:Colors.black),
                ),

              ],),
          ),
          Container(
            color: Colors.redAccent.withOpacity(0.2),
            width: _width*double.parse(Crone.format(double.parse(item.percent))), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
            height: 25,
          ),
        ],
      ),
    );
  }
  Widget _loadingData(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 12,
        itemBuilder: (ctx, i) {
          return loadingCard(ctx, i);
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
                      Container(
                        height: 15.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(ctx)
                                .hintColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                      ),
                      SizedBox(width: 15,),

                      Container(
                        height: 15.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(ctx)
                                .hintColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 15.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(ctx)
                                .hintColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                      ),
                      SizedBox(width: 15,),

                      Container(
                        height: 15.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(ctx)
                                .hintColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                      ),

                    ],
                  ),
                ),


              ],
            ),

          ],
        ),
      ),
    );
  }
}
