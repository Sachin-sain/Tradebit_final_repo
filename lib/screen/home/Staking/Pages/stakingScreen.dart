// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Constants/Common.dart';
import '../Constants/colors.dart';
import '../Holding/api.dart';
import '../Holding/base_url_&_api.dart';
import '../Holding/holding_tab.dart';
import 'subscribeScreen.dart';

class StakingScreen extends StatefulWidget {
  const StakingScreen({Key key}) : super(key: key);

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _searchController;
  int a_plan_types_index = 0;
  String maturityDay = "";
  String Plantype = "";
  int full_List_index = 0;
  String roiPercentage = "0";
  String minimunStack = "0";

  int dataindex = 0;
  int i = 0;
  int indexPlanType = 0;
  List<PlanType> plan_typeList = [];
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool loading = false;
  String plan_type = '';
  String page = '1';
  List stakingList = [];
  bool isClicked = false;
  int dayindex = 0;

  final _refreshController = RefreshController(initialRefresh: false);

  Future<void> getStakingDetails() async {
    setState(() {
      loading = true;
    });
    final parameters = {
      "per_page": "10",
      "page": page,
      "plan_type": plan_type,
      'search': _searchController.text,
    };
    final url = Uri.https(StakingApi.baseUrl, StakingApi.staking, parameters);
    final response = await http.get(
      url,
    );
    print(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status_code'] == '1') {
        stakingList.clear();
        setState(() {
          stakingList.addAll(data['data']['data']);
          for (var j = 0; j < stakingList.length; j++) {
            plan_typeList.add(PlanType(fixed: true, flexible: false));
          }
        });
        setState(() {
          loading = false;
        });
      } else {
        print('failed$data');
      }
    } else {
      print('failed with statis code == > ${response.statusCode}');
    }
  }

  @override
  void initState() {
    wallet();
    stakingWallet();

    setState(() {
      loading = true;
    });
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();
    _tabController.addListener(() {
      setState(() {
        i = _tabController.index;
        print(_tabController.index);
        if (i == 1) {
          setState(() {
            plan_type = 'fixed';
            page = '1';
            dataindex = 0;
            dayindex = 0;
          });
        } else if (i == 2) {
          setState(() {
            plan_type = 'flexible';
            page = '1';
            dataindex = 0;
            dayindex = 0;
          });
        } else {
          setState(() {
            plan_type = '';
            page = '1';
            dataindex = 0;
            dayindex = 0;
          });
        }
      });
      getStakingDetails();
    });
    getStakingDetails();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () async {
            await Future.wait([
              getStakingDetails(),
              wallet(),
            ]);

            _refreshController.refreshCompleted();
          },
          header: WaterDropHeader(
              waterDropColor: Colors.blueAccent,
              complete: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    size: 18,
                    color: day ? Colors.black : Colors.white,
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(
                    "Refresh completed...",
                    style: TextStyle(
                        color: day ? Colors.black : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )),
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 27,
                              color: day == false ? Colors.white : Colors.black,
                            )),
                        Container(
                          width: width * 0.75,
                          height: height * 0.06,
                          child: Card(
                            color: day == false ? Colors.white12 : Colors.white,
                            child: TextField(
                              style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                              ),
                              onChanged: ((value) {
                                getStakingDetails();
                              }),
                              decoration: InputDecoration(
                                  hintText: 'Search Stake Currency..',
                                  hintStyle: TextStyle(
                                    color: day == false
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      height: height / 21,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: ContainerDecoration.copyWith(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            color:Color(0xffc79509),

                          ),
                          labelColor: Colors.white,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          indicatorWeight: 5.45,
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor:
                              day == false ? Colors.white54 : Colors.black54,
                          // indicatorPadding: EdgeInsets.all(1.0),

                          tabs: [
                            Text(
                              "All",
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: "IBM Plex Sans",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Fixed",
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: "IBM Plex Sans",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Flexible",
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: "IBM Plex Sans",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.01, horizontal: width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            Text(
                              'My Holdings ',
                              style: TextStyle(
                                  fontFamily: "IBM Plex Sans",
                                  color: day ? Colors.black : Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0xffc79509),

                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => HoldingTab()));
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.blue,
                          ),
                        )
                      : TabBarView(controller: _tabController, children: [
                          stakingList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Found',
                                    style: TextStyle(
                                      color: day ? Colors.black : Colors.white,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: stakingList.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.01),
                                  itemBuilder: (context, index) => loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.blue,
                                          ),
                                        )
                                      : _stakingContainer(height, width, index),
                                ),
                          stakingList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Found',
                                    style: TextStyle(
                                      fontFamily: "IBM Plex Sans",
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: stakingList.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.01),
                                  itemBuilder: (context, index) => loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.blue,
                                          ),
                                        )
                                      : _stakingContainer(height, width, index),
                                ),
                          stakingList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Found',
                                    style: TextStyle(
                                      fontFamily: "IBM Plex Sans",
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: stakingList.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.01),
                                  itemBuilder: (context, index) => loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.blue,
                                          ),
                                        )
                                      : _stakingContainer(height, width, index),
                                ),
                        ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stakingContainer(double height, double width, int index) {
    var SelectedData;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: day ? Colors.black : Colors.white,
          width: 0.3,
        ),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stake Currency',
                style: TextStyle(
                    color: day ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Reward Currency',
                style: TextStyle(
                    fontFamily: "IBM Plex Sans",
                    color: day ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    child: Image.network(
                      stakingList[index]['stake_currency_image'],
                      height: 22,
                      width: 22,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          stakingList[index]['stake_currency'].toString()[0],
                          style: TextStyle(
                              color: day ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    stakingList[index]['stake_currency'],
                    style: TextStyle(
                        fontFamily: "IBM Plex Sans",
                        color: day ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    child: Image.network(
                      stakingList[index]['reward_currency_image'],
                      height: 22,
                      width: 22,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Text(
                            stakingList[index]['reward_currency'].toString()[0],
                            style: TextStyle(
                              fontFamily: "IBM Plex Sans",
                              color: day ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    stakingList[index]['reward_currency'],
                    style: TextStyle(
                        color: day ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ROI (%)',
                    style: TextStyle(
                        color: day ? Colors.black : Colors.white,
                        fontFamily: "IBM Plex Sans",
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: height * 0.001,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.green[400],
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                          children: [
                        TextSpan(
                          text: (SelectedData),
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(0.0, 0.0),
                            child: Text(
                              full_List_index == index
                                  ? stakingList[index]["s_data"][
                                                  "${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toString().toLowerCase()}-${stakingList[index]["o_plan_days"]["${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toLowerCase()}"][stakingList[index]["o_plan_days"][stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex]].length == 1 ? 0 : dayindex]}"]
                                              ["roi_percentage"]
                                          .toString() +
                                      '%'
                                  :
                                  //else

                                  stakingList[index]["s_data"][
                                                  "${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : 0].toString().toLowerCase()}-${stakingList[index]["o_plan_days"]["${stakingList[index]["a_plan_types"][0].toLowerCase()}"][0].toString()}"]
                                              ["roi_percentage"]
                                          .toString() +
                                      '%',
                              style: TextStyle(
                                fontFamily: "IBM Plex Sans",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[400],
                              ),
                            ),
                          ),
                        ),
                      ])),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimum Stake',
                    style: TextStyle(
                        color: day ? Colors.black : Colors.white,
                        fontFamily: "IBM Plex Sans",
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: height * 0.001,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: day ? Colors.black : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: full_List_index == index
                              ? stakingList[index]["s_data"][
                                          "${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toString().toLowerCase()}-${stakingList[index]["o_plan_days"]["${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toLowerCase()}"][stakingList[index]["o_plan_days"][stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex]].length == 1 ? 0 : dayindex]}"]
                                      ["min_stake_amount"]
                                  .toString()

                              //else
                              : stakingList[index]["s_data"][
                                          "${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : 0].toString().toLowerCase()}-${stakingList[index]["o_plan_days"]["${stakingList[index]["a_plan_types"][0].toLowerCase()}"][0].toString()}"]
                                      ["min_stake_amount"]
                                  .toString(),
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(0.0, 4.0),
                            child: Text(
                              stakingList[index]['stake_currency'],
                              style: TextStyle(
                                fontFamily: "IBM Plex Sans",
                                fontSize: 16,
                                color: day ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (i == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Type',
                      style: TextStyle(
                          color: day ? Colors.black : Colors.white,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      children: [
                        for (var q = 0;
                            q < stakingList[index]['a_plan_types'].length;
                            q++)
                          InkWell(
                            onTap: () {
                              print("selectedayindex" +
                                  full_List_index.toString());
                              print("index " + index.toString());

                              setState(() {
                                full_List_index = index;
                                dataindex = q;
                                if (dataindex == 0) {
                                  isClicked = false;
                                } else {
                                  isClicked = true;
                                }
                                dayindex = 0;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: height * 0.011),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: index == full_List_index
                                      ? stakingList[index]['a_plan_types']
                                                  .length >
                                              1
                                          ? isClicked && dataindex == q
                                              ? AppColors.golden
                                              : !isClicked && dataindex == q
                                                  ? AppColors.golden
                                                  : Colors.transparent
                                          : AppColors.golden
                                      : stakingList[index]['a_plan_types']
                                                  .length >
                                              1
                                          ? q == 0
                                              ? AppColors.golden
                                              : Colors.transparent
                                          : AppColors.golden),

                              // ( isClicked && dataindex == q ? index == full_List_index?AppColors.golden:AppColors.golden :
                              //               !isClicked && dataindex == q ?    index == full_List_index ?AppColors.golden:black : black ): AppColors.golden),
                              child: Text(
                                stakingList[index]['a_plan_types'][q]
                                    .toString()
                                    .toUpperCase(),
                                //dataindex.toString()+""+isClicked.toString(),
                                style: TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              Column(
                children: [
                  Text(
                    'Maturity Days',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "IBM Plex Sans",
                        color: day ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int k = 0;
                              k <
                                  stakingList[index]["o_plan_days"][
                                          stakingList[index]["a_plan_types"][
                                              stakingList[index]["a_plan_types"]
                                                          .length ==
                                                      dataindex
                                                  ? 0
                                                  : dataindex]]
                                      .length;
                              k++)
                            InkWell(
                              onTap: () {
                                dayindex = k;
                                setState(() {
                                  full_List_index = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                    vertical: height * 0.011),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.blue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: full_List_index == index
                                        ? stakingList[index]["o_plan_days"][
                                                        stakingList[index]
                                                                ["a_plan_types"][
                                                            stakingList[index]["a_plan_types"].length ==
                                                                    dataindex
                                                                ? 0
                                                                : dataindex]]
                                                    .length >
                                                1
                                            ? isClicked && dayindex == k
                                                ? AppColors.golden
                                                : !isClicked && dayindex == k
                                                    ? AppColors.golden
                                                    : Colors.transparent
                                            : AppColors.golden
                                        :
                                        //  first else

                                        stakingList[index]["o_plan_days"][
                                                        stakingList[index]
                                                                ["a_plan_types"]
                                                            [stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex]]
                                                    .length >
                                                1
                                            ? k == 0
                                                ? AppColors.golden
                                                : Colors.transparent
                                            : AppColors.golden),
                                child: Text(
                                  stakingList[index]["o_plan_days"][
                                          stakingList[index]["a_plan_types"][
                                              stakingList[index]["a_plan_types"]
                                                          .length ==
                                                      dataindex
                                                  ? 0
                                                  : dataindex]][k]
                                      .toString(),
                                  style: TextStyle(
                                      color: day ? Colors.black : Colors.white,
                                      fontFamily: "IBM Plex Sans",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          InkWell(
            onTap: () {
              print("---" +
                  stakingList[index]["s_data"][
                          "${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toString().toLowerCase()}-${stakingList[index]["o_plan_days"]["${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toLowerCase()}"][stakingList[index]["o_plan_days"][stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex]].length == 1 ? 0 : stakingList[index]["o_plan_days"].length + 1 == dayindex ? 0 : dayindex]}"]
                      .toString());

              // print('-----> '+"${stakingList[index]['a_plan_types'][indexPlanType]}-${stakingList[index]['s_maturity_days'].toString()}" );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscribeScreen(
                        data: stakingList[index],
                        planTypeData: stakingList[index]["s_data"][
                            "${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toString().toLowerCase()}-${stakingList[index]["o_plan_days"]["${stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex].toLowerCase()}"][stakingList[index]["o_plan_days"][stakingList[index]["a_plan_types"][stakingList[index]["a_plan_types"].length == dataindex ? 0 : dataindex]].length == 1 ? 0 : dayindex]}"]),
                  ));
            },
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(vertical: height * 0.005),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff143047),
                    Color(0xff176980),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Subscribe',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanType {
  bool fixed;
  bool flexible;

  PlanType({
    @required this.fixed,
    @required this.flexible,
  });

  @override
  String toString() => 'PlanType(fixed: $fixed, flexible: $flexible)';
}
