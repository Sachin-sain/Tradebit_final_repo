import 'dart:convert';

import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class TransactionOrders extends StatefulWidget {

  _TransactionOrdersState createState() => _TransactionOrdersState();
}

class _TransactionOrdersState extends State<TransactionOrders> {

  List opendata=[];


  @override
  void initState() {
    Wakelock.enable();

    super.initState();
    getOpenData();

  }

  Future<void> getOpenData() async {
    final paramDic = {
      "": '',
    };
    var response =
    await LBMAPIMainClass(APIClasses.WalletTranData, paramDic, "Get");
    var data = json.decode(response.body);
    opendata.clear();
    if (response.statusCode == 200) {
      setState(() {
        opendata=data['data'];

      });

    } else {
      ToastClass.ToastShow(data['message']);

    }
  }


  @override
  Widget build(BuildContext context) {
    // double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return Scaffold(appBar: AppBar(title: Text('Transaction'),),
      body:  Padding(
        padding: const EdgeInsets.only(right: 15,left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Theme.of(context).canvasColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 7.0, bottom: 7.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Text(
                    //   "",
                    //   style: TextStyle(
                    //       color: Theme.of(context).hintColor,
                    //       fontFamily: "IBM Plex Sans"),
                    // ),
                    Text(
                      "Currency",
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontFamily: "IBM Plex Sans"),
                    ),
                    Text(
                      "Amount",
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontFamily: "IBM Plex Sans"),
                    ),
                    Text(
                      "Type",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "IBM Plex Sans"),
                    ),
                    Text(
                      "Status",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "IBM Plex Sans"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child:opendata==null ||opendata.length<0?Center(child: Container(child: Text("No Data"),)) : ListView.builder(
                shrinkWrap: false,
                primary: false,
                itemCount: opendata.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 1,left: 1,top: 8,bottom: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Row(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 5.0, right: 12.0),
                                //   child: SvgPicture.network(
                                //     opendata[i]['currency_info']['image'].toString(),
                                //     height: 20.0,
                                //     fit: BoxFit.contain,
                                //     width: 20.0,
                                //   ),
                                // ),
                                SizedBox(width: 5,),
                                Text(
                                  opendata[i]['currency_info']==null?"BTC/USDT":opendata[i]['currency_info'],
                                  style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 15.0,color: Colors.white),textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Text(
                              opendata[i]['amount']==null?"":opendata[i]['amount'],
                              style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 15.0,color: Colors.white),textAlign: TextAlign.start,
                            ),
                            Text(opendata[i]['type']==null?"":opendata[i]['type'],
                              style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 15.0),textAlign: TextAlign.center,
                            ),
                            Text(
                              opendata[i]['status']==null?"":opendata[i]['status'],
                              style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 10.0),textAlign: TextAlign.center,
                            ),

                          ],
                        ),
                        Divider(color: Colors.white38,),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
