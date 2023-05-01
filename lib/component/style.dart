// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../config/constantClass.dart';

class colorStyle {
  static final primaryColor = Color(0xff143047);
  // static final background = Color(0xFF191B2A);
  static final background = day == false ? Colors.blueGrey.shade900 : Colors.white;
  static final cardColorLight = Colors.black;
  static final fontColorDark = Colors.black;
  static final fontSecondaryColorLight = Colors.black;
  static final fontSecondaryColorDark = Colors.black26;
  static final iconColorLight = Colors.white;
  static final iconColorDark = Colors.black;
  static final fontColorDarkTitle = Colors.white;
  static final grayBackground = Color(0xFFF4F5F7);
  // static final grayBackground = Color(0xFF16223A);
  static final blackBackground = Colors.black;
}

class txtStyle {
  static final headerStyle = TextStyle(
      fontFamily: "IBM Plex Sans",
      fontSize: 21.0,
      fontWeight: FontWeight.w800,
      color: Color(0xff143047),
      letterSpacing: 1.5);

  static final descriptionStyle = TextStyle(
      fontFamily: "IBM Plex Sans",
      fontSize: 15.0,
      color: Colors.white70,
      fontWeight: FontWeight.w400);
}
