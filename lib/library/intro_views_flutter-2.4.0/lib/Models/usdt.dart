
import 'dart:convert';

Btc btcFromJson(String str) => Btc.fromJson(json.decode(str));
class Btc {
  String image;
  String symbol;
  String flag;
  bool listed;
  int id;
  String name;
  String currency;
  String pairWith;
  String decimalCurrency;
  String decimalPair;
  String buyMinDesc;
  String buyMaxDesc;
  String buyDesc;
  String sellMinDesc;
  String sellMaxDesc;
  String sellDesc;
  DateTime createdAt;
  DateTime updatedAt;
  String price;
  String change;
  String volume;
  String high;
  String low;
  bool isFav;

  Btc({
    this.image,
    this.symbol,
    this.flag,
    this.listed,
    this.id,
    this.name,
    this.currency,
    this.pairWith,
    this.decimalCurrency,
    this.decimalPair,
    this.buyMinDesc,
    this.buyMaxDesc,
    this.buyDesc,
    this.sellMinDesc,
    this.sellMaxDesc,
    this.sellDesc,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.change,
    this.volume,
    this.high,
    this.low,
    this.isFav,
  });

  factory Btc.fromJson(Map<String, dynamic> json) =>
      Btc(
        image: json["image"],
        symbol: json["symbol"],
        flag: json["flag"],
        listed: json["listed"],
        id: json["id"],
        name: json["name"],
        currency: json["currency"],
        pairWith: json["pair_with"],
        decimalCurrency: json["decimal_currency"],
        decimalPair: json["decimal_pair"],
        buyMinDesc: json["buy_min_desc"],
        buyMaxDesc: json["buy_max_desc"],
        buyDesc: json["buy_desc"],
        sellMinDesc: json["sell_min_desc"],
        sellMaxDesc: json["sell_max_desc"],
        sellDesc: json["sell_desc"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        price: json["price"],
        change: json["change"],
        volume: json["volume"],
        high: json["high"],
        low: json["low"],
        isFav: json["isFav"],
      );
}