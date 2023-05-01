// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:exchange/library/intro_views_flutter-2.4.0/lib/Constants/constant.dart';
import 'package:flutter/material.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/ToastClass.dart';
import 'Phone_Verify.dart';
import 'login.dart';

class forgetPassword extends StatefulWidget {
  @override
  _forgetPasswordState createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  bool isclick = false;
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKeys,
      child: Scaffold(
        backgroundColor: blackColor,
        body: Stack(
          children: <Widget>[
            ///
            /// Set image in top
            ///
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, right: 5, left: 5),
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Text("Forgot Password", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Enter your email and we′ll send you ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("link to reset your password", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 40.0),
                          child: Container(
                            // color: Colors.yellow,
                            height: screenSize.height * 0.1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: screenSize.height * 0.04,
                                  right: screenSize.height * 0.04,
                                  top: screenSize.height * 0.01),
                              child: TextFormField(
                                validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : "Email cannot be empty",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                ),
                                textAlign: TextAlign.start,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                //obscureText: true,
                                autofocus: false,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color(0xff212529),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color(0xff212529),
                                      )),

                                  filled: true, //<-- SEE HERE

                                  fillColor: Color(0xff212529),
                                  border: InputBorder.none,
                                  hintText: "Enter email address",
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  contentPadding: EdgeInsets.all(0.0),

                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "IBM Plex Sans",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 30.0),
                          child: InkWell(
                            onTap: () {
                              if (_formKeys.currentState.validate()) {
                                setState(() {
                                  isclick = true;
                                });
                                forgetpassord(_emailController.text);
                              } else {
                                setState(() {
                                  isclick = false;
                                });
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Color(0xff212529),
                              ),
                              child: Center(
                                child: isclick == true
                                    ? Container(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text("Send Verification Email", style: TextStyle(fontFamily: "IBM Plex Sans", color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 1.0),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 22.0, right: 22.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new login()));
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xffc79509),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.35,
                                ),
                              ),
                              child: Center(
                                child: Text("Already Have an Account ? Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 1.2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> forgetpassord(String email) async {
    final paramDic = {
      "email": email.toString(),
    };
    var response;
    response =
        await LBMAPIMainClass(APIClasses.LBM_forgetpassword, paramDic, "Post");

    var data = json.decode(response.body);

    if (data["status_code"] == '1') {
      setState(() {
        isclick = false;
      });
      ToastShowClass.toastShow(context, data['message'], Colors.blue);
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              new PhoneScreen(screen_name: "Password")));
    } else {
      setState(() {
        isclick = false;
      });
      ToastShowClass.toastShow(context, data['message'], Colors.blue);
    }
  }
}
