// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../../config/constantClass.dart';
import '../Constants/Common.dart';
import '../Constants/colors.dart';
import 'transfer_alertBox.dart';

class WalletBalance extends StatefulWidget {
  var search;
  WalletBalance({Key key, @required this.search});

  @override
  State<WalletBalance> createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {
  @override
  Widget build(BuildContext context) {
    final Color black = Theme.of(context).textTheme.bodyText1.color;

    final heading = TextStyle(
      color: black,
      fontFamily: "IBM Plex Sans",
      fontWeight: FontWeight.bold,
    );
    final subheading = TextStyle(
      color: black,
      fontSize: 14,
      fontFamily: "IBM Plex Sans",
      fontWeight: FontWeight.w400,
    );

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: height / 18,
              decoration: ContainerDecoration.copyWith(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Currency",
                      style: heading,
                    ),
                    Text(
                      "Balance",
                      style: heading,
                    ),
                    Text(
                      "Withdrawable",
                      style: heading,
                    ),
                    Text(
                      "Action",
                      style: heading,
                    ),
                  ]),
            ),
            SizedBox(height: 3,),
            Container(
              height: height / 1.5,
              child: widget.search.isEmpty
                  ? Center(
                      child: Text(
                        "No Data Found",
                        style: heading,
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.search.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: height / 12,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 3, right: 8, top: 3),
                            child: Container(
                              decoration: ContainerDecoration.copyWith(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,),
                              // margin:
                              //     EdgeInsets.only(left: 11, right: 11, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppColors.golden)),
                                        child: Image.network(
                                          widget.search[index]
                                                      ["currency_image"] ==
                                                  null
                                              ? ""
                                              : widget.search[index]
                                                  ["currency_image"],
                                          height: height / 26,
                                          errorBuilder: (context, obj, trace) {
                                            return Center(
                                                child: Text(
                                                    " " +
                                                        widget.search[index]
                                                                ["currency"]
                                                            .toString()
                                                            .toString() +
                                                        " ",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color,fontFamily: "IBM Plex Sans",
                                                    )));
                                          },
                                        ),
                                      ),
                                      Text(
                                          "  " + widget.search[index]["currency"],
                                          style: subheading)
                                    ],
                                  ),
                                  Text(""), // for alignment
                                  Text(
                                    double.parse(widget.search[index]["balance"]
                                            .toString())
                                        .toStringAsFixed(3),
                                    style: subheading,
                                  ),
                                  Text(""), // for alignment
                                  Text(""), // for alignment
                                  Text(
                                    double.parse(
                                      widget.search[index]["withdrawable"]
                                          .toString(),
                                    ).toStringAsFixed(3),
                                    style: subheading,
                                  ),
                                  Text(""), // for alignment
                                  InkWell(
                                    child: Container(
                                      decoration: ContainerDecoration.copyWith(
                                          color: AppColors.golden,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      height: height / 21,
                                      width: width / 5,
                                      child: Center(
                                          child: Text(
                                        "Transfer",
                                        style: heading.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .color,
                                        ),
                                      )),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (_, __, ___) =>
                                              TransferAlertBox(
                                                  withdrable: StakingCommonClass
                                                          .My_Wallet[index]
                                                      ["withdrawable"],
                                                  currency: StakingCommonClass
                                                          .My_Wallet[index]
                                                      ["currency"])));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }
}
