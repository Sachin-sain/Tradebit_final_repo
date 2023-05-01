import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/screen/intro/Phone_Verify.dart';
import 'package:flutter/material.dart';

import '../../library/intro_views_flutter-2.4.0/lib/Constants/constant.dart';
import 'Term_condition.dart';
import 'login.dart';

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

const htmlData = '';
var terms = [];

class _signUpState extends State<signUp> {
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  bool registered = false;
  bool password = false;
  bool referal = false;
  bool agree = false;
  @override
  void initState() {
    termconditions();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  bool _passwordVisible = true;
  bool _passwordconfirmVisible = true;

  Future<void> termconditions() async {
    final paramDic = {"": ""};
    var response;
    response =
        await LBMAPIMainClass(APIClasses.termconditions, paramDic, "Get");
    print(response);
    var data = json.decode(response.body);
    if (data["status_code"] == "1") {
      setState(() {
        terms = data['data'];
      });
      print(terms);
    } else {
      terms = "No Term Condition" as List;
    }
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Form(
      key: _formKeys,
      child: Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                            height: 120,
                            width: 120,
                            child: Image.asset('assets/image/logo2.png',)),
                      ),
                      Text("Register To Tradebit", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text("Register now to make trade simple", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Column(
                        children: <Widget>[
                          Container(
                            // color: Colors.green,
                            height: screenSize.height * 0.07,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.height * 0.03,
                                right: screenSize.height * 0.03,
                                top: screenSize.height * 0.02,
                              ),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,

                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Please type an user name';
                                  }
                                  return null;
                                },
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                ),
                                textAlign: TextAlign.start,
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                //obscureText: true,
                                autofocus: false,
                                cursorColor: Colors.white,
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
                                  hintText: " Enter Username",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: "IBM Plex Sans",
                                  ),
                                  labelText: " username",
                                  labelStyle: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                  contentPadding: EdgeInsets.all(5.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            height: screenSize.height * 0.09,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.height * 0.03,
                                right: screenSize.height * 0.03,
                                top: screenSize.height * 0.02,
                              ),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,

                                validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : "Please enter a valid email",

                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                ),
                                textAlign: TextAlign.start,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                cursorColor: Colors.white,
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
                                  hintText: " Enter email address",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: "IBM Plex Sans",
                                  ),
                                  labelText: " Email",
                                  labelStyle: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                  contentPadding: EdgeInsets.all(5.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: screenSize.height * 0.07,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: screenSize.height * 0.03,
                                  right: screenSize.height * 0.03,
                                  top: screenSize.height * 0.00),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Please type your password';
                                  }
                                  return null;
                                },
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                ),
                                textAlign: TextAlign.start,
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                obscureText: _passwordVisible,
                                autofocus: false,
                                cursorColor: Colors.white,
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
                                  hintText: "Enter password",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: "IBM Plex Sans",
                                  ),
                                  labelText: " Password",
                                  labelStyle: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                  contentPadding: EdgeInsets.all(5.0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white, size: 18,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            //color: Colors.pink,
                            height: screenSize.height * 0.07,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.height * 0.03,
                                right: screenSize.height * 0.03,
                                top: screenSize.height * 0.00,
                              ),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (input) {
                                  if (input.isEmpty) {
                                    if (_passwordController.text.isNotEmpty) {
                                      return 'Please type confirm password';
                                    }
                                    return null;
                                  } else if (input !=
                                      _passwordController.text) {
                                    return 'Confirm Password not Match';
                                  } else {
                                    // setState(() {
                                    //   password=true;
                                    // });
                                    return null;
                                  }
                                },
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                ),
                                textAlign: TextAlign.start,
                                controller: _confirmpasswordController,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                obscureText: _passwordconfirmVisible,
                                autofocus: false,
                                cursorColor: Colors.white,
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
                                  hintText: " Enter confirm password",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: "IBM Plex Sans",
                                  ),
                                  labelText: " confirmpassword",
                                  labelStyle: TextStyle(
                                      color: Colors.white70, fontSize: 14),

                                  contentPadding: EdgeInsets.all(5.0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordconfirmVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white, size: 18,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordconfirmVisible =
                                            !_passwordconfirmVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Visibility(
                                visible: referal == false ? true : false,
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        referal = true;
                                      });
                                    },
                                    child: Center(
                                        child: Text("Referral Code(Optional)",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white))))),
                          ),
                          Visibility(
                            visible: referal == true ? true : false,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  //   color: Colors.black,
                                  height: screenSize.height * 0.11,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: screenSize.height * 0.03,
                                        right: screenSize.height * 0.03,
                                        top: screenSize.height * 0.00),
                                    child: TextFormField(
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontFamily: "IBM Plex Sans",
                                      ),
                                      textAlign: TextAlign.start,
                                      controller: _referralController,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      //obscureText: true,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: Color(0xff212529),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: Color(0xff212529),
                                            )),
                                        filled: true, //<-- SEE HERE
                                        fillColor: Color(0xff212529),
                                        border: InputBorder.none,
                                        hintText: " Refferal Code ",
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontFamily: "IBM Plex Sans",
                                        ),
                                        labelText: " Refferal Code",
                                        labelStyle: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                        contentPadding: EdgeInsets.all(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.height * 0.03,
                                right: screenSize.height * 0.04,
                                top: screenSize.height * 0.00),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      agree = !agree;
                                    });
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    color: agree == true
                                        ? Colors.green
                                        : Colors.white,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                new Terms()));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: screenSize.height * 0.02,
                                        right: screenSize.height * 0.04,
                                        top: screenSize.height * 0.00),
                                    child: Text("Agree to terms and conditions.", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 30.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              registered = true;
                            });
                            final formState = _formKeys.currentState;
                            if (formState.validate()) {
                              if (_confirmpasswordController.text ==
                                  _passwordController.text) {
                                if (agree == true) {
                                  _registerUser(agree);
                                }
                              } else {
                                setState(() {
                                  password = true;
                                  registered = false;
                                });
                              }
                            } else {
                              setState(() {
                                registered = false;
                                password = true;
                              });
                            }
                          },
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Color(0xffc79509),
                            ),
                            child: Center(
                              child: registered == true
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )
                                  : Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: TextStyle(color: Colors.white70, fontSize: 14,)),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new login()));
                              },
                              child: Center(
                                child: Text("Sign In", style: TextStyle(color: Color(0xffc79509), fontFamily: "IBM Plex Sans", fontWeight: FontWeight.w600, fontSize: 15,
                                  ),
                                ),
                              ))
                        ],
                      )
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

  Future<String> _registerUser(bool terms) async {
    final paramDic = {
      "name": _usernameController.text.toString(),
      "email": _emailController.text.toString(),
      "referral": _referralController.text.toString(),
      "password": _passwordController.text.toString(),
      "confirm_password": _confirmpasswordController.text.toString(),
      "terms": terms,
    };
    print(paramDic.toString());
    // print(APIClasses.LBM_BaseURL);
    // print(APIClasses.LBM_register);
    final uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.LBM_register);
    print(uri);

    print(uri.toString());

    HttpClient httpClient = HttpClient();

    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('content-type', 'application/json');

    request.add(utf8.encode(json.encode(paramDic)));
    HttpClientResponse response = await request.close();
    // var response = await LBMAPIMainClass(APIClasses.LBM_register, paramDic, "Post");
    String reply = await response.transform(utf8.decoder).join();
    var data = jsonDecode(reply);
    print(data);

    if (data["status_code"] == '1') {
      registered = false;

      ToastShowClass.toastShow(context, data["message"], Colors.blue);
      // SharedPreferenceClass.SetSharedData("isLogin", "true");
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => PhoneScreen()));
    } else {
      setState(() {
        registered = false;
      });
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }
}
