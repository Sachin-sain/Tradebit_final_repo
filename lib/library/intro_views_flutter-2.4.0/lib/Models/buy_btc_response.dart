import 'package:meta/meta.dart';
import 'dart:convert';

PlaceOrderResponse placeOrderResponseFromJson(String str) => PlaceOrderResponse.fromJson(json.decode(str));


class PlaceOrderResponse {
  final String statusCode;
  final String statusText;
  final String message;

  PlaceOrderResponse({
    @required this.statusCode,
    @required this.statusText,
    @required this.message,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) => PlaceOrderResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
  );


}
