// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';
import 'Order_Detail.dart';

class CompleteopenOrders extends StatefulWidget {
  _CompleteopenOrdersState createState() => _CompleteopenOrdersState();
}

List completedata = [];
List completedatanew = [];
bool _isTrackProgress = false;
String status;
bool isProgress = false;
bool datafetch = false;
int total = 0;

getcompletedata(int pagenumber) async {
  print('complete order = @@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  final paramDic = {
    "type": 'completed',
    "page": pagenumber.toString(),
    "per_page": '20',
  };
  var response =
      await APIMainClassbinance(APIClasses.OpenData, paramDic, "Get");
  var data = json.decode(response.body);

  completedatanew.clear();
  if (pagenumber == 1) {
    completedata.clear();
  }
  if (response.statusCode == 200) {
    status = 'true';
    isProgress = true;
    _isTrackProgress = true;
    completedatanew = data['data']['data'];
    total = int.parse(data['data']['last_page'].toString());
    completedata.addAll(completedatanew);
    datafetch = true;
  } else {
    pagenumber = pagenumber;
    isProgress = true;
    status = 'true';
    _isTrackProgress = true;
    datafetch = true;
  }
}

class _CompleteopenOrdersState extends State<CompleteopenOrders> {
  static NumberFormat Cr = new NumberFormat("#,##0.00", "en_US");
  static int pagenumber = 1;

  List orderdetails = [];

  @override
  void initState() {
    // getcompletedata(pagenumber);
    Wakelock.enable();
    super.initState();
  }

  getCompleteOrderDetail(String id) async {
    final paramDic = {
      "id": id.toString(),
    };
    var response = await APIMainClassbinance(
        APIClasses.completeOrderDetail, paramDic, "Get");
    var data = json.decode(response.body);
    print(data.toString());
    orderdetails.clear();
    if (response.statusCode == 200) {
      setState(() {
        orderdetails.add(data['data']);

        print("asasasa" + orderdetails.toString());
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return status == 'true'
        ? Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 7.0, bottom: 7.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text("Pair", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),
                          ),
                        ),
                        Container(
                          //  width: MediaQuery.of(context).size.width*0.15,
                          child: SingleChildScrollView(
                            key: UniqueKey(),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Text("Amount", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text("Price", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Padding(padding: const EdgeInsets.only(right: 12.0),
                            child: Text("Total", style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: "IBM Plex Sans"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                completedata.length > 0
                    ? NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (_isTrackProgress &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              scrollInfo.metrics.axis == Axis.vertical) {
                            // start loading data
                            setState(() {
                              if (total != pagenumber) {
                                if (datafetch) {
                                  pagenumber = pagenumber + 1;
                                  getcompletedata(pagenumber);
                                  _isTrackProgress = false;
                                } else {
                                  getcompletedata(pagenumber);
                                }
                              } else {
                                ToastShowClass.toastShow(context,
                                    'Nothing more to show', Colors.blue,);
                              }
                            });
                          }
                          return false;
                        },
                        child: ListView.builder(
                          shrinkWrap: false,
                          primary: false,
                          itemCount: completedata.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            return InkWell(
                              onTap: () {
                                getCompleteOrderDetail(
                                    completedata[i]['id'].toString());
                                List senddata = [];
                                setState(() {
                                  senddata.add(orderdetails);
                                  print("iN DATA ?ewfdklnhjitrnmj,ersfdg  " +
                                      senddata[0][0]["data"][0]["commission"]
                                          .toString());
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetail(
                                              orderdetail: senddata[0],
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text(
                                            completedata[i]['currency'] +
                                                "/" +
                                                completedata[i]
                                                    ['with_currency'],
                                            style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 12.0, color: day == false ? Colors.white : Colors.black), textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text(
                                            completedata[i]['at_price'] == null
                                                ? ""
                                                : Cr.format(double.parse(
                                                    completedata[i]
                                                        ['at_price'])),
                                            style: TextStyle(
                                                fontFamily: "IBM Plex Sans",
                                                fontSize: 12.0,
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text(
                                            completedata[i]['quantity'] == null
                                                ? ""
                                                : completedata[i]['quantity'],
                                            style: TextStyle(
                                                fontFamily: "IBM Plex Sans",
                                                fontSize: 12.0,
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Column(
                                            children: [
                                              Text(
                                                completedata[i]['total'] == null
                                                    ? ""
                                                    : completedata[i]['total'],
                                                style: TextStyle(
                                                    fontFamily: "IBM Plex Sans",
                                                    fontSize: 12.0,
                                                    color: day == false
                                                        ? Colors.white
                                                        : Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                              Container(
                                                //color: Colors.red,
                                                height: 25,
                                                width: 80,
                                                child: Center(
                                                    child: Text(
                                                  completedata[i][
                                                              'current_status'] ==
                                                          null
                                                      ? ""
                                                      : completedata[i]
                                                          ['current_status'],
                                                  style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 8.0,
                                                      color: completedata[i][
                                                                  'current_status'] ==
                                                              'canceled'
                                                          ? Colors.red
                                                          : completedata[i][
                                                                      'current_status'] ==
                                                                  'buy'
                                                              ? Colors.redAccent
                                                              : Colors.greenAccent), textAlign: TextAlign.center,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: day == false ? Colors.white38 : Colors.black38,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                    : Center(
                        child: Container(
                        child: Text(
                          "No Complete Orders! \n Let's Order Some Crypto !",
                          style: TextStyle(color: day == false ? Colors.white : Colors.black, fontFamily: 'IBM Plex Sans'),
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
                  decoration: BoxDecoration(color: Theme.of(ctx).hintColor, borderRadius: BorderRadius.all(Radius.circular(2.0))),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(color: Colors.black12),
            ),
          )
        ],
      ),
    ),
  );
}
