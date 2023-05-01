// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../../../config/constantClass.dart';
import '../Constants/Common.dart';
import '../Constants/colors.dart';
import 'my_holding.dart';
import 'transcation.dart';
import 'wallet_balance.dart';

class HoldingTab extends StatefulWidget {
  const HoldingTab({Key key}) : super(key: key);

  @override
  State<HoldingTab> createState() => _HoldingTabState();
}

class _HoldingTabState extends State<HoldingTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool isSerching = false;

  final SearchController = TextEditingController();

  searching(val) {}

  @override
  void initState() {
    StakingCommonClass.Holding_searchItem = StakingCommonClass.My_hlodings;
    StakingCommonClass.Transcation_searchItem =
        StakingCommonClass.My_transcation;
    StakingCommonClass.walletBal_searchItem = StakingCommonClass.My_Wallet;
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("------ " + _tabController.index.toString());

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              children: [
                SizedBox(height: 16),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back,
                            color: day == false ? Colors.white : Colors.black),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          " Staking",
                          style: style_white.copyWith(
                              fontFamily: "IBM Plex Sans",
                              fontSize: headingSize,
                              color:
                                  day == false ? Colors.white : Colors.black),
                        ),
                        SizedBox(
                          width: width / 5,
                        ),
                        Container(
                          width: width / 2.5,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: day == false
                                  ? Colors.white12
                                  : Colors.black12),
                          child: Center(
                            // color: day==false?Colors.white12:Colors.white,
                            child: TextField(
                              style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                              ),
                              onChanged: ((value) {
                                if (_tabController.index.toString() == "0") {
                                  if (SearchController.text.isEmpty) {
                                    setState(() {
                                      StakingCommonClass.Holding_searchItem =
                                          StakingCommonClass.My_hlodings;
                                    });
                                    print("object" +
                                        StakingCommonClass.Holding_searchItem
                                            .toString());
                                  } else {
                                    // searchItem.clear();
                                    setState(() {
                                      StakingCommonClass.Holding_searchItem =
                                          StakingCommonClass.My_hlodings.where(
                                              (element) => element[
                                                      "stake_currency"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(SearchController
                                                      .text
                                                      .toString()
                                                      .toLowerCase())).toList();
                                    });
                                  }
                                } else if (_tabController.index.toString() ==
                                    "2") {
                                  if (SearchController.text.isEmpty) {
                                    setState(() {
                                      StakingCommonClass
                                              .Transcation_searchItem =
                                          StakingCommonClass.My_transcation;
                                    });
                                    print("object " +
                                        StakingCommonClass
                                            .Transcation_searchItem.toString());
                                  } else {
                                    // searchItem.clear();
                                    setState(() {
                                      StakingCommonClass
                                              .Transcation_searchItem =
                                          StakingCommonClass.My_transcation
                                              .where((element) => element[
                                                      "currency"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(SearchController
                                                      .text
                                                      .toString()
                                                      .toLowerCase())).toList();
                                    });
                                  }
                                } else if (_tabController.index.toString() ==
                                    "1") {
                                  if (SearchController.text.isEmpty) {
                                    setState(() {
                                      StakingCommonClass.walletBal_searchItem =
                                          StakingCommonClass.My_Wallet;
                                    });
                                    print("object " +
                                        StakingCommonClass
                                            .Transcation_searchItem.toString());
                                  } else {
                                    // searchItem.clear();
                                    setState(() {
                                      StakingCommonClass.walletBal_searchItem =
                                          StakingCommonClass.My_Wallet.where(
                                              (element) => element["currency"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(SearchController
                                                      .text
                                                      .toString()
                                                      .toLowerCase())).toList();
                                    });
                                  }
                                }
                              }),
                              decoration: InputDecoration(
                                  hintText: 'Search Stake..',
                                  hintStyle: TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 14,
                                    color: day == false
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                  labelStyle: TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    height: 25,
                                    color: day == false
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                  filled: true,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black,
                                    size: 20,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: height / 21,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    height: height / 21,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: ContainerDecoration.copyWith(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xfff9bf30),
                        ),
                        labelColor: Colors.white,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        indicatorWeight: 5.45,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor:
                            day == false ? Colors.white54 : Colors.black54,
                        indicatorColor: AppColors.golden,
                        controller: _tabController,
                        tabs: [
                          SizedBox(
                            width: width / 4,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "My Holdings",
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: "IBM Plex Sans",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width / 4,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "Wallet Balance",
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: "IBM Plex Sans",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width / 4,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "Transaction",
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: "IBM Plex Sans",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: height / 1.26,
                  child: TabBarView(controller: _tabController, children: [
                    MyHoldings(),
                    WalletBalance(
                        search: StakingCommonClass.walletBal_searchItem),
                    Transaction(
                        search: StakingCommonClass.Transcation_searchItem),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
