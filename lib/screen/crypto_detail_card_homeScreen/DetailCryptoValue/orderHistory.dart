// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names, unused_import, missing_return

import 'dart:convert';


import 'package:exchange/component/CardDetail/orderHistory.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../config/APIClasses.dart';
// String symbolcheck='btcusdt';
class orderHistory extends StatefulWidget {
  final Widget child;
  String symbol;
  String familyicon;
  String pairicon;
  double rate;
  String listed;
  orderHistory({Key key, this.child,this.symbol,this.familyicon,this.pairicon,this.rate,this.listed}) : super(key: key);

  _orderHistoryState createState() => _orderHistoryState(listedCoin:listed);
}

class _orderHistoryState extends State<orderHistory> {

  String listedCoin="";

  ScrollController _scrollController = new ScrollController();

  _orderHistoryState({this.listedCoin});

  @override
  void initState() {
    // OrdersHistory();
    // symbolcheck= widget.symbol;
    connectToServer();
    super.initState();
  }





  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  var item;
  WebSocketChannel channel_usdt =IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );
  WebSocketChannel channel_usdtOwn =IOWebSocketChannel.connect(
    Uri.parse(APIClasses.websocket_url),
  );

  Future<void> connectToServer() {
    print("SYM "+widget.familyicon.toString());
    var jsonString;
    if(widget.familyicon=="INR"){
      listedCoin=='true'?
      jsonString= json.encode({
        'method': "ADD",
        'params': [
          widget.symbol.toLowerCase()+'usdt@trade',
        ],
        'id': 3,
      }) :jsonString= json.encode({
        'method': "SUBSCRIBE",
        'params': [
          widget.symbol.toLowerCase()+'usdt@trade',
        ],
        'id': 3,
      });
      print("SYM "+jsonString.toString());
    }else{
      listedCoin=='true'?
      jsonString = json.encode({
        'method': "ADD",
        'params': [
          widget.pairicon.toLowerCase()+'@trade',
        ],
        'id': 3,
      }) : jsonString = json.encode({
        'method': "SUBSCRIBE",
        'params': [
          widget.pairicon.toLowerCase()+'@trade',
        ],
        'id': 3,
      });
      print("nor"+jsonString.toString());
    }

    listedCoin=='true'?channel_usdtOwn.sink.add(jsonString):channel_usdt.sink.add(jsonString);

  }






  // var subRequest_usdt = {
  //   "method": "SUBSCRIBE",
  //   "params": ["$symbolcheck@trade"],
  //   "id": 1
  // };

  @override
  void dispose() {
    channel_usdt.sink.close();
    channel_usdtOwn.sink.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var Screensize=MediaQuery.of(context).size;

    return  Container(
      color:  Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            //Divider(color:  day==false?Colors.white38:Colors.black45,),
            Container(
              color: Colors.transparent,
              // color: Theme.of(context).canvasColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7.0,top: 5,left:0,right:0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:EdgeInsets.only(left: Screensize.width*0.03),
                      child: Text(
                        "Time",
                        style: TextStyle(
                            fontSize: 12,
                            color: day==false?Colors.white:Colors.black,
                            fontFamily: "IBM Plex Sans"),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(left: Screensize.width*0.18),
                      child: Text(
                        "Type",
                        style: TextStyle(
                            fontSize: 12,
                            color: day==false?Colors.white:Colors.black, fontFamily: "IBM Plex Sans"),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(left: Screensize.width*0.18),
                      child: Text(
                        "Price",
                        style: TextStyle(
                            fontSize: 12,
                            color: day==false?Colors.white:Colors.black,
                            fontFamily: "IBM Plex Sans"),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(left: Screensize.width*0.18),
                      child: Text(
                        "Amount",
                        style: TextStyle(
                            fontSize: 12,
                            color: day==false?Colors.white:Colors.black,
                            fontFamily: "IBM Plex Sans"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            StreamBuilder(
                stream: listedCoin=='true'?channel_usdtOwn.stream:channel_usdt.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Container(
                        // height: 350.0,
                          child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              primary: false,reverse: true,
                              itemCount: listorderHistoryModel.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return _orderHistory(listorderHistoryModel[i]);
                              }
                          )),
                    );
                  }

                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        //  height: 350.0,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              shrinkWrap: true,
                              primary: false,reverse: true,
                              itemCount: listorderHistoryModel.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return _orderHistory(listorderHistoryModel[i]);
                              }
                          )),
                    );
                  }
                  else if (snapshot.connectionState == ConnectionState.active) {
                    //place your code here. It will prevent double data call.
                    item = json.decode(snapshot.hasData ? snapshot.data : '');
                    // firsttimetradehistory=1;
                    print("order history"+item.toString());
                    if(item.length>0) {
                      listorderHistoryModel.add(orderHistoryModel(
                          date: item['T']==null?"":new DateTime.fromMillisecondsSinceEpoch(item['T']).toString().split(' ')[1],
                          type: item['m']==true?"Sell":"Buy",
                          price: item['p']==null?"":double.parse(item['p'].toString()).toString(),
                          amount:  item['q']==null?"": item['q'].toString()));
                      return  Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          //  height: 350.0,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                controller: _scrollController,
                                shrinkWrap: true,
                                primary: false,reverse: true,
                                itemCount: listorderHistoryModel.length,
                                itemBuilder: (BuildContext ctx, int i) {
                                  return _orderHistory(listorderHistoryModel[i]);
                                }
                            )),
                      );
                    }
                  }
                  return  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      //  height: 350.0,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            shrinkWrap: true,
                            primary: false,reverse: true,
                            itemCount: listorderHistoryModel.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _orderHistory(listorderHistoryModel[i]);
                            }
                        )),
                  );
                }
            ),
          ],
        ),
      ),
    );

  }

  Widget _orderHistory(orderHistoryModel item) {

    var Screensize=MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return item.date!=""?SingleChildScrollView(
      child: Container(
        color:item.type=="Buy"?Colors.green.withOpacity(0.2): Colors.redAccent.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:  EdgeInsets.only(left: Screensize.width*0.01),
                  child: Container(
                    width:Screensize.width*0.25,
                    child: Text(
                      item.date==null?"00:00:00":item.date.toString().split('.')[0],
                      style: TextStyle(
                          color: day==false?Colors.white:Colors.black,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 12.0),
                    ),
                  ),
                ),
                Container(
                  width:Screensize.width*0.23,
                  child: Text(
                    item.type,
                    style: TextStyle(
                        fontFamily: "IBM Plex Sans", fontSize: 12.0, color: item.type=='Buy'?Colors.green[600]:Colors.redAccent),
                  ),
                ),
                Container(
                  width:Screensize.width*0.25,
                  child: Text(
                    item.price,
                    style: TextStyle(
                        color:day==false?Colors.white:Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: "IBM Plex Sans",
                        fontSize: 11.0),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(right: Screensize.width*0.0),
                  child: Container(
                    width:Screensize.width*0.2,
                    child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                      child: Text(
                          double.parse(item.amount.toString()).toStringAsFixed(5),
                        style: TextStyle(
                            color: day==false?Colors.white:Colors.black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "IBM Plex Sans",
                            fontSize: 11.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ):
    Container(height: 0.2);
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
}
