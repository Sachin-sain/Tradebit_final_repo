// ignore_for_file: must_call_super, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';

enum SingingCharacter { lafayette, jefferson }

class TwoFactorAuth extends StatefulWidget {
  @override
  _TwoFactorAuthState createState() => _TwoFactorAuthState();
}

class _TwoFactorAuthState extends State<TwoFactorAuth> {
  int _radioSelected = 1;

  initState() {
    Getverification();
  }

  Future<void> verification(String value) async {
    final paramDic = {
      "two_factor": value == 2 ? "0" : "2",
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.authverify, paramDic, "Post");
    var data = json.decode(response.body);
    print(response);
    if (data["status_code"] == '1') {
      ToastShowClass.toastShow(context, data["message"], Colors.blue);
    } else {
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  Future<void> Getverification() async {
    final paramDic = {
      "": "",
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.authverifyget, paramDic, "Get");
    var data = json.decode(response.body);
    print(response);
    if (data["status_code"] == '1') {
      print(data.toString());
      setState(() {
        _radioSelected = data['data']['_2fa'];
        print(_radioSelected.toString());
      });
    } else {
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: day == false ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: day == false ? Colors.black : Colors.white,
        title: Text("2F Authentication Setting",
            style: TextStyle(
                fontFamily: "IBM Plex Sans",
                color: day == false ? Colors.white : Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: day == false ? Colors.white : Colors.black,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Email Verification",
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Recommended",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                color: Colors.green[900],
                              ),
                            ),
                          ],
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                day == false ? Colors.white : Colors.black,
                          ),
                          child: Radio(
                            value: 1,
                            groupValue: _radioSelected,
                            activeColor:
                                day == false ? Colors.white : Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: day == false ? Colors.white : Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text("None",
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Non Recommended",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                color: Colors.red[900],
                              ),
                            ),
                          ],
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                day == false ? Colors.white : Colors.black,
                          ),
                          child: Radio(
                            value: 2,
                            groupValue: _radioSelected,
                            activeColor:
                                day == false ? Colors.white : Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xffc79509),
                    borderRadius: BorderRadius.circular(5.0)),
                child: GestureDetector(
                  onTap: () {
                    verification(_radioSelected.toString());
                  },
                  // color:Colors.redAccent,
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
