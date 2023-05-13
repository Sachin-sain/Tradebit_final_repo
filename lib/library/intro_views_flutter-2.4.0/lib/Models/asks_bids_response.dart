import 'dart:convert';
import 'package:flutter/material.dart';
NewData newDataFromJson(String str) => NewData.fromJson(json.decode(str));
class NewData {
  final String statusCode;
  final String statusText;
  final String message;
  final Data data;
  NewData({
    @required this.statusCode,
    @required this.statusText,
    @required this.message,
    @required this.data,
  });

  factory NewData.fromJson(Map<String, dynamic> json) => NewData(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final int lastUpdateId;
  final List<List<String>> bids;
  final List<List<String>> asks;
  Data({
    @required this.lastUpdateId,
    @required this.bids,
    @required this.asks,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    lastUpdateId: json["lastUpdateId"],
    bids: List<List<String>>.from(json["bids"].map((x) => List<String>.from(x.map((x) => x)))),
    asks: List<List<String>>.from(json["asks"].map((x) => List<String>.from(x.map((x) => x)))),
  );
}