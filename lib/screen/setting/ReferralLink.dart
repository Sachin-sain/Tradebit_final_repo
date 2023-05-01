// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralLink extends StatefulWidget {
  String link;

  ReferralLink({this.link});

  @override
  _ReferralLink createState() => _ReferralLink();
}

class _ReferralLink extends State<ReferralLink> {
  TextEditingController referralcode = new TextEditingController();
  TextEditingController referrallink = new TextEditingController();

  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  int page = 1;

  List referreldata = [];
  String total;
  @override
  void initState() {
    referral_link(page.toString());

    referralcode.text = widget.link;
    referrallink.text = "https://" +
        APIClasses.LBM_BaseURL +
        "/signup?referral=" +
        referralcode.text;
    super.initState();
  }

  Future<void> referral_link(String value) async {
    final paramDic = {
      "page": value.toString(),
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.referrallink, paramDic, "Get");
    var data = json.decode(response.body);
    print(response);
    referreldata.clear();
    if (data["status_code"] == '1') {
      referreldata = data["data"];
      total = data['total'];
      print("d a t a  " + referreldata.toString());
    } else {
      setState(() {
        referreldata.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKeys,
      child: Scaffold(
        //appBar: AppBar(title: Text("Referral Link"),backgroundColor: Color(0xff17394f),),
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: screenSize.height / 3.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffc79509),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.05, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: screenSize.width * 0.25),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                          ),
                          Text(
                            "Invite & Earn",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Tradebit Referral Program",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                            '''Refer & earn 40% of trading fee paid by your friend 
                        as reward. Be your own Boss!
                        ''',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: "IBM Plex Sans",
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenSize.height * 0.25, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 80,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffc79509),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: day == false
                                        ? Colors.white24
                                        : Colors.black26,
                                    offset: Offset(5, 5),
                                    blurRadius: 10)
                              ]),
                          child: Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("TOTAL REFERRALS",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w400)),
                                Text(total == null ? "0" : total.toString(),
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffc79509),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: day == false
                                        ? Colors.white24
                                        : Colors.black26,
                                    offset: Offset(5, 5),
                                    blurRadius: 10)
                              ]),
                          child: Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("TOTAL REWARDS",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w400)),
                                Text(total == null ? "0.00 " : total.toString(),
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffc79509),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: day == false
                                        ? Colors.white24
                                        : Colors.black26,
                                    offset: Offset(5, 5),
                                    blurRadius: 10)
                              ]),
                          child: Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("YOUR REWARD RATE",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w400)),
                                Text("40%",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontFamily: "IBM Plex Sans",
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: day == false ? Colors.black : Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: day == false
                                  ? Colors.white24
                                  : Colors.black26,
                              offset: Offset.fromDirection(3.0, 2.0),
                              blurRadius: 10)
                        ]),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          "Share your link & earn more!",
                          style: TextStyle(
                              color: day == false ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: day == false
                                    ? Colors.white24
                                    : Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: [
                              Text(referrallink.text.toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 11,
                                      fontFamily: "IBM Plex Sans",
                                      fontWeight: FontWeight.w600)),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: referrallink.text.toString()))
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Copied")));
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white24),
                                      color:Color(0xffc79509),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                    ),
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                      size: 18,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/icon/facebook.png',
                              height: 40,
                              width: 50,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/image/icon/twitter.png',
                              height: 45,
                              width: 55,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/image/icon/insta.png',
                              height: 40,
                              width: 50,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/image/icon/telegram.png',
                              height: 40,
                              width: 50,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "(Your Code: ${referralcode.text.toString()})",
                          style: TextStyle(
                              color: day == false ? Colors.white : Colors.black,
                              fontSize: 12,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tool() {
    return Tooltip(
      message: "Copied",
      triggerMode: TooltipTriggerMode.tap,
    );
  }

  Widget loadingCardData(BuildContext ctx, int i) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Username",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Email",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Direct Sponser ID",
                    style: TextStyle(
                        fontSize: 12,
                        color: day == false ? Colors.white : Colors.black)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Status",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Created at",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: day == false ? Colors.white : Color(0xff17394f),
          height: 15,
          thickness: 1.0,
        ),
      ],
    );
  }

  HeaderList() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Username",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Email",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Direct Sponser ID",
                    style: TextStyle(
                        fontSize: 12,
                        color: day == false ? Colors.white : Colors.black)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Status",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text(
                  "Created at",
                  style: TextStyle(
                      fontSize: 12,
                      color: day == false ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
