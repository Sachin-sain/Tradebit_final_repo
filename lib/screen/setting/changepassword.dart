// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';

import '../../config/SharedPreferenceClass.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController oldpassword = new TextEditingController();
  TextEditingController newpassword = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  bool _oldpasswordVisible = true;
  bool _newpasswordVisible = true;
  bool _passwordconfirmVisible = true;
  bool submitdata = false;

  String Token;
  getToken() async {
    Token = await SharedPreferenceClass.GetSharedData('token');
    print(Token);
  }

  @override
  void initState() {
    getToken();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Form(
      key: _formKeys,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Change Password",
              style: TextStyle(
                fontFamily: "IBM Plex Sans",
                color: day == false ? Colors.white : Colors.black,
              )),
          backgroundColor: day == false ? Colors.black : Colors.white,
        ),
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: screenSize.height * 0.02,
                    right: screenSize.height * 0.04,
                    top: screenSize.height * 0.01),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.white,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your password';
                    }
                    return null;
                  },
                  style: new TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontFamily: "IBM Plex Sans",
                  ),
                  textAlign: TextAlign.start,
                  controller: oldpassword,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  obscureText: _oldpasswordVisible,
                  autofocus: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: day == false
                                ? Colors.white54
                                : Colors.black54,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: day == false
                                ? Colors.white54
                                : Colors.black54,
                          )),
                      filled: true, //<-- SEE HERE
                      fillColor: day == false ? Colors.black : Colors.white,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _oldpasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: day == false ? Colors.white : Colors.black,
                          size: 15,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _oldpasswordVisible = !_oldpasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(5.0),
                      labelText: ' Old Password',
                      hintStyle: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontFamily: "IBM Plex Sans",
                      ),
                      labelStyle: TextStyle(
                          color: day == false ? Colors.white : Colors.black)),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(
                    left: screenSize.height * 0.02,
                    right: screenSize.height * 0.04,
                    top: screenSize.height * 0.00),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.white,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type your new password';
                    }
                    return null;
                  },
                  style: new TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontFamily: "IBM Plex Sans",
                  ),
                  textAlign: TextAlign.start,
                  controller: newpassword,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  obscureText: _newpasswordVisible,
                  autofocus: false,
                  decoration: InputDecoration(
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color:
                      //             day == false ? Colors.white54 : Colors.black54,
                      //       ),
                      //     ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: day == false
                                ? Colors.white54
                                : Colors.black54,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: day == false
                                ? Colors.white54
                                : Colors.black54,
                          )),
                      filled: true, //<-- SEE HERE
                      fillColor: day == false ? Colors.black : Colors.white,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _newpasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: day == false ? Colors.white : Colors.black,
                          size: 15,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _newpasswordVisible = !_newpasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(5.0),
                      labelText: ' New Password',
                      hintStyle: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontFamily: "IBM Plex Sans",
                      ),
                      labelStyle: TextStyle(
                          color: day == false ? Colors.white : Colors.black)),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(
                  left: screenSize.height * 0.02,
                  right: screenSize.height * 0.04,
                  top: screenSize.height * 0.00,
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.white,
                  validator: (input) {
                    if (input.isEmpty) {
                      if (newpassword.text.isNotEmpty) {
                        return 'Please type confirm password';
                      }
                      return null;
                    } else if (input != newpassword.text) {
                      return 'Confirm Password not Match';
                    } else {
                      // setState(() {
                      //   password=true;
                      // });
                      return null;
                    }
                  },
                  style: new TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                    fontFamily: "IBM Plex Sans",
                  ),
                  textAlign: TextAlign.start,
                  controller: confirmpassword,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  obscureText: _passwordconfirmVisible,
                  autofocus: false,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: day == false
                                ? Colors.white54
                                : Colors.black54,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: day == false
                                ? Colors.white54
                                : Colors.black54,
                          )),
                      filled: true, //<-- SEE HERE
                      fillColor: day == false ? Colors.black : Colors.white,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordconfirmVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: day == false ? Colors.white : Colors.black,
                          size: 15,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordconfirmVisible =
                                !_passwordconfirmVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(5.0),
                      labelText: ' Confirm Password',
                      hintStyle: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontFamily: "IBM Plex Sans",
                      ),
                      labelStyle: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      submitdata = true;
                    });
                    final formState = _formKeys.currentState;
                    if (formState.validate()) {
                      if (confirmpassword.text == newpassword.text) {
                        _changepasswordapi();
                      } else {
                        setState(() {
                          submitdata = false;
                        });
                      }
                    } else {
                      setState(() {
                        submitdata = false;
                      });
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Color(0xffc79509),
                    ),
                    child: Center(
                      child: submitdata == true
                          ? CircularProgressIndicator(
                              backgroundColor:
                                  day == false ? Colors.white : Colors.black,
                            )
                          : Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changepasswordapi() async {
    final paramDic = {
      "old_password": oldpassword.text.toString(),
      "new_password": newpassword.text.toString(),
      "confirm_password": confirmpassword.text.toString(),
    };
    print(paramDic.toString());
    final uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.change_pass);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set(
      'content-type',
      'application/json',
    );
    request.headers.set('Authorization',
        'Bearer ' + await SharedPreferenceClass.GetSharedData('token'));

    request.add(utf8.encode(json.encode(paramDic)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    var data = jsonDecode(reply);
    print(data);
    if (data["status_code"] == '1') {
      setState(() {
        submitdata = false;
        oldpassword.text = '';
        newpassword.text = '';
        confirmpassword.text = '';
      });
      ToastShowClass.toastShow(context, data["message"], Colors.blue);
    } else {
      setState(() {
        submitdata = false;
      });
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }
}
