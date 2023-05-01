// ignore_for_file: non_constant_identifier_names, must_call_super

import 'dart:convert';

import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/SharedPreferenceClass.dart';
import '../../config/constantClass.dart';

class ActivityLog extends StatefulWidget {
  static const routeName = '/ActivityLog';

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

List loglist = [];
List loglistMore = [];
int page = 1;
ScrollController _controller;

bool _isLoadMoreRunning = false;
bool _isnomorerecord = false;

class _ActivityLogState extends State<ActivityLog> {
  String login_status;
  initState() {
    getCurrency();

    Getlog();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  getCurrency() async {
    login_status = await SharedPreferenceClass.GetSharedData("isLogin");
    setState(() {
      login_status = login_status;
    });
  }

  void _loadMore() async {
    if (_isnomorerecord == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      page += 1; // Increase _page by 1

      Getlog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Activity Log Detail",
              style: TextStyle(
                fontFamily: "IBM Plex Sans",
                color: day == false ? Colors.white : Colors.black,
              )),
          backgroundColor: day == false ? Colors.black : Colors.white,
        ),
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: loglist.length > 0
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: loglist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: day == true
                                    ? Colors.black12
                                    : Colors.white12,
                              )),
                              // color: day==true?Colors.black12:Colors.white10,
                              // height: 130,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 100,
                                            child: Text(
                                              "Date:",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                            DateFormat("dd-MMM-yyyy hh:mm:ss")
                                                .format(DateTime.parse(
                                                        loglist[index]
                                                                ['created_at']
                                                            .toString())
                                                    .toLocal())
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: day == false
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 100,
                                            child: Text(
                                              "IP:",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                            width: 150,
                                            child: Text(
                                                loglist[index]['ip'].toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black,
                                                ))),
                                      ],
                                    ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 100,
                                            child: Text(
                                              "Activity:",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                            loglist[index]['message']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isLoadMoreRunning == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Center(
                        child: Container(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              )
            : Center(
                child: Container(
                child: Text(
                  "Activity log is empty",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: day == false ? Colors.white : Colors.black,
                      fontFamily: "IBM Plex Sans"),
                ),
              )));
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    page = 1;
    super.dispose();
  }

  Future<void> Getlog() async {
    final paramDic = {
      "page": page.toString(),
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.logGet, paramDic, "Get");
    var data = json.decode(response.body);
    print(response);
    if (page == 1) {
      loglist.clear();
    }
    loglistMore.clear();
    if (data["status_code"] == '1') {
      setState(() {
        if (data['data']['last_page'] >= page) {
          loglistMore = data['data']['data'];
          loglist.addAll(loglistMore);
          print("LOG CAT " + loglist.toString());
          _isnomorerecord = false;
          _isLoadMoreRunning = false;
        } else {
          page = page - 1;
          _isnomorerecord = true;
          ToastShowClass.toastShow(context, "No More Record", Colors.red);
          _isLoadMoreRunning = false;
        }
      });
    } else {
      setState(() {
        loglist.clear();
      });
    }
  }
}
