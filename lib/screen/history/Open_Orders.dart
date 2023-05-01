// ignore_for_file: unused_field, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';
import 'Complete_Order.dart';

String param = '';

class RemainingopenOrders extends StatefulWidget {
  _RemainingopenOrdersState createState() => _RemainingopenOrdersState();
}

List remainingorder = [];
List remainingordernew = [];
bool isProgress = false;
int pagenumber = 1;
String status = 'false';

bool _isTrackProgress = false;
bool datafetch = false;

class _RemainingopenOrdersState extends State<RemainingopenOrders> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  List limit;
  List<Limit> _listlimit = Limit.getlimit();
  Limit selectedlimit;
  String SelectLimit;
  bool low = false;
  var item;
  String interval = "1m";
  String orderid = '';
  String withcurrency = '';
  String currency = '';

  var atpricecontroller = TextEditingController();
  var amountcontroller = TextEditingController();
  var totalcontroller = TextEditingController();

  @override
  void initState() {
    Wakelock.enable();

    log('open order1');
    // checkstatus();
    getremainingorder(pagenumber);
    log('open order = @@@@@@@@@@@@@@@@@@@@@@@@@@@@2');
    connectToServer(param);
    super.initState();
  }

  getremainingorder(int pagenumber) async {
    log('open order = @@@@@@@@@@@@@@@@@@@@@@@@@@@@3');
    final paramDic = {
      "type": 'remaining',
      "page": pagenumber.toString(),
      "per_page": '10',
    };
    var response =
        await APIMainClassbinance(APIClasses.OpenData, paramDic, "Get");

    print('open order ======================>>>>   ${response.body}');

    var data = json.decode(response.body);
    print('open order ======================>>>>   $data');

    remainingordernew.clear();

    if (pagenumber == 1) {
      remainingorder.clear();
    }
    if (response.statusCode == 200) {
      status = 'true';
      isProgress = true;
      _isTrackProgress = true;
      remainingordernew = data['data']['data'];
      remainingorder.addAll(remainingordernew);
      datafetch = true;
      print("remainingorder.lengt");
      print(remainingorder.toString());
      setState(() {});
    } else {
      status = 'true';
      pagenumber = pagenumber;
      isProgress = true;
      _isTrackProgress = true;
      datafetch = true;
    }
  }
  Future<void> CancelOrder(String orderid) async {
    final paramDic = {
      "": '',
    };
    var response = await APIMainClassbinance(
        APIClasses.cancelorder + orderid, paramDic, "Post");
    print(response);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      getcompletedata(pagenumber);
      ToastShowClass.toastShow(context, data['message'], Colors.blue);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) =>CompleteopenOrders()));
    } else {
      ToastShowClass.toastShow(context, data['message'], Colors.blue);
    }
  }

  var data;

  WebSocketChannel channel_btc = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );

  void connectToServer(String params) {
    param = params.toString();
    var jsonString = json.encode({
      'method': "SUBSCRIBE",
      'params': ["${param.toLowerCase()}@ticker"],
      'id': 1,
    });
    channel_btc.sink.add(jsonString);
    print(jsonString.toString());
  }

  @override
  void dispose() {
    channel_btc.sink.close();
    super.dispose();
  }

  void calcuate(String value) {
    totalcontroller.text = (double.parse(atpricecontroller.text.toString()) *
            double.parse(amountcontroller.text.toString()))
        .toString();
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white,),
            Text(" Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,), textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return status == 'true'
        ? Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: Stack(
              children: [
                remainingorder.length > 0
                    ? NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (_isTrackProgress &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              scrollInfo.metrics.axis == Axis.vertical) {
                            // start loading data
                            setState(() {
                              if (datafetch) {
                                pagenumber = pagenumber + 1;
                                getremainingorder(pagenumber);
                                _isTrackProgress = false;
                              } else {
                                getremainingorder(pagenumber);
                              }
                            });
                          }
                          return null;
                        },
                        child: isProgress
                            ? ListView.builder(
                                shrinkWrap: false,
                                primary: false,
                                itemCount: remainingorder.length,
                                itemBuilder: (BuildContext ctx, int i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  remainingorder[i]
                                                              ['order_type'] ==
                                                          null
                                                      ? ""
                                                      : remainingorder[i]
                                                              ['order_type']
                                                          .toString()
                                                          .toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: remainingorder[i][
                                                                  'order_type'] ==
                                                              "sell"
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Text(
                                                  remainingorder[i]
                                                              ['currency'] ==
                                                          null
                                                      ? ""
                                                      : remainingorder[i]
                                                              ['currency'] +
                                                          " / ",
                                                  style: TextStyle(
                                                      color: day == false
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontFamily:
                                                          "IBM Plex Sans",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  remainingorder[i][
                                                              'with_currency'] ==
                                                          null
                                                      ? ""
                                                      : remainingorder[i]
                                                          ['with_currency'],
                                                  style: TextStyle(
                                                      color: day == false
                                                          ? Colors.white54
                                                          : Colors.black54,
                                                      fontFamily:
                                                          "IBM Plex Sans",
                                                      fontSize: 12.0),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Spacer(),
                                                Text(
                                                  remainingorder[i]
                                                              ['created_at'] ==
                                                          null
                                                      ? ""
                                                      : DateFormat(
                                                              "dd MMM, hh:mm aa")
                                                          .format(DateTime.parse(
                                                                  remainingorder[
                                                                              i]
                                                                          [
                                                                          'created_at']
                                                                      .toString())
                                                              .toLocal()),
                                                  style: TextStyle(
                                                      color: day == false
                                                          ? Colors.white54
                                                          : Colors.black54,
                                                      fontFamily:
                                                          "IBM Plex Sans",
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Amount", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),),
                                                    Text("Price", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),
                                                    ),
                                                    Text("Total", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        remainingorder[i][
                                                                    'at_price'] ==
                                                                null
                                                            ? ""
                                                            : double.parse(
                                                                    remainingorder[
                                                                            i][
                                                                        'at_price'])
                                                                .toStringAsFixed(
                                                                    2)
                                                                .toString(),
                                                        style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans", fontSize: 12.0), textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        remainingorder[i][
                                                                    'quantity'] ==
                                                                null
                                                            ? ""
                                                            : remainingorder[i]
                                                                ['quantity'],
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.2,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            remainingorder[i][
                                                                        'total'] ==
                                                                    null
                                                                ? ""
                                                                : double.parse(
                                                                        remainingorder[i]
                                                                            [
                                                                            'total'])
                                                                    .toStringAsFixed(
                                                                        2),
                                                            style: TextStyle(
                                                                color: day ==
                                                                        false
                                                                    ? Colors
                                                                        .white54
                                                                    : Colors
                                                                        .black54,
                                                                fontFamily:
                                                                    "IBM Plex Sans",
                                                                fontSize: 12.0),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () async {
                                                      final bool res =
                                                          await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content: Text("Are you sure you want to delete ?"),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      child:
                                                                          Text("Cancel", style: TextStyle(color: Colors.white),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child:
                                                                          Text("Delete", style: TextStyle(color: Colors.red),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        print("ch " +
                                                                            remainingorder[i].toString());
                                                                        orderid =
                                                                            remainingorder[i]['id'].toString();

                                                                        ///cancel order
                                                                        CancelOrder(
                                                                            orderid);
                                                                        setState(
                                                                            () {
                                                                          remainingorder
                                                                              .remove(remainingorder[i]);
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                      return res;
                                                    },
                                                    child: Text("CANCEL", style: TextStyle(color: Colors.blue, fontFamily: "IBM Plex Sans", fontSize: 16, fontWeight: FontWeight.w500)))
                                              ],
                                            ),
                                            Container(
                                              width: 150,
                                              child: LinearPercentIndicator(
                                                lineHeight: 10.0,
                                                percent: remainingorder[i][
                                                            'current_status'] ==
                                                        'partially_completed'
                                                    ? ((double.parse(remainingorder[i]['quantity'] ?? 0) -
                                                            double.parse(
                                                                remainingorder[i][
                                                                        'pending_qty'] ??
                                                                    0)) /
                                                        double.parse(
                                                            remainingorder[i][
                                                                    'quantity'] ??
                                                                0))
                                                    : remainingorder[i]
                                                                ['current_status'] ==
                                                            'placed'
                                                        ? 0.0
                                                        : 1,
                                                center: Text(
                                                  remainingorder[i][
                                                              'current_status'] ==
                                                          'partially_completed'
                                                      ? '${((double.parse(remainingorder[i]['quantity'] ?? 0) - double.parse(remainingorder[i]['pending_qty'] ?? 0)) / double.parse(remainingorder[i]['quantity'] ?? 0) * 100).toStringAsFixed(0)}%'
                                                      : remainingorder[i][
                                                                  'current_status'] ==
                                                              'placed'
                                                          ? "0%"
                                                          : "100%",
                                                  style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600, color: Colors.black),
                                                ),
                                                linearStrokeCap:
                                                    LinearStrokeCap.roundAll,
                                                progressColor: remainingorder[i]
                                                            ['order_type'] ==
                                                        "sell"
                                                    ? Colors.red
                                                    : Colors.green,
                                                backgroundColor:
                                                    Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(color: day == false ? Colors.white38 : Colors.black38,),
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: Container(child: Text("No Data"),)))
                    : Center(
                        child: Container(
                        child: Text("No Open Orders! \n Let's Order Some Crypto !", style: TextStyle(color: day == false ? Colors.white : Colors.black),
                        ),
                      )),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: _isTrackProgress
                      ? Text("")
                      : Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 5,
                          )),
                ),
              ],
            ),
          )
        : _loadingData(context);
  }

  Widget _loadingData(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 20,
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
                      Padding(padding: const EdgeInsets.only(left: 5.0, right: 12.0),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
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

class Limit {
  String id;
  String name;

  Limit(this.id, this.name);

  static List<Limit> getlimit() {
    return <Limit>[
      Limit('0', 'Limit'),
      Limit('1', 'No Limit'),
    ];
  }
}
