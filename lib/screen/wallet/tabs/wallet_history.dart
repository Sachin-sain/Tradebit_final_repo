// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';

import 'package:exchange/screen/wallet/tabs/receipt_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/APIClasses.dart';
import '../../../config/APIMainClass.dart';
import '../../../config/constantClass.dart';

class wallet_history extends StatefulWidget {
  @override
  State<wallet_history> createState() => _wallet_historyState();
}

class _wallet_historyState extends State<wallet_history> {
  List History_data = [];
  List Passdata = [];
  bool dataload = false;
  @override
  void initState() {
    DepositHistory();
    dataload = true;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  Future<void> DepositHistory() async {
    final paramDic = {
      "": "",
    };
    var response =
        await LBMAPIMainClass(APIClasses.Wallethistory, paramDic, "Get");
    var data = json.decode(response.body);
    History_data.clear();
    if (data["status_code"] == "1") {
      setState(() {
        History_data = data["data"];
        print("Historydata" + History_data.toString());
        dataload = false;
      });
    } else {
      setState(() {
        dataload = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: day == false ? Colors.black : Colors.white,
        title: Text("Withdrawl History",
            style: TextStyle(fontFamily: "IBM Plex Sans", color: Colors.grey)),
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: dataload
            ? Center(
                child: Container(
                    height: 20, width: 20, child: CircularProgressIndicator()))
            : Container(
                height: MediaQuery.of(context).size.height,
                child: History_data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: History_data.length,
                        itemBuilder: (context, index) {
                          //return CartItem(index: index, products: cartList.cartItems[index]);
                          return CardData(context, index);
                          //return cartItems(index, products);
                        })
                    : Center(
                        child: Text("No Data",
                            style: TextStyle(
                                color: day == false
                                    ? Colors.white
                                    : Colors.black))),
              ),
      ),
    );
  }

  Widget CardData(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Passdata.clear();
        Passdata.add(History_data[index]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => receipt_detail(
                      Datafetch: Passdata,
                    )));
        if (History_data[index]["transfer_detail"] != null) {
          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebviewScreen(url:History_data[index]["transfer_detail"]["transactionHash"].toString() ,)));

          //
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("Symbol : ",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: day == false ? Colors.white : Colors.black)),
                    Text(History_data[index]["currency"].toString(),
                        style: TextStyle(
                            fontSize: 10,
                            color: day == false ? Colors.white : Colors.black)),
                  ],
                ),
                // InkWell(
                //   onTap: (){
                //     Passdata.clear();
                //     Passdata.add(History_data[index]);
                //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => receipt_detail(Datafetch: Passdata,)));
                //
                //
                //   },
                //   child: Row(
                //     children: [
                //       Text("View : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: day==false? Colors.white:Colors.black)),
                //       Icon(Icons.remove_red_eye,size: 18,color: day==false? Colors.white:Colors.black,)
                //       // Text(History_data[index]["token_type"].toString(),style: TextStyle(fontSize: 10,color: day==false? Colors.white:Colors.black)),
                //     ],
                //   ),
                // ),
                Row(
                  children: [
                    Text("Amount : ",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: day == false ? Colors.white : Colors.black)),
                    Text(History_data[index]["amount"].toString(),
                        style: TextStyle(
                            fontSize: 10,
                            color: day == false ? Colors.white : Colors.black)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("Status : ",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: day == false ? Colors.white : Colors.black)),
                    Text(History_data[index]["status"].toString(),
                        style: TextStyle(
                            fontSize: 10,
                            color: day == false ? Colors.white : Colors.black)),
                  ],
                ),
                Row(
                  children: [
                    Text("Created At : ",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: day == false ? Colors.white : Colors.black)),
                    Text(
                        DateFormat("dd/MM/yyyy, hh:mm:ss").format(
                            DateTime.parse(History_data[index]["created_at"]
                                    .toString())
                                .toLocal()),
                        style: TextStyle(
                            fontSize: 10,
                            color: day == false ? Colors.white : Colors.black)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            //       Row(
            //         children: [
            //           Text("Transaction Hash : ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: day==false? Colors.white:Colors.black)),
            //           InkWell(
            //             onTap: (){
            //
            //               if(History_data[index]["transfer_detail"]!=null){
            //                 Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebviewScreen(url:History_data[index]["transfer_detail"]["transactionHash"].toString() ,)));

            //               }
            //
            //
            //
            //             },
            //             child: Container(
            // width: MediaQuery.of(context).size.width * 0.6,
            //               child: SingleChildScrollView(
            //                   scrollDirection: Axis.horizontal,
            //                   child: Text(History_data[index]["transfer_detail"]!=null?History_data[index]["transfer_detail"]["transactionHash"].toString():"----",style: TextStyle(fontSize: 10,color: Colors.blue))),
            //             ),
            //           ),
            //         ],
            //       ),

            Divider(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
