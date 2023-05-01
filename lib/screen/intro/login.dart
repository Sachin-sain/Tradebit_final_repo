// ignore_for_file: camel_case_types, unused_element, unused_field, override_on_non_overriding_member, non_constant_identifier_names, must_call_super, unused_local_variable

import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:exchange/screen/intro/signup.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/SharedPreferenceClass.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';
import '../Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'forget_password.dart';
import 'otp_screen.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

enum _VerificationStep { showingButton, working, error, verified }

class _loginState extends State<login> {
  String captchaToken = '';
  bool ignorestatus = true;
  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool login = false;
  String _email, _pass;
  bool _isChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = true;
  final String RECAPTCHA_SECRET_KEY =
      "6LeUofckAAAAAMnPjQJ-8h8DmPX35AK4Ne_BD8_I";

  final String RECAPTCHA_VERIFY_URL =
      "https://www.google.com/recaptcha/api/siteverify";

  initState() {
    SharedPreferenceClass.RemoveSharedData('token');
    SharedPreferenceClass.SetSharedData('isLogin', 'false');
    setState(() {});
  }

  WebViewPlusController _controller;
  double _height = 500;

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    MediaQueryData mediaQuery = MediaQuery.of(context);

    int flag = 0;

    FocusNode name_focus;

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: day == false ? Color(0xff0a0909) : Colors.white,
        body: Stack(children: <Widget>[
          ///
          /// Set image in top
          ///
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: screenSize.height * 0.1,
              right: screenSize.height * 0.03,
              left: screenSize.height * 0.03,
            ),
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                            height: 120,
                            width: 120,
                            child: Image.asset(
                              'assets/image/logo2.png',
                            )),
                      ),
                      Text(
                        "Login To Tradebit",
                        style: TextStyle(
                            color:day == false ? Colors.white : Color(0xff0a0909),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text("Welcome back! Log In now to start trading",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Container(
                          // color: Colors.yellow,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: TextFormField(
                              focusNode: name_focus,
                              textAlign: TextAlign.left,
                              cursorColor: Colors.white,
                              validator: (value) =>
                                  EmailValidator.validate(value)
                                      ? null
                                      : "Email cannot be empty",
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSaved: (input) => _email = input,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "IBM Plex Sans",
                              ),

                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,

                              //obscureText: true,
                              autofocus: true,

                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xff212529),
                                    )),

                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xff212529),
                                    )),

                                filled: true, //<-- SEE HERE
                                fillColor: Color(0xff212529),
                                border: InputBorder.none,

                                hintText: " Enter Your email address",
                                labelText: " Email Address",
                                labelStyle: TextStyle(
                                    color: Colors.white70, fontSize: 14),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      ignorestatus = true;
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    });
                                  },
                                ),
                                contentPadding: EdgeInsets.all(5.0),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height * 0.01,
                          ),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (input) {
                              if (input.isEmpty) {
                                return ' Password cannot be empty';
                              }
                              return null;
                            },
                            style: new TextStyle(
                              color: Colors.white,
                              fontFamily: "IBM Plex Sans",
                            ),
                            onChanged: checktextfieldtype,
                            textAlign: TextAlign.start,
                            controller: _passwordController,
                            autocorrect: false,
                            obscureText: _passwordVisible,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xff212529),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Color(0xff212529),
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor: Color(0xff212529),
                              border: InputBorder.none,
                              hintText: " Enter Your password",
                              labelText: " Password",
                              labelStyle: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white, size: 15,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "IBM Plex Sans",
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0, top: 5, bottom: 15),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => forgetPassword()));
                            },
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(padding: const EdgeInsets.only(left: 25),
                                  child: Text("Forget Password ?", style: TextStyle(color: Colors.white, fontFamily: "IBM Plex Sans", fontWeight: FontWeight.w500, fontSize: 14.0,),),
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 78.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              login = true;
                            });
                            final formState = _formKey.currentState;
                            if (formState.validate()) {
                              if (captchaToken != '') {
                                formState.save();
                                _login();
                              } else {
                                setState(() {});
                              }
                            } else {
                              setState(() {
                                login = false;
                              });
                            }
                          },
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color:Color(0xffc79509),
                                borderRadius: BorderRadius.circular(10.0)
                                //boxShadow: Colors.white12,
                                ),
                            child: Center(
                              child: login == true
                                  ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                                  : Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "IBM Plex Sans",
                                        fontSize: 16.0,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: TextStyle(color: day == false ? Colors.white70 : Color(0xff0a0909), fontSize: 14,)),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new signUp()));
                              },
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Color(0xffc79509),
                                    fontFamily: "IBM Plex Sans",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
          ),
