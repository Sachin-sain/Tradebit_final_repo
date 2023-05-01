import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/constantClass.dart';
import '../Constants/Common.dart';
import '../Constants/colors.dart';
import 'api.dart';

class MyHoldings extends StatefulWidget {
  const MyHoldings({Key key}) : super(key: key);

  @override
  State<MyHoldings> createState() => _MyHoldingsState();
}

class _MyHoldingsState extends State<MyHoldings> {
  final GlobalKey _key = GlobalKey();
  var search;

  var i = 0;
  int scrollingLength = 0;
  bool data = false;

  getHoldingList() async {
    await stakingHoilding(1).whenComplete(() {
      setState(() {
        data = true;
        StakingCommonClass.Holding_searchItem = StakingCommonClass.My_hlodings;
      });
    });
  }

  @override
  void initState() {
    StakingCommonClass.My_hlodings.clear();
    getHoldingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color black = day == false ? Colors.white : Colors.black;

    TextStyle subheadingexpand = style_white.copyWith(
        fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return data == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : StakingCommonClass.Holding_searchItem.isEmpty
            ? Center(
                child: Text(
                "No Data Found ",
                style: TextStyle(color: black),
              ))
            : Scaffold(
                backgroundColor: day == false ? Colors.black : Colors.white,
                body: NotificationListener(
                  key: _key,
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        scrollInfo.metrics.axis == Axis.vertical) {
                      setState(() {
                        if (scrollingLength >
                                StakingCommonClass.My_hlodings_lastPage ==
                            false) {
                          scrollingLength++;
                          stakingHoilding(scrollingLength);
                        } else {
                          print("reach bottom");
                        }
                      });
                    }

                    return true;
                  },
                  child: SizedBox(
                    height: height,
                    child: ListView.builder(
                      itemCount: StakingCommonClass.Holding_searchItem.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8, bottom: 9, right: 8, top: 15),
                          child: Container(
                            decoration: ContainerDecoration.copyWith(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 10,
                                right: 10,
                              ),
                              child: ExpandablePanel(
                                theme: ExpandableThemeData(iconColor: black),
                                header: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors.golden)),
                                            child: Image.network(
                                              StakingCommonClass.Holding_searchItem[
                                                              index][
                                                          "reward_currency_image"] ==
                                                      null
                                                  ? ""
                                                  : StakingCommonClass
                                                              .Holding_searchItem[
                                                          index]
                                                      ["reward_currency_image"],
                                              height: height / 21,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Center(
                                                      child: Text(StakingCommonClass
                                                          .Holding_searchItem[
                                                              index]
                                                              ["stake_currency"]
                                                          .toString()[0])),
                                            ),
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 19,
                                          backgroundColor: day == false
                                              ? Colors.black
                                              : Colors.white,
                                          child: Image.network(
                                              StakingCommonClass.Holding_searchItem[
                                                              index][
                                                          "stake_currency_image"] ==
                                                      null
                                                  ? ""
                                                  : StakingCommonClass
                                                              .Holding_searchItem[
                                                          index]
                                                      ["stake_currency_image"],
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Text("")),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: width / 14,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${StakingCommonClass.Holding_searchItem[index]["stake_currency"].toString()} - ${StakingCommonClass.Holding_searchItem[index]["reward_currency"].toString()}",
                                          style: style_white.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "IBM Plex Sans",
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Liquidity ${StakingCommonClass.Holding_searchItem[index]["total_liquidity"].toString()}",
                                          style: style_white.copyWith(
                                              fontFamily: "IBM Plex Sans",
                                              fontSize: 13,
                                              color: day == false
                                                  ? Colors.white
                                                      .withOpacity(0.7)
                                                  : Colors.black
                                                      .withOpacity(0.7)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: width / 14,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          StakingCommonClass
                                              .Holding_searchItem[index]
                                                  ["total_active"]
                                              .toString(),
                                          style: style_white.copyWith(
                                            fontFamily: "IBM Plex Sans",
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Active Plan",
                                          style: subheadingexpand.copyWith(
                                            fontSize: 13,
                                            fontFamily: "IBM Plex Sans",
                                            color: day == false
                                                ? Colors.white.withOpacity(0.7)
                                                : Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                collapsed: Text(
                                  " ",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                expanded: _expanded(height, index),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
  }

  Widget _expanded(double height, index) {
    final Color black = day == false ? Colors.white : Colors.black;

    TextStyle headingexpand = style_white.copyWith(
        fontFamily: "IBM Plex Sans",
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: black);
    TextStyle subheadingexpand = style_white.copyWith(
      fontSize: 11,
      fontFamily: "IBM Plex Sans",
      color: black,
    );

    // ignore: non_constant_identifier_names
    List PairData = [];
    PairData.addAll(StakingCommonClass.Holding_searchItem[index]["pair_data"]);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Plan Type ",
              style: headingexpand,
            ),
            Text(
              "Maturity ",
              style: headingexpand,
            ),
            Text(
              "ROI",
              style: headingexpand,
            ),
            Text(
              "Amount ",
              style: headingexpand,
            ),
            Text(
              "Expiry Date ",
              style: headingexpand,
            ),
            Text("          ")
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: PairData.length,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    PairData[i]["plan_type"].toString().toUpperCase(),
                    style: PairData[i]["is_active"].toString().toLowerCase() ==
                            "false"
                        ? subheadingexpand.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: black?.withOpacity(0.6))
                        : subheadingexpand,
                  ),
                  Text(
                      "${PairData[i]["roi_interval"].toString() == "D" ? "Days" : PairData[i]["roi_interval"].toString() == "M" ? "Monthly" : "Yearly"} : ${PairData[i]["staking_plan"]["maturity_days"].toString()}",
                      style:
                          PairData[i]["is_active"].toString().toLowerCase() ==
                                  "false"
                              ? subheadingexpand.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: black?.withOpacity(0.6))
                              : subheadingexpand),
                  Text(
                      " ${PairData[i]["staking_plan"]["roi_percentage"].toString()} %",
                      style:
                          PairData[i]["is_active"].toString().toLowerCase() ==
                                  "false"
                              ? subheadingexpand.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: black?.withOpacity(0.6))
                              : subheadingexpand),
                  Text(" ${PairData[i]["amount"].toString()} ",
                      style:
                          PairData[i]["is_active"].toString().toLowerCase() ==
                                  "false"
                              ? subheadingexpand.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: black?.withOpacity(0.6))
                              : subheadingexpand),
                  Text(
                      DateFormat("dd-MMM-yyyy")
                          .format(DateTime.parse(
                            PairData[i]["expiry_date"].toString(),
                          ).toLocal())
                          .toString(),
                      style:
                          PairData[i]["is_active"].toString().toLowerCase() ==
                                  "false"
                              ? subheadingexpand.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: black?.withOpacity(0.6))
                              : subheadingexpand),
                  PairData[i]["plan_type"].toString().toUpperCase() == "FIXED"
                      ? Icon(
                          Icons.lock,
                        )
                      : PairData[i]["is_active"].toString().toLowerCase() ==
                              "false"
                          // ? Icon(Icons.cancel_outlined)
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.5),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                size: 15,
                                color: Colors.white,
                              )),
                            )
                          : InkWell(
                              child: Icon(
                                Icons.lock_open_sharp,
                                color: AppColors.golden,
                              ),
                              onTap: () async {
                                await alertBoxUnsuscribe(
                                    context, PairData[i]["id"]);
                              },
                            )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  alertBoxUnsuscribe(context, id) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            actions: [
              Container(
                  decoration: ContainerDecoration.copyWith(
                      border: Border.all(color: Colors.white, width: 0.3),
                      color: Theme.of(context).backgroundColor),
                  height: height / 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height / 41,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "------------",
                            style: TextStyle(
                                fontSize: 17, color: AppColors.golden),
                          ),
                          Text(
                            "  My Holdings  ",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "IBM Plex Sans",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          Text(
                            "------------",
                            style: TextStyle(
                                fontSize: 17, color: AppColors.golden),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 41,
                      ),
                      Text(
                        "Are you sure you want to Unsubscribe?",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "IBM Plex Sans",
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                      SizedBox(
                        height: height / 41,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              width: width / 4,
                              height: height / 21,
                              decoration: ContainerDecoration.copyWith(
                                  color: AppColors.golden),
                              child: Center(
                                  child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "IBM Plex Sans",
                                ),
                              )),
                            ),
                            onTap: () {
                              UnsubscribeApi(context, id.toString())
                                  .whenComplete(() {
                                setState(() {});
                              });
                            },
                          ),
                          SizedBox(
                            width: width / 10,
                          ),
                          InkWell(
                            child: Container(
                              width: width / 4,
                              height: height / 21,
                              decoration: ContainerDecoration.copyWith(
                                  color: AppColors.golden),
                              child: Center(
                                  child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "IBM Plex Sans",
                                ),
                              )),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          );
        });
  }
}
