// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class gridHome {
  String name, image, valueMarket, valuePercent;
  Color chartColor;
  List<Color> chartColorGradient;
  var data;
  gridHome(
      {this.image,
      this.name,
      this.data,
      this.chartColor,
      this.valueMarket,
      this.valuePercent,
      this.chartColorGradient});
}

class MenuItem {
  String name;
  Image image;
  MenuItem({this.name,      this.image});
}

class MenuItem1 {
  String name1;
  Image image1;
  MenuItem1({this.name1,  this.image1});
}

List<gridHome> listGridHome = [
  gridHome(
      name: "ETC/USDT",
      image: "Test",
      chartColor: Colors.greenAccent,
      valueMarket: "56.03",
      valuePercent: "0.32%",
      chartColorGradient: [
        Colors.greenAccent.withOpacity(0.2),
        Colors.greenAccent.withOpacity(0.01)
      ],
      data: [0.0, 0.5,0.9, 1.4, 2.2, 1.0, 3.3, 0.0,-0.5, -1.0, -0.5, 0.0, 0.0]
  ),
  gridHome(
      name: "BTC/USDT",
      image: "Test",
      chartColor: Colors.greenAccent,
      valueMarket: "3873.98",
      valuePercent: "0.14%",
      chartColorGradient: [
        Colors.greenAccent.withOpacity(0.2),
        Colors.greenAccent.withOpacity(0.01)
      ],
      data: [
        0.0,
        -0.3,
        -0.5,
        -0.1,
        0.0,
        0.0,
        -0.5,
        -1.0,
        -0.5,
        0.0,
        0.0,
      ]),
  gridHome(
      name: "ETH/USDT",
      image: "Test",
      valueMarket: "132.20",
      valuePercent: "0.34%",
      chartColor: Colors.redAccent,
      chartColorGradient: [
        Colors.redAccent.withOpacity(0.2),
        Colors.redAccent.withOpacity(0.01)
      ],
      data: [
        0.0,
        1.0,
        1.5,
        2.0,
        0.0,
        0.0,
        -0.5,
        -1.0,
        -0.5,
        0.0,
        0.0
      ]),
  gridHome(
      name: "XRP/USDT",
      image: "Test",
      valueMarket: "0.31",
      valuePercent: "0.53%",
      chartColor: Colors.greenAccent,
      chartColorGradient: [
        Colors.greenAccent.withOpacity(0.2),
        Colors.greenAccent.withOpacity(0.01)
      ],
      data: [
        0.0,
        1.0,
        1.5,
        2.0,
        1.8,
        1.7,
        1.6,
        1.67,
        1.4,
        1.2,
        1.5,
        2.0,
        0.7,
        1.1,
        2.2,
        1.5,
        2.0,
        1.8,
        1.7,
        1.6,
        1.67,
        1.4,
        1.2,
        1.5,
        0.5,
        -0.5,
        -0.7,
        -0.5,
        0.0,
        0.0
      ]),
];

List<MenuItem> menu = [
  MenuItem(
    name: "Deposit",

    image: Image.asset(
      "assets/image/upload.png",
      height: 30.0,
      fit: BoxFit.contain,
      // color: Colors.white,
      width: 30.0,
    ),

  ),
  MenuItem(

    name: "Referral",
    image: Image.asset(
      "assets/image/refer.png",
      height: 30.0,
      fit: BoxFit.contain,
      // color: Colors.grey,
      width: 30.0,
    ),
  ),
  MenuItem(
    name: "Launchpad",
    image: Image.asset(
      "assets/image/trade.png",
      height: 30.0,
      fit: BoxFit.contain,
      // color: Colors.white,
      width: 30.0,
    ),
  ),
  MenuItem(
    name: "Staking",
    image: Image.asset(
      "assets/image/staking.png",
      height: 30.0,
      fit: BoxFit.contain,
      // color: Colors.white,
      width: 30.0,
    ),
  ),
];

List<MenuItem1> menu1 = [


];