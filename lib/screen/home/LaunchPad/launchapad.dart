import 'dart:convert';

import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/screen/home/LaunchPad/launchpadDetail.dart';
import 'package:flutter/material.dart';

import '../../../config/APIClasses.dart';
import '../../../config/constantClass.dart';

class LaunchPadScreen extends StatefulWidget {
  const LaunchPadScreen({Key key}) : super(key: key);

  @override
  State<LaunchPadScreen> createState() => _LaunchPadScPeenState();
}

class _LaunchPadScPeenState extends State<LaunchPadScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  List ongoingList = [];
  List pastList = [];
  List upcomingList = [];
  TabController _tabController;
  String error = '';
  Future<void> getLaunchPads() async {
    setState(() {
      loading = true;
    });
    final paramDic = {
      "": "",
    };
    print(paramDic);

    final response =
        await APIMainClassbinance(APIClasses.launchpad, paramDic, "Get");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status_code'] == '1') {
        setState(() {
          ongoingList = data['data']['ongoing'];
          pastList = data['data']['past'];
          upcomingList = data['data']['upcoming'];
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          error = data['message'];
        });
        ToastShowClass.toastShow(context, data['message'], Colors.red);
      }
    } else {
      setState(() {
        loading = false;
        error = 'Something Went Wrong';
      });
      ToastShowClass.toastShow(context, 'Something Went Wrong', Colors.red);
    }
  }

  @override
  void initState() {
    getLaunchPads();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Launchpad",
          style: TextStyle(
            fontFamily: "IBM Plex Sans",
            color: day == false ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: day == false ? Colors.black : Colors.white,
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.001),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Color(0xffc79509),
              ),
              labelColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorWeight: 5.45,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor:
                  day == false ? Colors.white54 : Colors.black54,
              indicatorPadding: EdgeInsets.all(8.0),
              tabs: [
                Tab(
                  child: Text(
                    "Ongoing",
                    style: TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Tab(
                    child: Text(
                  "Past",
                  style: TextStyle(
                    fontFamily: "IBM Plex Sans",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                Tab(
                    child: Text(
                  "Upcoming",
                  style: TextStyle(
                    fontFamily: "IBM Plex Sans",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ))
              ],
            ),
            SizedBox(
              height: height * 0.8,
              child: TabBarView(controller: _tabController, children: <Widget>[
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ongoingList.isEmpty
                        ? Center(
                            child: Text(
                              error != ''
                                  ? '$error'
                                  : 'No Ongoing Launchpads Available ~ Please Check later',
                              style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: ongoingList.length,
                            itemBuilder: (context, index) {
                              return launchpadItem(
                                  width: width,
                                  height: height,
                                  image: ongoingList[index]['image'] ?? '',
                                  status: 'Live',
                                  expireAt:
                                      ongoingList[index]['expired_at'] ?? '',
                                  name: ongoingList[index]['name'] ?? '',
                                  symbol: ongoingList[index]['symbol'] ?? '',
                                  disclaimer:
                                      ongoingList[index]['disclaimer'] ?? '',
                                  data: ongoingList[index]);
                            },
                          ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : pastList.isEmpty
                        ? Center(
                            child: Text(
                              error != ''
                                  ? '$error'
                                  : 'No Past Launchpads Available ~ Please Check later',
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20,
                                  fontFamily: "IBM Plex Sans",
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: pastList.length,
                            itemBuilder: (context, index) {
                              return launchpadItem(
                                  width: width,
                                  height: height,
                                  image: pastList[index]['image'] ?? '',
                                  status: 'Past',
                                  expireAt: pastList[index]['expired_at'] ?? '',
                                  name: pastList[index]['name'] ?? '',
                                  symbol: pastList[index]['symbol'] ?? '',
                                  disclaimer:
                                      pastList[index]['disclaimer'] ?? '',
                                  data: pastList[index]);
                            },
                          ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : upcomingList.isEmpty
                        ? Center(
                            child: Text(
                              error != ''
                                  ? '$error'
                                  : 'No Upcoming Launchpads Available ~ Please Check later',
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20,
                                  fontFamily: "IBM Plex Sans",
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: upcomingList.length,
                            itemBuilder: (context, index) {
                              return launchpadItem(
                                  width: width,
                                  height: height,
                                  image: upcomingList[index]['image'] ?? '',
                                  status: 'Upcoming',
                                  expireAt:
                                      upcomingList[index]['expired_at'] ?? '',
                                  name: upcomingList[index]['name'] ?? '',
                                  symbol: upcomingList[index]['symbol'] ?? '',
                                  disclaimer:
                                      upcomingList[index]['disclaimer'] ?? '',
                                  data: upcomingList[index]);
                            },
                          ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget launchpadItem({
    @required double width,
    @required double height,
    @required String image,
    @required String status,
    @required String expireAt,
    @required String name,
    @required String symbol,
    @required String disclaimer,
    @required dynamic data,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LaunchPadDetail(
                  data: data,
                  status: status,
                ),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: day ? Colors.black : Colors.white,
                            width: 0.3)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image,
                        fit: BoxFit.fill,
                        height: height * 0.3,
                        width: width,
                        errorBuilder: (context, error, stackTrace) => SizedBox(
                          height: height * 0.3,
                          width: width,
                          child: Center(
                            child: Text('Image Not Available'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff17394f),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            status,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff17394f),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            expireAt,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: width * 0.03,
                    top: height * 0.23,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          symbol,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              width: width,
              height: height * 0.04,
              child: SingleChildScrollView(
                child: Text(
                  disclaimer,
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            if (status == 'Live')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.05,
                    width: width * 0.5,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                width: 0.3)),
                            backgroundColor: MaterialStateProperty.all(
                              Color(0xff17394f),
                            )),
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LaunchPadDetail(
                                  data: data,
                                  status: status,
                                ),
                              ));
                        }),
                        child: Text(
                          'Participate',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            if (status == 'Live')
              SizedBox(
                height: height * 0.01,
              ),
            Divider(
              color: day ? Colors.black : Colors.white,
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
