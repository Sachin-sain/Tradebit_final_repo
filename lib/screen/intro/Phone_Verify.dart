// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/SharedPreferenceClass.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';
import '../../library/intro_views_flutter-2.4.0/lib/Constants/constant.dart';
import '../Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'login.dart';
import 'newpasswordset.dart';
class PhoneScreen extends StatefulWidget {
String screen_name='';

PhoneScreen({this.screen_name});
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  var firstController = TextEditingController();
  bool isfetched=false;
  bool done=false;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
     backgroundColor:Color(0xff143047),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Confirm Verification Code', style: appBarTextStyle,),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 12.0,
            color: whiteColor,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new login())),
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
                  Text('Verification', style: black18MediumTextStyle,),
                  heightSpace,
                  Text('Enter the verification code from the email we just sent you.', style: black14RegularTextStyle,),
                  heightSpace,
                  heightSpace,
                  // OTP Box Start
                  TextField(

                    controller: firstController,
                    style: black16RegularTextStyle,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      contentPadding: EdgeInsets.all(15.0),
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
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
                //     _resend(widget.otpid);
                //   },
                //   child: Text(
                //     'Resend Otp',
                //     style: primaryColor16MediumTextStyle,
                //   ),
                // ),
                // heightSpace,
                InkWell(
                  borderRadius: BorderRadius.circular(7.0),
                  onTap: () {
                    if(isfetched==false){
                      setState(() {
                        done=true;
                        String otp= firstController.text;
                        _phoneverify(otp.toString());
                      });
                    }else{
                    }
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
                        colors: [
                          Color(0xff17394f),Color(0xff283745)]),
                    ),
                    child:done==false? Text(
                      'Continue',
                      style: white16MediumTextStyle,
                    ):CircularProgressIndicator(color:Colors.white,)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _phoneverify(String otp) async {
    final paramDic = {
      "token": otp.toString(),
    };
    print(paramDic);
    var response;
if(widget.screen_name=="Password"){
  response = await LBMAPIMainClass(APIClasses.passwordvalid, paramDic, "Post");
  var data = json.decode(response.body);
  if(data["status_code"]=='1'){
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new NewPassword(token: otp.toString(),)));
  }else{
    ToastShowClass.toastShow(context, data["msg"], Colors.red);
  }

}else{
  response = await LBMAPIMainClass(APIClasses.LBM_phoneverify, paramDic, "Post");
  var data = json.decode(response.body);
  if(data["status_code"]=='1'){
    setState(() {
      isfetched=true;
      done=false;
    });
    // print(data.toString());
    // ToastShowClass.toastShow(context, data['message'].toString(),Colors.blue);
    // print("with 00000000           000              0      "+data['data'][0]['user']['name']);
    SharedPreferenceClass.SetSharedData("token", data['data']['token']);
    SharedPreferenceClass.SetSharedData("name", data['data']['user']['name']);
    SharedPreferenceClass.SetSharedData("id", data['data']['user']['id'].toString());
    SharedPreferenceClass.SetSharedData("email", data['data']['user']['email']);
    SharedPreferenceClass.SetSharedData("profile_image", data['data']['user']['profile_image']);
    SharedPreferenceClass.SetSharedData("ref_link", data['data']['user']['referral_code']);
    SharedPreferenceClass.SetSharedData("number", data['data']['user']['mobile']);
    SharedPreferenceClass.SetSharedData("kyc_status", data['data']['user']['user_kyc_status']);
    SharedPreferenceClass.SetSharedData("kyc_msg", data['data']['user']['user_kyc_status_message']);
    SharedPreferenceClass.SetSharedData("fees", (data['data']['user']['fee_by_lbm']).toString());
    SharedPreferenceClass.SetSharedData("status", (data['data']['user']['status']).toString());
    SharedPreferenceClass.SetSharedData("isLogin", "true");
    getCryptoData();

    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>bottomNavBar(index: 0,)),
      );
    });
  }
  else{
    setState(() {
      done=false;
      isfetched=false;

    });
    ToastShowClass.toastShow(context, "Verification failed", Colors.red);
  }

}
  }


  // Future<void> _resend(int id) async {
  //   final paramDic = {
  //     "otp": '',
  //   };
  //   print(paramDic);
  //   var response = await LBMAPIMainClass(APIClasses.LBM_resendotp+id.toString(), paramDic, "Post");
  //   var data = json.decode(response.body);
  //   print(response);
  //
  //   if(data["status_code"]=='1'){
  //     ToastShowClass.toastShow(context, data["data"]['otp'].toString(), colorStyle.primaryColor);
  //     print("third otp    "+ data["data"]['otp'].toString());
  //     // setState(() {
  //     //   Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(builder: (context) =>bottomNavBar() ),
  //     //   );
  //     // });
  //   }
  //   else{
  //     ToastShowClass.toastShow(context, data["message"], Colors.red);
  //   }
  // }
}