// Recaptcha
          Center(
            child: IgnorePointer(
              ignoring: ignorestatus,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),

                  width: MediaQuery.of(context).size.width * 0.80,
                  //color: Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  child: WebViewPlus(
                    zoomEnabled: true,
                    gestureNavigationEnabled: true,
                    backgroundColor: Colors.transparent,
                    allowsInlineMediaPlayback: true,
                    onWebViewCreated: (controller) {
                      _controller = controller;
                      controller.loadUrl('assets/webpages/index.html');
                    },
                    onPageFinished: (url) {
                      _controller.getHeight().then((double height) {
                        print("Height:  " + height.toString());
                        setState(() {
                          _height = height;
                        });
                      });
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: {
                      JavascriptChannel(
                        name: 'Captcha',
                        onMessageReceived: (JavascriptMessage message) {
                          print('Message == >' + message.message.toString());
                          setState(() {
                            setState(() {
                              _height = 92;
                              flag = 1;
                            });
                            setState(() {
                              ignorestatus = true;
                            });
                            captchaToken = message.message.toString();
                            print("C O D E " + captchaToken.toString());
                          });
                        },
                      )
                    },
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _login() async {
    var loginType = "email";
    final paramDic = {
      "email": _emailController.text.toString(),
      "password": _passwordController.text.toString(),
      "captcha_response": captchaToken,
      "loginType": loginType,
    };
    print("login succcesss" + paramDic.toString());
    var response =
        await LBMAPIMainClass(APIClasses.LBM_login, paramDic, "Post");
    var data = json.decode(response.body);

    if (data["status_code"] == '1') {
      var logindata = data['data'];
      setState(() {
        login = false;

        print(captchaToken);
        if (logindata.containsKey("token") == false) {
          print("login succcesss" + data["status_code"].toString());
          // ToastShowClass.toastShow(context, data["data"]['message'].toString(), Colors.blue);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        fromlogin: true,
                        emailid: _emailController.text.toString(),
                      )));
        } else {
          print("Login Done");
          SharedPreferenceClass.SetSharedData("token", data['data']['token']);
          SharedPreferenceClass.SetSharedData(
              "name", data['data']['user']['name']);
          SharedPreferenceClass.SetSharedData(
              "id", data['data']['user']['id'].toString());
          SharedPreferenceClass.SetSharedData(
              "email", data['data']['user']['email']);
          SharedPreferenceClass.SetSharedData(
              "phone", data['data']['user']['phone']);
          SharedPreferenceClass.SetSharedData(
              "referral_code", data['data']['user']['referral_code']);
          SharedPreferenceClass.SetSharedData(
              "profile_image", data['data']['user']['profile_image']);
          SharedPreferenceClass.SetSharedData(
              "ref_link", data['data']['user']['referral_code']);
          SharedPreferenceClass.SetSharedData(
              "number", data['data']['user']['mobile']);
          SharedPreferenceClass.SetSharedData(
              "kyc_status", data['data']['user']['user_kyc_status']);
          SharedPreferenceClass.SetSharedData(
              "kyc_msg", data['data']['user']['user_kyc_status_message']);
          SharedPreferenceClass.SetSharedData(
              "fees", (data['data']['user']['fee_by_lbm']).toString());
          SharedPreferenceClass.SetSharedData(
              "status", (data['data']['user']['status']).toString());
          SharedPreferenceClass.SetSharedData("isLogin", "true");
          getCryptoData();
          setState(() {
            login = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => bottomNavBar(
                      index: 0,
                    )),
          );
        }
      });
    } else {
      setState(() {
        login = false;
      });
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  void checktextfieldtype(String value) {
    setState(() {
      ignorestatus = false;
    });
  }
}
