

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class StakingCommonClass {

  static  List My_hlodings = [];

  static List My_Wallet = [];

  static List My_transcation = [];

  static int My_hlodings_pagination =1;

static  List Holding_searchItem = [];
  static List Transcation_searchItem = [];
  static List walletBal_searchItem = [];

  static int My_hlodings_lastPage =1;

  static int My_transcation_lastPage =1;

  static List Portfilio_bal =[];


}


double headingSize = 19;


//decoration
final ContainerDecoration = BoxDecoration(
    color: Colors.transparent, //container inner Color
    border: Border.all(
      color: Color(0xff26406d).withOpacity(0.2),), // container border
    borderRadius: BorderRadius.all(Radius.circular(20)));


Decoration imageDecoration =  BoxDecoration(
  image: DecorationImage(
    fit: BoxFit.fitWidth,
    image: AssetImage("assets/appbar0.jpg",),
    alignment: Alignment.topRight,), );

InputDecoration  textFromFilled_de3coration =
InputDecoration(
  fillColor: Colors.red,
  errorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.red)),
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 10.0,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(60),
    ),
    borderSide: BorderSide(
        color:Color(0xffEEBE36),width: 2
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(60)),
    borderSide: BorderSide(color: Color(0xffEEBE36)),
  ),

  hintStyle: TextStyle(fontSize: 13, color: Colors.red.withOpacity(0.2)),
  suffixStyle: TextStyle(color: Colors.red),
  focusColor: Color(0xffEEBE36),
);


//textstyle

TextStyle style_white = TextStyle(

    fontWeight: FontWeight.w600,
    fontSize: 13,
    fontFamily: "Montserrat");
