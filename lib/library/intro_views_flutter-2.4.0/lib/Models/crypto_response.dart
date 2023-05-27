import 'dart:convert';

CryptoResponse cryptoResponseFromJson(String str) => CryptoResponse.fromJson(json.decode(str));


class CryptoResponse {
  String statusCode;
  String statusText;
  String message;
  Data data;
  List<String> tickers;
  List<dynamic> listedTickers;

  CryptoResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
    this.tickers,
    this.listedTickers,
  });

  factory CryptoResponse.fromJson(Map<String, dynamic> json) => CryptoResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
    tickers: List<String>.from(json["tickers"].map((x) => x)),
    listedTickers: List<dynamic>.from(json["listed_tickers"].map((x) => x)),
  );

}

class Data {
  List<dynamic> fav;
  List<Btc> usdt;
  List<Btc> eth;
  List<Btc> btc;
  List<Btc> trx;

  Data({
    this.fav,
    this.usdt,
    this.eth,
    this.btc,
    this.trx,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fav: List<dynamic>.from(json["FAV"].map((x) => x)),
    usdt: List<Btc>.from(json["USDT"].map((x) => Btc.fromJson(x))),
    eth: List<Btc>.from(json["ETH"].map((x) => Btc.fromJson(x))),
    btc: List<Btc>.from(json["BTC"].map((x) => Btc.fromJson(x))),
    trx: List<Btc>.from(json["TRX"].map((x) => Btc.fromJson(x))),
  );

}

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

  factory Btc.fromJson(Map<String, dynamic> json) => Btc(
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

SocketResponse socketResponseFromJson(String str) => SocketResponse.fromJson(json.decode(str));

String socketResponseToJson(SocketResponse data) => json.encode(data.toJson());

class SocketResponse {
  String socketResponseE;
  int e;
  String s;
  String socketResponseP;
  String p;
  String w;
  String x;
  String socketResponseC;
  String q;
  String socketResponseB;
  String b;
  String socketResponseA;
  String a;
  String socketResponseO;
  String h;
  String socketResponseL;
  String v;
  String socketResponseQ;
  int o;
  int c;
  int f;
  int l;
  int n;

  SocketResponse({
    this.socketResponseE,
    this.e,
    this.s,
    this.socketResponseP,
    this.p,
    this.w,
    this.x,
    this.socketResponseC,
    this.q,
    this.socketResponseB,
    this.b,
    this.socketResponseA,
    this.a,
    this.socketResponseO,
    this.h,
    this.socketResponseL,
    this.v,
    this.socketResponseQ,
    this.o,
    this.c,
    this.f,
    this.l,
    this.n,
  });

  factory SocketResponse.fromJson(Map<String, dynamic> json) => SocketResponse(
    socketResponseE: json["e"],
    e: json["E"],
    s: json["s"],
    socketResponseP: json["p"],
    p: json["P"],
    w: json["w"],
    x: json["x"],
    socketResponseC: json["c"],
    q: json["Q"],
    socketResponseB: json["b"],
    b: json["B"],
    socketResponseA: json["a"],
    a: json["A"],
    socketResponseO: json["o"],
    h: json["h"],
    socketResponseL: json["l"],
    v: json["v"],
    socketResponseQ: json["q"],
    o: json["O"],
    c: json["C"],
    f: json["F"],
    l: json["L"],
    n: json["n"],
  );

  Map<String, dynamic> toJson() => {
    "e": socketResponseE,
    "E": e,
    "s": s,
    "p": socketResponseP,
    "P": p,
    "w": w,
    "x": x,
    "c": socketResponseC,
    "Q": q,
    "b": socketResponseB,
    "B": b,
    "a": socketResponseA,
    "A": a,
    "o": socketResponseO,
    "h": h,
    "l": socketResponseL,
    "v": v,
    "q": socketResponseQ,
    "O": o,
    "C": c,
    "F": f,
    "L": l,
    "n": n,
  };
}
