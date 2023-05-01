// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:exchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../../config/APIClasses.dart';
import '../../../config/APIMainClass.dart';
import '../../../config/SharedPreferenceClass.dart';
import '../../../config/ToastClass.dart';
import '../../../config/constantClass.dart';
import '../../../library/intro_views_flutter-2.4.0/lib/Constants/constant.dart';

class WithdrawOtp extends StatefulWidget {
  const WithdrawOtp({Key key}) : super(key: key);

  @override
  State<WithdrawOtp> createState() => _WithdrawOtpState();
}

class _WithdrawOtpState extends State<WithdrawOtp> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  var fifthController = TextEditingController();
  var sixthController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();
  FocusNode fifthFocusNode = FocusNode();
  FocusNode sixthFocusNode = FocusNode();
  bool done = false;
  String user_email;
  String msg;

  @override
  void initState() {
    getinfo();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  getinfo() async {
    user_email = await SharedPreferenceClass.GetSharedData('email');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor:colorStyle.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Two Factor Authentication',
          style: appBarTextStyle,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 12.0,
            color: whiteColor,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
              PageRouteBuilder(pageBuilder: (_, __, ___) =>bottomNavBar(index: 3,))),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(fixPadding * 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          color: whiteColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Verification',
                    style: black18MediumTextStyle,
                  ),
                  heightSpace,
                  Text(
                    'Enter the OTP code from the email we just sent you.',
                    style: black14RegularTextStyle,
                  ),
                  heightSpace,
                  heightSpace,
                  // OTP Box Start
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // 1 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.5, color: primaryColor),
                        ),
                        child: TextField(
                          controller: firstController,
                          style: black16RegularTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context)
                                .requestFocus(secondFocusNode);
                          },
                        ),
                      ),
                      // 1 End
                      // 2 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.5, color: primaryColor),
                        ),
                        child: TextField(
                          focusNode: secondFocusNode,
                          controller: secondController,
                          style: black16RegularTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context).requestFocus(thirdFocusNode);
                          },
                        ),
                      ),
                      // 2 End
                      // 3 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.5, color: primaryColor),
                        ),
                        child: TextField(
                          focusNode: thirdFocusNode,
                          controller: thirdController,
                          style: black16RegularTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context)
                                .requestFocus(fourthFocusNode);
                          },
                        ),
                      ),
                      // 3 End
                      // 4 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.5, color: primaryColor),
                        ),
                        child: TextField(
                          focusNode: fourthFocusNode,
                          controller: fourthController,
                          style: black16RegularTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context).requestFocus(fifthFocusNode);
                          },
                        ),
                      ),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.5, color: primaryColor),
                        ),
                        child: TextField(
                          focusNode: fifthFocusNode,
                          controller: fifthController,
                          style: black16RegularTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context).requestFocus(sixthFocusNode);
                          },
                        ),
                      ),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200].withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.5, color: primaryColor),
                        ),
                        child: TextField(
                          focusNode: sixthFocusNode,
                          controller: sixthController,
                          style: black16RegularTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          // onChanged: (v) {
                          //   loadingDialog();
                          // },
                        ),
                      ),
                      // 4 End
                    ],
                  ),
                  // OTP Box End
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // InkWell(
                //   onTap: () {
                //   },
                //   child: Text(
                //     'Resend Otp',
                //     style: primaryColor16MediumTextStyle,
                //   ),
                // ),
                heightSpace,
                InkWell(
                  borderRadius: BorderRadius.circular(7.0),
                  onTap: () {
                    setState(() {
                      done = true;
                      String otp = firstController.text +
                          secondController.text +
                          thirdController.text +
                          fourthController.text +
                          fifthController.text +
                          sixthController.text;
                      _emailverify(otp).then((value) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(msg.toString()),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              bottomNavBar(index: 0,)));
                                },
                                child: Container(
                                  color: Color(0xff62c5dd),
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("okay",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
                    // Navigator.push(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.rightToLeft,
                    //      ));
                  },
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      gradient: LinearGradient(
                          // begin: Alignment.centerLeft,
                          // end: Alignment.bottomRight,
                          // stops: [0.1, 0.6, 1.0],
                          colors: [Color(0xff191d26), Color(0xff283745)]),
                    ),
                    child: done == false
                        ? Text(
                            'Continue',
                            // style: white16MediumTextStyle,
                          )
                        : Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _emailverify(String otp) async {
    print(user_email);
    final paramDic = {
      "email": user_email.toString(),
      "otp": otp.toString(),
    };
    var response;
    response =
        await LBMAPIMainClass(APIClasses.Validatewalletotp, paramDic, "Post");
    var data = json.decode(response.body);
    if (data["status_code"] == '1') {
      getCryptoData();
      setState(() {
        msg = data['message'].toString();
      });
      // ToastShowClass.toastShow(context, data['message'], Colors.red);

      // Navigator.of(context).push(PageRouteBuilder(
      //     pageBuilder: (_, __, ___) => new PortfolioScreen()));

      setState(() {
        done = false;
      });
    } else {
      print(response.body);
      ToastShowClass.toastShow(context, data['message'], Colors.red);
      setState(() {
        msg = data['message'].toString();
        done = false;
      });
    }
  }
}
