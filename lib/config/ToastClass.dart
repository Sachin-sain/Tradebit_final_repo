// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastShowClass {
  //Display the Toast
  static void toastShow(
      BuildContext context, String ToastValue, MaterialColor _color) {
    Fluttertoast.showToast(
        msg: ToastValue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor:  Color(0xFF1f3c75),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

class ToastClass {

  static void ToastShow(String ToastValue ,{Color color}) {
    Fluttertoast.showToast(
        msg: ToastValue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
       // backgroundColor: _color,
        textColor:  color ?? Color(0xFF1f3c75),
        fontSize: 16.0);
  }
}



class ToastMessage {
  //Display the Toast
  static void showToast(BuildContext context, String ToastValue, MaterialColor _color) {

    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: ToastValue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: _color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

