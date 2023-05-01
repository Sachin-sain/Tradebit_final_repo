// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../../config/constantClass.dart';
import '../Constants/Common.dart';
import '../Constants/colors.dart';
import 'api.dart';

class Transaction extends StatefulWidget {
  var search;
   Transaction({Key key, @required this.search}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {

  final GlobalKey _key = GlobalKey();
  int scrollingLength = 1;
  bool data = false;
  getTransactionData() {
    stakingTransaction(1).whenComplete(() {
      setState(() {
        data = true;
        StakingCommonClass.Transcation_searchItem = StakingCommonClass.My_transcation;
      });
    });
  }

  @override
  void initState() {
    getTransactionData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final Color black = Theme.of(context).textTheme.bodyLarge.color;

    final heading = TextStyle(color: black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans",);
    final subheading = TextStyle(color:black, fontSize: 14,fontWeight: FontWeight.w400,fontFamily: "IBM Plex Sans",);


    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: data == false
          ? Center(
        child: CircularProgressIndicator(),
      )
          : widget.search.isEmpty?Center(child: Text("No Data found",style: heading,),): Column(children: [
        NotificationListener(
          key: _key,
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && scrollInfo.metrics.axis == Axis.vertical) {
              setState(() {
                if (scrollingLength > StakingCommonClass.My_transcation_lastPage == false) {
                  scrollingLength++;
                  stakingHoilding(scrollingLength);
                } else {

                  print("reach bottom");
                }
              });
            }

            return true;
          },
          child: Container(
              height: height / 1.26,
              child: ListView.builder(
                  itemCount: widget.search.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: ContainerDecoration.copyWith(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      // height: height / 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: AppColors.golden)),
                                    child: Image.network(
                                        widget.search[index]["currency_image"] == null?"       ":widget.search[index]["currency_image"],
                                        height: height / 31,errorBuilder: (context,obj,trace){
                                          return CircleAvatar(backgroundColor: Theme.of(context).colorScheme.background,radius: 13,child: Text(widget.search[index]["currency"][0],),);
                                    },),
                                  ),
                                ),
                                Text(
                                    "   ${widget.search[index]["currency"]} ",
                                    style: subheading.copyWith(
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                Container(
                                  height: height / 26,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                        " Type : ${widget.search[index]["transaction_type"].toString().toUpperCase()} ",
                                        style: subheading.copyWith(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 31,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Debit",
                                    style: heading,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.search[index]
                                            ["debit"]
                                        .toString(),
                                    style: subheading,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Credit",
                                    style: heading,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.search[index]
                                            ["credit"]
                                        .toString(),
                                    style: subheading,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Balance",
                                    style: heading,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                  double.parse(    widget.search[index]["balance"].toString(),).toStringAsFixed(3),
                                      style: subheading)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 31,
                          ),
                          Row(
                            children: [
                              Text(
                                "  Comments : ",
                                style:
                                    heading.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.search[index]
                                        ["comment"]
                                    .toString(),
                                style: subheading,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 51,
                          ),
                        ],
                      ),
                    );
                  })),
        ),
      ]),
    );
  }
}
