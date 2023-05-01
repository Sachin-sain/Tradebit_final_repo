// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';

import '../../config/APIClasses.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';
import 'login.dart';


class NewPassword extends StatefulWidget {
String token='';
NewPassword({this.token});
  @override
  _NewPassword createState() => _NewPassword();
}

class _NewPassword extends State<NewPassword> {


  TextEditingController newpassword=new TextEditingController();
  TextEditingController confirmpassword=new TextEditingController();
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
bool _newpasswordVisible=true;
bool _passwordconfirmVisible=true;
bool submitdata=false;


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Form(

      key :_formKeys,
      child: Scaffold(
      appBar: AppBar(title: Text("Create New Password"),backgroundColor: Color(0xff17394f),),
        backgroundColor: day==false?Color(0xff17394f):Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Container(



                    /// Set Background image in splash screen layout (Click to open code)
         color:day==false?Color(0xff17394f):Colors.white,
            child: Column(
                      children: <Widget>[

                                                 Container(
                              height:screenSize.height*0.11,
                              child: Padding(
                                padding:  EdgeInsets.only(
                                    left:  screenSize.height*0.04, right:  screenSize.height*0.04, top: screenSize.height*0.01),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please type your new password';
                                    }return null;
                                  },
                                  style: new TextStyle(color: day==false?Colors.white:Color(0xff176980), fontFamily: "IBM Plex Sans",),
                                  textAlign: TextAlign.start,
                                  controller: newpassword,
                                  keyboardType: TextInputType.text,
                                  autocorrect: false,
                                  obscureText: _newpasswordVisible,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: day==false?Colors.white:Color(0xff176980),),
                                      ),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0),
                                        child: Icon(
                                          Icons.vpn_key,
                                          size: 20,
                                          color: day==false?Colors.white:Color(0xff176980),
                                        ),
                                      ),
                                                                 suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                       _newpasswordVisible
                                       ? Icons.visibility_off:Icons.visibility,
                                       color: day==false?Colors.white:Color(0xff176980),size: 15,
                                       ),
                                    onPressed: () {
                                       // Update the state i.e. toogle the state of passwordVisible variable
                                       setState(() {
                                           _newpasswordVisible = !_newpasswordVisible;
                                       });
                                     },
                                    ),

                                      contentPadding: EdgeInsets.all(0.0),
                                      filled: true,
                                      fillColor: day==false?Colors.transparent:Colors.grey[200],
                                      labelText: 'New Password',
                                      hintStyle:
                                      TextStyle(color: day==false?Colors.white:Color(0xff176980), fontFamily: "IBM Plex Sans",),
                                      labelStyle: TextStyle(
                                        color:day==false?Colors.white:Color(0xff176980)
                                      )),
                                ),
                              ),
                            ),

                            Container(
                              //color: Colors.pink,
                              height:  screenSize.height*0.11,
                              child: Padding(
                                padding:  EdgeInsets.only(
                                    left:  screenSize.height*0.04, right:  screenSize.height*0.04, top: screenSize.height*0.01),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input.isEmpty) {

                                      return 'Please type confirm password';
                                    }else if(input!=newpassword.text){
                                      return 'Confirm Password not Match';
                                    }
                                    else{
                                      // setState(() {
                                      //   password=true;
                                      // });
                                      return null;
                                    }
                                  },
                                  style: new TextStyle(color: day==false?Colors.white:Color(0xff176980), fontFamily: "IBM Plex Sans",),
                                  textAlign: TextAlign.start,
                                  controller: confirmpassword,
                                  keyboardType: TextInputType.text,
                                  autocorrect: false,
                                  obscureText: _passwordconfirmVisible,
                                  autofocus: false,autovalidateMode: AutovalidateMode.always,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: day==false?Colors.white:Color(0xff176980),),
                                      ),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0),
                                        child: Icon(
                                          Icons.vpn_key,
                                          size: 20,
                                          color: day==false?Colors.white:Color(0xff176980),
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                       _passwordconfirmVisible
                                       ? Icons.visibility_off:Icons.visibility,
                                       color: day==false?Colors.white:Color(0xff176980),size: 15,
                                       ),
                                    onPressed: () {
                                       // Update the state i.e. toogle the state of passwordVisible variable
                                       setState(() {
                                           _passwordconfirmVisible = !_passwordconfirmVisible;
                                       });
                                     },
                                    ),

                                      contentPadding: EdgeInsets.all(0.0),
                                      filled: true,
                                      fillColor:day==false?Colors.transparent:Colors.grey[200],
                                      labelText: 'Confirm Password',
                                      hintStyle:
                                      TextStyle(color: day==false?Colors.white:Color(0xff176980), fontFamily: "IBM Plex Sans",),
                                      labelStyle: TextStyle(
                                        color: day==false?Colors.white:Color(0xff176980),
                                      )),
                                ),
                              ),
                            ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 30.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                submitdata = true;
                              });
                              final formState = _formKeys.currentState;
                              if (formState.validate()) {
                                if (confirmpassword.text == newpassword.text) {
                                  _changepasswordapi();
                                }else{
                                   setState(() {
                                submitdata = false;
                              });
                                }
                              }else{
                                 setState(() {
                                submitdata = false;
                              });
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                color:day==false?Colors.blueGrey[600]:Colors.grey[200],
                              ),
                              child: Center(
                                child: submitdata==true?CircularProgressIndicator(backgroundColor: day==false?Colors.white:Color(0xff176980),):
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: day==false?Colors.white:Color(0xff176980),
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
      ),
    );
  }

  Future<void> _changepasswordapi() async {
    final paramDic = {
      "password": newpassword.text.toString(),
      "confirm_password": confirmpassword.text.toString(),
      "token":widget.token.toString()
    };
    print(paramDic.toString());
    final uri = Uri.https(APIClasses.LBM_BaseURL,APIClasses.pass_reset);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('content-type','application/json');
    request.add(utf8.encode(json.encode(paramDic)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    var data = jsonDecode(reply);
    print(data);
    if(data["status_code"]=='1'){
      setState(() {
        submitdata=false;
        newpassword.text='';
        confirmpassword.text='';
        Navigator.of(context).pushReplacement(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new login()));
      });
      ToastShowClass.toastShow(context, data["message"], Colors.blue);

    }
    else{
      setState(() {
        submitdata=false;
      });
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }

  }
}
