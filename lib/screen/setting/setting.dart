// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/intro/login.dart';
import 'package:exchange/screen/setting/Authentication.dart';
import 'package:exchange/screen/setting/KYC.dart';
import 'package:exchange/screen/setting/Report.dart';
import 'package:exchange/screen/setting/changepassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'Log.dart';
import 'Price_Notification.dart';
import 'Support.dart';

class setting extends StatefulWidget {
  ///
  /// Get data bloc from
  ///
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  ///
  /// Bloc for double theme
  ///
  bool theme = true;
  String selectedCurrency = "USDT";
  String user_name;
  String user_email;
  String user_image;
  String login_status;
  String token;
  String status;
  String Number;
  String ref_link;
  String kyc_status;
  String kyc_msg;
  String fees;

  bool isDarkModeEnabled = day == true ? false : true;

  @override
  void initState() {
    getdata();
    Getverification();
    super.initState();
  }

  Future<void> Getverification() async {
    final paramDic = {
      "": "",
    };
    print(paramDic);
    var response;
    response = await APIMainClassbinance(APIClasses.kyc_verify, paramDic, "Get");
    var data = json.decode(response.body);
    print(data);
    if (data["status_code"] == '1') {
      print("KYC DATA " + data.toString());
      setState(() {
        Verifiedstatus = data['data']['user_kyc_status'];
        kyc_msg = data['data']['user_kyc_status_message'];
        print("KYC STATUS ??   " + kyc_msg + Verifiedstatus.toString());
        //isSwitched=isSwitched;
      });
    } else {
      // ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  getdata() async {
    //selected_currency=await SharedPreferenceClass.GetSharedData('Currency');
    user_name = await SharedPreferenceClass.GetSharedData('name');
    user_email = await SharedPreferenceClass.GetSharedData('email');
    // user_image = await SharedPreferenceClass.GetSharedData('profile_image');
    token = await SharedPreferenceClass.GetSharedData('token');
    status = await SharedPreferenceClass.GetSharedData('status');
    // Number = await SharedPreferenceClass.GetSharedData('number');
    // ref_link = await SharedPreferenceClass.GetSharedData('ref_link');
    kyc_status = await SharedPreferenceClass.GetSharedData('kyc_status');
    // kyc_msg=await SharedPreferenceClass.GetSharedData('kyc_msg');
    fees = await SharedPreferenceClass.GetSharedData('fees');
    login_status = await SharedPreferenceClass.GetSharedData("isLogin");
    print(token.toString());


    setState(() {
      user_name = user_name;
      user_email = user_email;
      // user_image = user_image;
      login_status = login_status;
      status = status;
      // Number = Number;
      // ref_link = ref_link;
      kyc_status = kyc_status;
      // kyc_msg=kyc_msg;
      fees = fees;
      // Verifiedstatus = kyc_status;
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> logout(String SingleALL) async {
    final paramDic = {"": ""};
    print(paramDic.toString());
    var uri;
    if (SingleALL == "All") {
      uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.logoutall);
    } else {
      uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.logout);
    }
    print(uri.toString());

    HttpClient httpClient = HttpClient();

    HttpClientRequest request = await httpClient.deleteUrl(uri);
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer ' + await SharedPreferenceClass.GetSharedData('token'));

    request.add(utf8.encode(json.encode(paramDic)));
    HttpClientResponse response = await request.close();
    // var response = await LBMAPIMainClass(APIClasses.LBM_register, paramDic, "Post");
    String reply = await response.transform(utf8.decoder).join();
    print(reply.toString());
    print(request.headers.toString());
    var data = jsonDecode(reply);
    print(data);
    if (data["status_code"] == "1") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => login()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Current Status" + day.toString());
    return Scaffold(
      backgroundColor: day == false ? Colors.black : Color(0xfff6f6f6),
      body: Container(
        color: day == false ? Colors.black : Color(0xfff6f6f6),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 15),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          // ),
                        },
                        child: Icon(Icons.arrow_back_ios, color: day == false ? Colors.white : Colors.black)),
                    Text(
                      "Settings",
                      style: TextStyle(
                          color: day == false ? Colors.white : Colors.black,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 25.5,
                          fontWeight: FontWeight.w700),
                    ),
                    Spacer(),
                    DayNightSwitcher(
                      dayBackgroundColor: Colors.grey,
                      moonColor: Color(0xffc79509),
                      isDarkModeEnabled: isDarkModeEnabled,
                      onStateChanged: (isDarkModeEnabled) {
                        setState(() {
                          this.isDarkModeEnabled = isDarkModeEnabled;
                          setState(() {
                            SharedPreferenceClass.SetSharedData(
                                "day",
                                isDarkModeEnabled == true ? "dayfalse" : "daytrue");
                            day = isDarkModeEnabled == true ? false : true;
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => new bottomNavBar(
                                      index: 0,
                                    )));
                          });
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 110.0, left: 5.0, right: 5.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      login_status == "true"
                          ? Padding(padding: const EdgeInsets.only(left: 0.0, top: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: day == false
                                    ? Color(0xff181818)
                                    : Color(0xffffffff),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 8, bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: const EdgeInsets.only(top: 8.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset(
                                            'assets/image/logo2.png',
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(user_name != null ? user_name : '', style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 15.5, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(user_email, style: TextStyle(fontFamily: "IBM Plex Sans", color: day == false ? Color(0xffadadad) : Color(0xff939393), fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 15.0,
                            ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5, top: 5),
                            child: Container(
                              height: 190,
                              width: 400,
                              decoration: BoxDecoration(
                                  color: day == false ? Color(0xff181818) : Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/change password.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          new ChangePassword()));
                                            },
                                            child: Text("  Change Password", style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 13.5, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700)))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/kyc.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          new VerifyKYC(
                                                            kyc_msg: kyc_msg,
                                                            kyc_Status:
                                                                kyc_status,
                                                          )));
                                            },
                                            child: Text("KYC", style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 14, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700))),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/2FA.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          new TwoFactorAuth()));
                                            },
                                            child: Text("2FA", style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 14, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5,
                        ),
                        child: Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                              color: day == false
                                  ? Color(0xff181818)
                                  : Color(0xffffffff),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/image/report.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      new Report()));
                                        },
                                        child: Text("  Report",style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 14, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700)))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.notifications_active,
                                      size: 30,
                                      color: day == false
                                          ? Colors.white
                                          : Color(0xff919191),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      new PriceNotification()));
                                        },
                                        child: Text("  Notifications ",style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 14, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/image/log.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      new ActivityLog()));
                                        },
                                        child: Text("  Log Activity", style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 14, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: 80,
                          width: 400,
                          decoration: BoxDecoration(
                              color: day == false ? Color(0xff181818) : Color(0xffffffff),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/image/logout.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          visible:
                                          login_status == "true" ? true : false;
                                          popupdialog();
                                        },
                                        child: Text("  Logout", style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 15.5, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: 80,
                          width: 400,
                          decoration: BoxDecoration(
                              color: day == false ? Color(0xff181818) : Color(0xffffffff),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.support_agent_outlined,
                                      size: 30,
                                      color: day == false
                                          ? Colors.white
                                          : Color(0xff919191),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Support()));
                                        },
                                        child: Text("  Support", style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 14, color: day == false ? Colors.white : Colors.black, fontWeight: FontWeight.w700)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void popupdialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Please Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Are you sure, you want to Logout?'),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Logout from all devices', style: TextStyle(color: Color(0xffc79509)),
              ),
              onPressed: () {
                logout("All");
              },
            ),
            TextButton(
              child: Text('Logout from this device', style: TextStyle(color: Color(0xffc79509)),),
              onPressed: () {
                logout("Single");
              },
            ),
          ],
        );
      },
    );
  }
}
