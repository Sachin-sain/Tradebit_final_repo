// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:candlesticks/candlesticks.dart';
import 'package:exchange/component/CardDetail/AmountSell.dart';
import 'package:exchange/component/CardDetail/BuyAmount.dart';
import 'package:exchange/component/CardDetail/orderHistory.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/crypto_detail_card_homeScreen/DetailCryptoValue/openOrdersVolume.dart';
import 'package:exchange/screen/crypto_detail_card_homeScreen/DetailCryptoValue/orderHistory.dart';
import 'package:exchange/screen/history/Open_Orders.dart';
import 'package:exchange/screen/intro/login.dart';
import 'package:exchange/screen/market/detailCrypto/repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../history/Complete_Order.dart';
import '../../history/Order_Detail.dart';
import '../../wallet/wallet.dart';

class btcDetail extends StatefulWidget {
  Map<String, dynamic> currency_data;
  String pair;
  String familycoin;

  btcDetail({Key key, this.currency_data, this.pair, this.familycoin,int i})
      : super(key: key);

  _btcDetailState createState() => _btcDetailState(currency_data: currency_data);
}

NumberFormat Cr = new NumberFormat("#0.00000", "en_US");
NumberFormat Crp = new NumberFormat("#0.000000", "en_US");
List openOrder = [];

Future<void> open_order(String listed, String coin, String pair) async {
  var response;
  print("check data");
  if (listed == "true") {
    final paramDic = {
      "currency": coin,
      "with_currency": pair,
    };
    print(paramDic);
    print("check 2");
    response = await demoApi(APIClasses.order, paramDic, "Get");
  } else {
    print("check 1");
    final paramDic = {"": ""};
    response = await demoApi(
        APIClasses.openorder + selectedPair.toUpperCase(), paramDic, "Get");
  }
  openOrder.clear();
  othersellList.clear();
  anotherbuYlist.clear();
  data = json.decode(response.body);

  openOrder.add(data['data']);
  print("order detail" + openOrder.toString());
  double lastamount = 0.0;
  double lastamountasks = 0.0;
  double large_value = 0.0;

//buy
  for (int i = 0; i < openOrder[0]['bids'].length; i++) {
    lastamount =
        lastamount + double.parse(openOrder[0]['bids'][i][1].toString());
    anotherbuYlist.add(buyAmount(
        price: Cr.format(double.parse(openOrder[0]['bids'][i][0].toString()))
            .toString(),
        value: Cr.format(double.parse(openOrder[0]['bids'][i][1].toString()))
            .toString()));
    print(" P R " +
        anotherbuYlist[i].price.toString() +
        anotherbuYlist[i].value.toString());
  }

//sell
  for (int i = 0; i < openOrder[0]['asks'].length; i++) {
    lastamountasks =
        lastamountasks + double.parse(openOrder[0]['asks'][i][1].toString());
    othersellList.add(amountSell(
      price: Cr.format(double.parse(openOrder[0]['asks'][i][0].toString()))
          .toString(),
      value: Cr.format(double.parse(openOrder[0]['asks'][i][1].toString()))
          .toString(),
    ));

    print(" P R O " +
        othersellList[i].price.toString() +
        othersellList[i].value.toString());
  }
  large_value = (othersellList.length > 0
              ? double.parse(othersellList[othersellList.length - 1].value)
              : 0) >
          (anotherbuYlist.length > 0
              ? double.parse(anotherbuYlist[anotherbuYlist.length - 1].value)
              : 0)
      ? double.parse(othersellList[othersellList.length - 1].value)
      : double.parse(anotherbuYlist[anotherbuYlist.length - 1].value);

  print("large val" + openOrder.toString());

  for (int i = 0; i < anotherbuYlist.length; i++) {
    anotherbuYlist[i].percent =
        Cr.format(double.parse(anotherbuYlist[i].value) / large_value)
            .toString();
    print("sell per" +
        Cr.format(double.parse(anotherbuYlist[i].value) / large_value)
            .toString());
  }

  for (int i = 0; i < othersellList.length; i++) {
    othersellList[i].percent =
        Cr.format(double.parse(othersellList[i].value) / large_value)
            .toString();

    print("sell per" +
        Cr.format(double.parse(othersellList[i].value) / large_value)
            .toString());
  }
}

Future<void> OrdersHistory(String listed, String coin, String pair) async {
  List Orderhistory = [];
  var response;

  if (listed == "true") {
    final paramDic = {
      "currency": coin,
      "with_currency": pair,
    };
    response = await demoApi(APIClasses.ownorderHistory, paramDic, "Get");
    print(response);
  } else {
    final paramDic = {"": ""};
    response = await APIMainClassbinance(
        APIClasses.ordertradehistory + coin.toUpperCase() + pair.toUpperCase(),
        paramDic,
        "Get");
  }
  Orderhistory.clear();
  listorderHistoryModel.clear();
  data = json.decode(response.body);
  print(data.toString());

  Orderhistory = data['data'].toList().reversed.toList();
  print("o DERDER " + Orderhistory.toString());
  for (int i = 0; i < Orderhistory.length; i++) {
    listorderHistoryModel.add(orderHistoryModel(
        date: Orderhistory[i]['T'] == null
            ? ""
            : new DateTime.fromMillisecondsSinceEpoch(Orderhistory[i]['T'])
                .toString()
                .split(' ')[1],
        type: Orderhistory[i]['m'] == true ? "Sell" : "Buy",
        price: Orderhistory[i]['p'] == null
            ? ""
            : Cr.format(double.parse(Orderhistory[i]['p'].toString())),
        amount: Orderhistory[i]['q'] == null
            ? ""
            : Crp.format(double.parse(Orderhistory[i]['q'].toString()))));
  }
}

class _btcDetailState extends State<btcDetail> {
  static NumberFormat Cr = new NumberFormat("#,##0.0000", "en_US");
  String WalletBal = "0.0";
  String Walletqty = "0";
  String WalletBalsell = "0.0";
  String Walletqtysell = "0";
  String WalletBalbuy = "0.0";
  String Walletqtybuy = "0";
  Map<String, dynamic> btcMarketList;
  Map<String, dynamic> btcMarketListDisplay;
  Map<String, dynamic> currency_data;
  String status = '';
  List limit;
  Limit selectedlimit;
  Timer timer;
  bool _isTrackProgress = false;
  bool datafetch = false;
  bool isProgress = false;
  String orderid = '';
  static int pagenumber = 1;
  int total = 0;
  bool all = true;
  String currentSymbol = "";

  _btcDetailState({this.currency_data});
  var atpricecontroller = TextEditingController();
  var triggercontroller = TextEditingController(text: "0");
  var amountcontroller = TextEditingController();
  var marketamountcontroller = TextEditingController(text: "0");
  var totalcontroller = TextEditingController();
  String type = "buy";
  double prevprice = 0.00;
  double currentprice_pre = 0.00;
  String Status = 'E';
  String Status_currentprice = 'E';
  var item;
  bool low = false;
  bool fav = false;
  List favdata = [];
  int currentIndex = 0;
  List<Candle> candles = [];
  List<KLineEntity> datasKline = [];

  List currencycompletedata = [];
  bool order = false;
  bool order1 = false;
  bool order2 = false;
  bool order3 = false;
  bool expand = false;
  String selected = "1";
  ScrollController scrollController;
  String Ordertype = "open";
  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();
  bool isLine = false;
  bool isclick = false;

  Future<void> getListedCoinsPrice() async {
    // log('changing Price ');
    final listedTickers = [];
    final paramDic = {
      "": "",
    };

    try {
      var response =
          await APIMainClassbinance(APIClasses.currencyget, paramDic, "Get");
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data['status_code'] == '1') {
          listedTickers.addAll(data['listed_tickers']);


          // print(data['data'].length);
          final Map<String, dynamic> typesMap = data['data'];
          final typesList = typesMap.keys.toList();
          // print(typesList);
          for (var i = 0; i < typesList.length; i++) {
            final List list = data['data']['${typesList[i]}'];
            list.forEach((element) {
              for (var j = 0; j < listedTickers.length; j++) {
                // print(typesList[i]);
                if (element['symbol'].toString().toUpperCase() ==
                    listedTickers[j].toString().toUpperCase()) {
                  Currency_data[typesList[i]]
                          [listedTickers[j]][Currency_data[typesList[i]]
                              [listedTickers[j]]
                          .indexWhere(
                              (element) => element.containsKey('currentprice'))]
                      ['currentprice'] = element['price'];
                } else {
                  // print('not found');
                }
              }
            });
          }
        } else {
          print('failed 1');
        }
      } else {
        print('failed 2');
      }
    } catch (e) {
      print('failed 3 with e == > $e');
    }
  }

  @override
  void initState() {
    binanceFetchcandle("1m");
    Wakelock.enable();
    check();
    getremainingorder(1);
    setState(() {
      atpricecontroller.text = currency_data['PRICE'] == null
          ? "0.00"
          : currency_data['PRICE'].toString();
    });
    getaddtofav();
    binanceFetch("1m");
    getcompletedata(1);

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (scrollController.offset >= 400) {
            expand = true; // show the back-to-top button
          } else {
            expand = false; // hide the back-to-top button
          }
        });
      });

    super.initState();
  }

  getremainingorder(int pagenumber) async {
    print('remaining order == = ########');
    final paramDic = {
      "type": 'remaining',
      "page": pagenumber.toString(),
      "per_page": '25',
    };
    var response =
        await APIMainClassbinance(APIClasses.OpenData, paramDic, "Get");
    var data = json.decode(response.body);

    remainingordernew.clear();

    if (pagenumber == 1) {
      remainingorder.clear();
    }
    if (response.statusCode == 200) {
      setState(() {
        // status='true';
        isProgress = true;
        _isTrackProgress = true;
        remainingordernew = data['data']['data'];
        remainingorder.addAll(remainingordernew);
        datafetch = true;
      });
      print("remainingorder.lengt");
      print(remainingorder.toString());
    } else {
      setState(() {
        // status='true';
        pagenumber = pagenumber;
        isProgress = true;
        _isTrackProgress = true;
        datafetch = true;
      });
    }
  }

  int flagupdate = 0;

  void updateCandlesFromSnapshot(AsyncSnapshot<Object> snapshot) {
    /// binance currency
    if (datasKline.isNotEmpty) {
      if (snapshot.data != null) {
        final data =
            jsonDecode(snapshot.data as String) as Map<String, dynamic>;
        print("M A P D A T A   " + data.toString());
        if (data.keys.contains("ohlc")) {
          print('HAVE dA ');
          if (data.containsKey("k") == true &&
              datasKline[datasKline.length - 1].time < data["k"]["t"] &&
              flagupdate == 0) {
            print("check 1");
            flagupdate = 1;
            if (widget.familycoin == "INR") {
              datasKline.add(KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"].toString()) * rate,
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"].toString()) * rate,
                  high: double.parse(data["k"]["h"].toString()) * rate,
                  low: double.parse(data["k"]["l"].toString()) * rate,
                  open: double.parse(data["k"]["o"].toString()) * rate,
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString())));
            } else {
              datasKline.add(KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"].toString()),
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"].toString()),
                  high: double.parse(data["k"]["h"].toString()),
                  low: double.parse(data["k"]["l"].toString()),
                  open: double.parse(data["k"]["o"].toString()),
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString())));
            }
          } else if (data.containsKey("k") == true && flagupdate == 1) {
            print("check 2");
            if (widget.familycoin == "INR") {
              datasKline[datasKline.length - 1] = KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"]) * rate,
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"]) * rate,
                  high: double.parse(data["k"]["h"]) * rate,
                  low: double.parse(data["k"]["l"]) * rate,
                  open: double.parse(data["k"]["o"]) * rate,
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString()));
            } else {
              datasKline[datasKline.length - 1] = KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"].toString()),
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"].toString()),
                  high: double.parse(data["k"]["h"].toString()),
                  low: double.parse(data["k"]["l"].toString()),
                  open: double.parse(data["k"]["o"].toString()),
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString()));
            }
            if (data["k"]["t"] - datasKline[datasKline.length - 1].time ==
                datasKline[datasKline.length - 1].time -
                    datasKline[datasKline.length - 2].time) {
              print("check 3");
              flagupdate = 0;
            }
          }
        } else {
          if (data.containsKey("k") == true &&
              datasKline[datasKline.length - 1].time < data["k"]["t"] &&
              flagupdate == 0) {
            print("check 1");
            flagupdate = 1;
            if (widget.familycoin == "INR") {
              datasKline.add(KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"].toString()) * rate,
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"].toString()) * rate,
                  high: double.parse(data["k"]["h"].toString()) * rate,
                  low: double.parse(data["k"]["l"].toString()) * rate,
                  open: double.parse(data["k"]["o"].toString()) * rate,
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString())));
            } else {
              datasKline.add(KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"].toString()),
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"].toString()),
                  high: double.parse(data["k"]["h"].toString()),
                  low: double.parse(data["k"]["l"].toString()),
                  open: double.parse(data["k"]["o"].toString()),
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString())));
            }
          } else if (data.containsKey("k") == true && flagupdate == 1) {
            print("check 2");
            if (widget.familycoin == "INR") {
              datasKline[datasKline.length - 1] = KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"]) * rate,
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"]) * rate,
                  high: double.parse(data["k"]["h"]) * rate,
                  low: double.parse(data["k"]["l"]) * rate,
                  open: double.parse(data["k"]["o"]) * rate,
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString()));
            } else {
              datasKline[datasKline.length - 1] = KLineEntity.fromCustom(
                  time: data["k"]["t"],
                  amount: double.parse(data["k"]["h"].toString()),
                  change: double.parse(data["k"]["v"].toString()),
                  close: double.parse(data["k"]["c"].toString()),
                  high: double.parse(data["k"]["h"].toString()),
                  low: double.parse(data["k"]["l"].toString()),
                  open: double.parse(data["k"]["o"].toString()),
                  vol: double.parse(data["k"]["v"].toString()),
                  ratio: double.parse(data["k"]["c"].toString()));
            }
            if (data["k"]["t"] - datasKline[datasKline.length - 1].time ==
                datasKline[datasKline.length - 1].time -
                    datasKline[datasKline.length - 2].time) {
              print("check 3");
              flagupdate = 0;
            }
          }
        }
      }
    }
  }

  checkstatus(String method) async {
    print("login status " + status.toString());
    if (status == 'true') {
      proceedtoBuy(method);
    } else {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => new login()));
    }
  }

  check() async {
    status = await SharedPreferenceClass.GetSharedData('isLogin') == null
        ? "false"
        : await SharedPreferenceClass.GetSharedData('isLogin');
    print("GL ARA H " + status.toString());
    setState(() {});
    if (status == 'true')
      getbal(selectedcurrency: widget.familycoin.toUpperCase());
  }

  final scaffoldState = GlobalKey<ScaffoldState>();
  Future<void> getbal({String selectedcurrency, String currency}) async {
    print("SELECXT  " + selectedcurrency.toString());
    try {
      final paramDic = {
        "": '',
      };
      var response =
          await APIMainClassbinance(APIClasses.Crypto_Data, paramDic, "Get");
      var data = json.decode(response.body);
      print('response body===>' + response.body.toString());
      print("START 1 ");
      savedothercryptodata.clear();
      if (response.statusCode == 200) {
        totalBalance = data['mainTotal'];
        freezedtotalBalance = data['freezedTotal'];
        savedothercryptodata = data['data'];
        for (int i = 0; i < savedothercryptodata.length; i++) {
          print(selectedcurrency +
              "check buy name" +
              savedothercryptodata[i]['name'].toString());

          if (selectedcurrency == savedothercryptodata[i]['name']) {
            setState(() {
              WalletBalbuy = savedothercryptodata[i]['c_bal'];
              WalletBal = WalletBalbuy;
              Walletqtybuy = savedothercryptodata[i]['quantity'];
            });
          }
          print(currency +
              "check sell name" +
              savedothercryptodata[i].toString());
          if (currency == savedothercryptodata[i]['symbol']) {
            setState(() {
              WalletBalsell = savedothercryptodata[i]['c_bal'];
              Walletqtysell = savedothercryptodata[i]['quantity'];
            });
          }
        }

        //walletBalanceLoading = false;
      } else {
        print('Failed => ');
      }
    } catch (e) {
      walletBalanceLoading = false;
    }
  }

  @override
  void dispose() {
    if (_channel != null) _channel.sink.close();
    if (_channels != null) _channels.sink.close();
    atpricecontroller.text = '';
    amountcontroller.text = '';
    totalcontroller.text = '';
    firsttimebtcdetail = 0;
    super.dispose();
  }

  WebSocketChannel _channel;
  WebSocketChannel _channels;
  WebSocketChannel _channel_own;
  WebSocketChannel _channelsOwn;
  int nextindex = 0;

  Future<void> getaddtofav() async {
    final paramDic = {
      "": '',
    };
    var response =
        await APIMainClassbinance(APIClasses.getaddtofav, paramDic, "Get");
    var data = json.decode(response.body);
    favdata.clear();

    if (response.statusCode == 200) {
      favdata = data['data'];
      for (int i = 0; i < favdata.length; i++) {
        if (favdata[i]['currency'] == widget.pair) {
          fav = true;
        }
      }
    } else {
      //  ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  Future<void> proceedtoBuy(String method) async {
    final paramDic = {
      "at_price": atpricecontroller.text,
      "currency": widget.pair.toUpperCase().toString(),
      "with_currency": widget.familycoin.toString(),
      "quantity": amountcontroller.text,
      "total": totalcontroller.text.toString(),
      "stop_price": method == 'stop_limit' ? triggercontroller.text : 0,
      "order_type": type.toString(),
      "type": method.toString().toLowerCase(),
    };

    print("EXAMPLE ?? " + paramDic.toString());
    final uri = Uri.https(APIClasses.NODELBM_BaseURL, APIClasses.buy);
    print(uri.toString());

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization',
        'Bearer ' + await SharedPreferenceClass.GetSharedData('token'));
    request.add(utf8.encode(json.encode(paramDic)));
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      var data = jsonDecode(reply);
      print("successs buy sell " + data.toString());

      if (data["status_code"] == '1') {
        print("successs buy sell ");
        await getListedCoinsPrice();
        getremainingorder(1);
        getcompletedata(1);
        ToastShowClass.toastShow(
            context, data['message'].toString(), Colors.blue);
        setState(() {
          order = false;
          order1 = false;
          order2 = false;
          order3 = false;
        });
        currentIndex = 4;
      } else {
        setState(() {
          order = false;
          order1 = false;
          order2 = false;
          order3 = false;
        });
        ToastShowClass.toastShow(context, data["message"], Colors.red);
      }
    }
  }

  String interval = "1m";

  void binanceFetch(String interval) {
    try {
      if (_channel != null) _channel.sink.close();
      currency_data['listed'] == 'false'
          ? _channel = WebSocketChannel.connect(
              Uri.parse('wss://stream.binance.com:9443/ws'),
            )
          : _channel_own = WebSocketChannel.connect(
              Uri.parse(APIClasses.websocket_url),
            );
      currency_data['listed'] == 'true'
          ? _channel_own.sink.add(
              jsonEncode(
                {
                  "method": "ADD",
                  "params": [
                    widget.familycoin == "INR"
                        ? widget.pair.toLowerCase() + "usdt@ticker"
                        : widget.pair.toLowerCase() +
                            widget.familycoin.toLowerCase() +
                            "@ticker"
                  ],
                  "id": 1
                },
              ),
            )
          : _channel.sink.add(
              jsonEncode(
                {
                  "method": "SUBSCRIBE",
                  "params": [
                    widget.familycoin == "INR"
                        ? widget.pair.toLowerCase() + "usdt@ticker"
                        : widget.pair.toLowerCase() +
                            widget.familycoin.toLowerCase() +
                            "@ticker"
                  ],
                  "id": 1
                },
              ),
            );
    } catch (e) {}
  }

  void binanceFetchcandle(String interval) {
    datasKline.clear();
    if (widget.familycoin == "INR") {
      print("Check4");
      fetchCandles(
              symbol: widget.pair.toUpperCase() + "USDT",
              interval: interval,
              familycoin: "usdt",
              rate: rate)
          .then(
        (value) => setState(
          () {
            this.interval = interval;
            nextindex = value.length;
            candles = value;
            for (int i = 0; i < value.length; i++) {
              datasKline.add(KLineEntity.fromCustom(
                  time: value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high * rate,
                  change: value[i].volume,
                  close: value[i].close * rate,
                  high: value[i].high * rate,
                  low: value[i].low * rate,
                  open: value[i].open * rate,
                  vol: value[i].volume,
                  ratio: value[i].low * rate));
            }
          },
        ),
      );
      if (_channels != null) _channels.sink.close();
      currency_data['listed'] == 'true'
          ? _channelsOwn = WebSocketChannel.connect(
              Uri.parse(APIClasses.websocket_url),
            )
          : _channels = WebSocketChannel.connect(
              Uri.parse('wss://stream.binance.com:9443/ws'),
            );
      currency_data['listed'] == 'true'
          ? _channelsOwn.sink.add(
              jsonEncode(
                {
                  "method": "ADD",
                  "params": [
                    widget.pair.toLowerCase() + "usdt@kline_" + interval
                  ],
                  "id": 1
                },
              ),
            )
          : _channels.sink.add(
              jsonEncode(
                {
                  "method": "SUBSCRIBE",
                  "params": [
                    widget.pair.toLowerCase() + "usdt@kline_" + interval
                  ],
                  "id": 1
                },
              ),
            );
    } else {
      fetchCandles(
              symbol: widget.pair.toUpperCase() + widget.familycoin,
              interval: interval,
              familycoin: widget.familycoin,
              rate: rate,
              islisted: widget.currency_data["listed"])
          .then(
        (value) => setState(
          () {
            this.interval = interval;
            candles = value;
            for (int i = 0; i < value.length; i++) {
              datasKline.add(KLineEntity.fromCustom(
                  time: value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high,
                  change: value[i].volume,
                  close: value[i].close,
                  high: value[i].high,
                  low: value[i].low,
                  open: value[i].open,
                  vol: value[i].volume,
                  ratio: value[i].low));
            }
          },
        ),
      );
      if (_channels != null) _channels.sink.close();
      currency_data['listed'] == 'true'
          ? _channelsOwn = WebSocketChannel.connect(
              Uri.parse(APIClasses.websocket_url),
            )
          : _channels = WebSocketChannel.connect(
              Uri.parse('wss://stream.binance.com:9443/ws'),
            );
      currency_data['listed'] == 'true'
          ? _channelsOwn.sink.add(
              jsonEncode(
                {
                  "method": "ADD",
                  "params": [
                    widget.pair.toLowerCase() +
                        widget.familycoin.toLowerCase() +
                        "@kline_" +
                        interval
                  ],
                  "id": 1
                },
              ),
            )
          : _channels.sink.add(
              jsonEncode(
                {
                  "method": "SUBSCRIBE",
                  "params": [
                    widget.pair.toLowerCase() +
                        widget.familycoin.toLowerCase() +
                        "@kline_" +
                        interval
                  ],
                  "id": 1
                },
              ),
            );
    }
    setState(() {
      isclick = false;
    });
  }

  Future<void> addtofav() async {
    final paramDic = {
      "currency": widget.pair.toString(),
      "pair_with": widget.familycoin,
    };
    var response = await LBMAPIMainClass(APIClasses.addtofav, paramDic, "Post");
    var data = json.decode(response.body);
    if (data["status_code"] == "1") {
      // ToastShowClass.toastShow(context, data['message'].toString(), colorStyle.primaryColor);
    } else {
      // ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Future<void> CancelOrder(String orderid) async {
    final paramDic = {
      "": '',
    };
    var response = await APIMainClassbinance(
        APIClasses.cancelorder + orderid, paramDic, "Post");
    print(response);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      getremainingorder(1);
      getcompletedata(pagenumber);
      setState(() {
        ToastShowClass.toastShow(context, data['message'], Colors.blue);
      });
    } else {
      ToastShowClass.toastShow(context, data['message'], Colors.blue);
    }
  }

  Future<void> Deletetofav(String id) async {
    final paramDic = {
      "": '',
    };
    var response =
        await LBMAPIMainClass(APIClasses.deladdtofav + id, paramDic, "Delete");
    var data = json.decode(response.body);
    if (data["status_code"] == "1") {
      // ToastShowClass.toastShow(context, data['message'].toString(),Colors.blue);
    } else {
      //ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  List<String> symbols = [];
  String vol = '0.0';

  Widget mappage() {
    // print("check candle /."+candles[0].open.toString());
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: datasKline.isEmpty
            ? SizedBox()
            : StreamBuilder(
                stream: currency_data['listed'] == "true"
                    ? _channelsOwn.stream
                    : _channels.stream,
                builder: (context, snapshot1) {
                  updateCandlesFromSnapshot(snapshot1);
                  return KChartWidget(
                    datasKline,
                    chartStyle,
                    chartColors,
                    isLine: isLine,
                    onSecondaryTap: () {
                      print('Secondary Tap');
                    },
                    isTrendLine: false,
                    mainState: MainState.MA,
                    volHidden: false,
                    secondaryState: SecondaryState.NONE,
                    fixedLength: 2,
                    timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                    flingCurve: Curves.bounceInOut,
                    verticalTextAlignment: VerticalTextAlignment.right,
                    translations: kChartTranslations,
                    showNowPrice: true,
                    hideGrid: false,
                  );
                }),
      ),
    );
  }

  String currentInterval = "1m";
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return Theme(
          data: day == false ? ThemeData.dark() : ThemeData.light(),
          child: mappage(),
        );
        break;
      case 1:
        return openOrdersVolume(
          symbol: widget.pair.toLowerCase(),
          familyicon: widget.familycoin,
          rate: rate,
          pairicon: widget.pair.toLowerCase() + widget.familycoin.toLowerCase(),
          listed: currency_data['listed'],
        );
        break;
      case 2:
        getbal(
            selectedcurrency: widget.familycoin.toUpperCase(),
            currency: currency_data['currency_name'].toUpperCase().toString());
        return BuySell();
        break;
      case 3:
        return orderHistory(
            symbol: widget.pair.toLowerCase(),
            familyicon: widget.familycoin,
            pairicon:
                widget.pair.toLowerCase() + widget.familycoin.toLowerCase(),
            listed: currency_data['listed']);
        break;
      case 4:
        return orderHistoryreport();

        break;
      default:
        return Theme(
            data: day == false ? ThemeData.dark() : ThemeData.light(),
            child: mappage());
    }
  }

  Widget orderHistoryreport() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.,
            children: <Widget>[
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2,
                child: MaterialButton(
                  splashColor: Color(0xff283539),
                  highlightColor: Color(0xff283539),
                  color: Color(0xff17394f),
                  onPressed: () {
                    setState(() {
                      Ordertype = "open";
                    });
                  },
                  child: Center(
                      child: Text(
                    "Open",
                    style: TextStyle(
                        color:
                            Ordertype == "open" ? Colors.white : Colors.white54,
                        fontWeight: Ordertype == "open"
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontFamily: "IBM Plex Sans",
                        letterSpacing: 1.3,
                        fontSize: 16.0),
                  )),
                ),
              ),
              SizedBox(
                width: 0.0,
              ),
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2,
                child: MaterialButton(
                  splashColor: Colors.white12,
                  highlightColor: Colors.white12,
                  color: Color(0xff17394f),
                  onPressed: () {
                    setState(() {
                      Ordertype = "complete";
                    });
                  },
                  child: Center(
                      child: Text(
                    "History",
                    style: TextStyle(
                        color: Ordertype == "complete"
                            ? Colors.white
                            : Colors.white54,
                        fontWeight: Ordertype == "complete"
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontFamily: "IBM Plex Sans",
                        letterSpacing: 1.3,
                        fontSize: 16.0),
                  )),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: Ordertype == "open" ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 7.0, bottom: 17.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            "Pair",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontFamily: "IBM Plex Sans"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Text(
                            "Amount",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontFamily: "IBM Plex Sans"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            "Price",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontFamily: "IBM Plex Sans"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              "Total",
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: "IBM Plex Sans"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      padding: EdgeInsets.only(top: 30),
                      child: remainingorder.length > 0
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (_isTrackProgress &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent &&
                                    scrollInfo.metrics.axis == Axis.vertical) {
                                  // start loading data
                                  setState(() {
                                    if (datafetch) {
                                      pagenumber = pagenumber + 1;
                                      getremainingorder(pagenumber);
                                      _isTrackProgress = true;
                                    } else {
                                      getremainingorder(pagenumber);
                                    }
                                  });
                                }
                                return _isTrackProgress = true;
                              },
                              child: isProgress
                                  ? ListView.builder(
                                      shrinkWrap: false,
                                      primary: false,
                                      itemCount: remainingorder.length,
                                      itemBuilder: (BuildContext ctx, int i) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Column(
                                            children: [
                                              Dismissible(
                                                key: UniqueKey(),
                                                confirmDismiss:
                                                    (direction) async {
                                                  if (direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                    final bool res =
                                                        await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                content: Text(
                                                                    "Are you sure you want to delete ?"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      orderid = remainingorder[i]
                                                                              [
                                                                              'id']
                                                                          .toString();

                                                                      ///cancel order
                                                                      CancelOrder(
                                                                              orderid)
                                                                          .then((value) =>
                                                                              getremainingorder(pagenumber));
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                    return res;
                                                  }
                                                  return null;
                                                },
                                                background:
                                                    slideLeftBackground(),
                                                secondaryBackground:
                                                    slideLeftBackground(),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        remainingorder[i][
                                                                    'currency'] ==
                                                                null
                                                            ? ""
                                                            : remainingorder[i][
                                                                    'currency'] +
                                                                "/" +
                                                                remainingorder[
                                                                        i][
                                                                    'with_currency'],
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        remainingorder[i][
                                                                    'at_price'] ==
                                                                null
                                                            ? ""
                                                            : double.parse(
                                                                    remainingorder[
                                                                            i][
                                                                        'at_price'])
                                                                .toStringAsFixed(
                                                                    2)
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        remainingorder[i][
                                                                    'quantity'] ==
                                                                null
                                                            ? ""
                                                            : remainingorder[i]
                                                                ['quantity'],
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            remainingorder[i][
                                                                        'total'] ==
                                                                    null
                                                                ? ""
                                                                : double.parse(
                                                                        remainingorder[i]
                                                                            [
                                                                            'total'])
                                                                    .toStringAsFixed(
                                                                        2),
                                                            style: TextStyle(
                                                                color: day ==
                                                                        false
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontFamily:
                                                                    "IBM Plex Sans",
                                                                fontSize: 12.0),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            remainingorder[i][
                                                                        'order_type'] ==
                                                                    null
                                                                ? ""
                                                                : remainingorder[
                                                                        i][
                                                                    'order_type'],
                                                            style: TextStyle(
                                                                color: remainingorder[i]
                                                                            [
                                                                            'order_type'] ==
                                                                        "sell"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                color: day == false
                                                    ? Colors.white38
                                                    : Colors.black38,
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Container(
                                      child: Text("No Data"),
                                    )))
                          : Center(
                              child: Container(
                              child: Text(
                                "No Open Orders! \n Let's Order Some Crypto !",
                                style: TextStyle(
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _isTrackProgress
                          ? Text("")
                          : Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 5,
                              )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: Ordertype == "complete" ? true : false,
          child: status == 'true'
              ? Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 7.0, bottom: 7.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  "Pair",
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: "IBM Plex Sans"),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: Text(
                                  "Amount",
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: "IBM Plex Sans"),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Text(
                                  "Price",
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: "IBM Plex Sans"),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: "IBM Plex Sans"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 1.6,
                            padding: EdgeInsets.only(top: 30),
                            child: completedata.length > 0
                                ? NotificationListener<ScrollNotification>(
                                    onNotification:
                                        (ScrollNotification scrollInfo) {
                                      if (_isTrackProgress &&
                                          scrollInfo.metrics.pixels ==
                                              scrollInfo
                                                  .metrics.maxScrollExtent &&
                                          scrollInfo.metrics.axis ==
                                              Axis.vertical) {
                                        // start loading data
                                        setState(() {
                                          if (total != pagenumber) {
                                            if (datafetch) {
                                              pagenumber = pagenumber + 1;
                                              getcompletedata(pagenumber);
                                              _isTrackProgress = false;
                                            } else {
                                              getcompletedata(pagenumber);
                                            }
                                          } else {
                                            ToastShowClass.toastShow(
                                                context,
                                                'Nothing more to show',
                                                Colors.blue);
                                          }
                                        });
                                      }
                                      return false;
                                    },
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: completedata.length,
                                      itemBuilder: (BuildContext ctx, int i) {
                                        return InkWell(
                                          onTap: () {
                                            List senddata = [];
                                            setState(() {
                                              senddata.add(completedata[i]);
                                              print("iN DATA ?  " +
                                                  senddata.toString());
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetail(
                                                          orderdetail: senddata,
                                                        )));
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        completedata[i]
                                                                ['currency'] +
                                                            "/" +
                                                            completedata[i][
                                                                'with_currency'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0,
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      // Container(
                                                      // width: 50,
                                                      // child: Divider(color: day==false?Colors.white38:Colors.black38,)),
                                                      // Text(
                                                      // completedata[i]['with_currency']==null?"":completedata[i]['with_currency'],
                                                      // style: TextStyle(
                                                      // color: day==false?Colors.white:Colors.black,
                                                      // fontFamily: "IBM Plex Sans",
                                                      // fontSize: 12.0),
                                                      // textAlign: TextAlign.start,),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        completedata[i][
                                                                    'at_price'] ==
                                                                null
                                                            ? ""
                                                            : Cr.format(double
                                                                .parse(completedata[
                                                                        i][
                                                                    'at_price'])),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0,
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      // Container(
                                                      // width: 50,
                                                      // child: Divider(color: day==false?Colors.white38:Colors.black38)),
                                                      // Text(
                                                      // completedata[i]['at_price']==null?"":Cr.format(double.parse(completedata[i]['at_price'])),
                                                      // style: TextStyle(
                                                      // color: day==false?Colors.white:Colors.black,
                                                      // fontFamily: "IBM Plex Sans",
                                                      // fontSize: 12.0),textAlign: TextAlign.center,
                                                      // ),
                                                      //
                                                      // ],
                                                      // ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        completedata[i][
                                                                    'quantity'] ==
                                                                null
                                                            ? ""
                                                            : completedata[i]
                                                                ['quantity'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "IBM Plex Sans",
                                                            fontSize: 12.0,
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            completedata[i][
                                                                        'total'] ==
                                                                    null
                                                                ? ""
                                                                : completedata[
                                                                    i]['total'],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "IBM Plex Sans",
                                                                fontSize: 12.0,
                                                                color: day ==
                                                                        false
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Container(
                                                            //color: Colors.red,
                                                            height: 25,
                                                            width: 80,
                                                            child: Center(
                                                                child: Text(
                                                              completedata[i][
                                                                          'current_status'] ==
                                                                      null
                                                                  ? ""
                                                                  : completedata[
                                                                          i][
                                                                      'current_status'],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "IBM Plex Sans",
                                                                  fontSize: 8.0,
                                                                  color: completedata[i]
                                                                              [
                                                                              'current_status'] ==
                                                                          'canceled'
                                                                      ? Colors
                                                                          .red
                                                                      : completedata[i]['current_status'] ==
                                                                              'buy'
                                                                          ? Colors
                                                                              .redAccent
                                                                          : Colors
                                                                              .greenAccent),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.white38,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ))
                                : Center(
                                    child: Container(
                                    child: Text(
                                      "No Complete Orders! \n Let's Order Some Crypto !",
                                      style: TextStyle(
                                          color: day == false
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'IBM Plex Sans'),
                                    ),
                                  )),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _isTrackProgress
                                ? Text("No More Data")
                                : Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 5,
                                    )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : _loadingData(context),
        ),
      ],
    );
  }

  Widget BuySell() {
    if (type == "buy") {
      print("BUY nAME   " + widget.familycoin.toString());
      print("P R I C E " + WalletBal.toString());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.,
            children: <Widget>[
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2,
                child: MaterialButton(
                  splashColor: Color(0xff283539),
                  highlightColor: Color(0xff283539),
                  color: Colors.green[600],
                  onPressed: () {
                    setState(() {
                      // atpricecontroller.text=currency_data['PRICE']==null?"0.00":currency_data['PRICE'].toString();

                      WalletBal = WalletBalbuy;
                      Walletqty = Walletqtybuy;
                      type = "buy";
                      amountcontroller.text = '0.00';
                      totalcontroller.text = '0.00';
                    });
                  },
                  child: Center(
                      child: Text(
                    "Buy",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "IBM Plex Sans",
                        letterSpacing: 1.3,
                        fontSize: 16.0),
                  )),
                ),
              ),
              SizedBox(
                width: 0.0,
              ),
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2,
                child: MaterialButton(
                  splashColor: Colors.white12,
                  highlightColor: Colors.white12,
                  color: Colors.redAccent.withOpacity(0.8),
                  onPressed: () {
                    setState(() {
                      //  atpricecontroller.text=currency_data['PRICE']==null?"0.00":currency_data['PRICE'].toString();

                      WalletBal = null;
                      amountcontroller.text = '0.00';
                      totalcontroller.text = '0.00';
                      WalletBal = WalletBalsell;
                      Walletqty = Walletqtysell;
                    });
                    print("cURR nAME   //././ " + WalletBal.toString());

                    setState(() {
                      type = 'sell';
                    });
                  },
                  child: Center(
                      child: Text(
                    "Sell",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "IBM Plex Sans",
                        letterSpacing: 1.3,
                        fontSize: 16.0),
                  )),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: type == "buy" ? true : false,
          child: Container(
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: DefaultTabController(
                    initialIndex: 1,
                    length: 3,
                    child: new Scaffold(
                      appBar: PreferredSize(
                        preferredSize:
                            Size.fromHeight(45.0), // here the desired height
                        child: new AppBar(
                          backgroundColor:
                              day == false ? Colors.black : Colors.white,
                          elevation: 0.0,
                          centerTitle: true,
                          flexibleSpace: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: day == false
                                      ? Colors.black
                                      : Colors.white,
                                  // border: Border(
                                  //  right: BorderSide()
                                  // ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        blurRadius: 1)
                                  ],
                                  // borderRadius: BorderRadius.only(
                                  //     topRight: Radius.circular(40.0),
                                  //     topLeft: Radius.circular(40.0)),

                                  // border: Border(
                                  //   top: BorderSide(
                                  //     color: Colors.white,
                                  //     width: 3.0,
                                  //   ),
                                  //),
                                ),
                                child: new TabBar(
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xffc79509),
                                  ),
                                  // labelColor: Theme.of(context).primaryColor,
                                  //indicatorColor: colorStyle.primaryColor,
                                  labelColor: Colors.white,
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  unselectedLabelStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  unselectedLabelColor: day == false
                                      ? Colors.white38
                                      : Colors.black45,
                                  indicatorSize: TabBarIndicatorSize.tab,

                                  tabs: [
                                    new Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Text(
                                          "Market",
                                          style: TextStyle(
                                              fontFamily: "IBM Plex Sans"),
                                        ),
                                      ),
                                    ),
                                    new Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Text(
                                          "Limit",
                                          style: TextStyle(
                                              fontFamily: "IBM Plex Sans"),
                                        ),
                                      ),
                                    ),
                                    new Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Text(
                                          "Stop Limit",
                                          style: TextStyle(
                                              fontFamily: "IBM Plex Sans"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          automaticallyImplyLeading: false,
                        ),
                      ),
                      body: new TabBarView(
                        children: [
                          Expanded(
                            child: Container(
                              color: day == false ? Colors.black : Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 30),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            //currency_data['FROMSYMBOL']
                                            Container(
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "AMOUNT",
                                                    style: TextStyle(
                                                        color: day == false
                                                            ? Colors.white54
                                                            : Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  VerticalDivider(
                                                      color: day == false
                                                          ? Colors.white54
                                                          : Colors.black45),
                                                  Text(
                                                    currency_data[
                                                            'currency_name']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: day == false
                                                          ? Colors.white54
                                                          : Colors.black45,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            TextField(
                                              onChanged: calcuate,
                                              decoration: InputDecoration(
                                                hintText: amountcontroller.text,
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black),
                                              autofocus: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: amountcontroller,
                                            ),
                                            Divider(
                                              color: day == false
                                                  ? Colors.white54
                                                  : Colors.black45,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 15, right: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        percentvalue("25");
                                                      },
                                                      child: Text(
                                                        "25%",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        percentvalue("50");
                                                      },
                                                      child: Text(
                                                        "50%",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        percentvalue("75");
                                                      },
                                                      child: Text(
                                                        "75%",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        percentvalue("100");
                                                      },
                                                      child: Text(
                                                        "Max",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              height: 40.0,
                                              padding: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffc79509),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    if (amountcontroller.text ==
                                                            "0.00" ||
                                                        amountcontroller.text ==
                                                            '') {
                                                      ToastShowClass.toastShow(
                                                          context,
                                                          "The selected Quantity is invalid",
                                                          Colors.red);
                                                      setState(() {
                                                        order = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        order = true;
                                                      });
                                                      checkstatus("market");
                                                    }
                                                  },
                                                  child: order == false
                                                      ? Text(
                                                          "Place ${widget.currency_data['currency_name'].toString()} Order",
                                                          style: TextStyle(
                                                              fontSize: 15))
                                                      : Container(
                                                          width: 20,
                                                          child: Container(
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              )))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: day == false
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          WalletBal.toString() +
                                              " " +
                                              widget.familycoin.toString(),
                                          style: TextStyle(
                                              color: day == false
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AT PRICE",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: Colors.white54),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            // Spacer(),
                                            // InkWell(
                                            //   onTap: (){
                                            //     setState(() {
                                            //       low=true;
                                            //       totalcontroller.text= (double.parse(atpricecontroller.text.toString())*double.parse(amountcontroller.text.toString())).toString();
                                            //     });
                                            //   },
                                            //   child: Align(
                                            //       alignment: Alignment.centerRight,
                                            //       child: Text("LOWEST PRICE",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),)),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: TextField(
                                          enabled: true,
                                          onChanged: calcuate,
                                          decoration: InputDecoration(
                                            hintText: atpricecontroller.text,
                                            hintStyle: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          autofocus: false,
                                          keyboardType: TextInputType.number,
                                          controller: atpricecontroller,
                                        ),
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      //currency_data['FROMSYMBOL']
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AMOUNT",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              currency_data['currency_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black54),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: calcuate,
                                        decoration: InputDecoration(
                                          hintText: amountcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          color: day == false
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        autofocus: false,
                                        keyboardType: TextInputType.number,
                                        controller: amountcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "TOTAL",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: amountcalculate,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          enabled: true,
                                          hintText: totalcontroller.text == null
                                              ? "0.00"
                                              : totalcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          color: day == false
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        autofocus: false,
                                        controller: totalcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            percentvalue("25");
                                          },
                                          child: Text(
                                            "25%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            percentvalue("50");
                                          },
                                          child: Text(
                                            "50%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            percentvalue("75");
                                          },
                                          child: Text(
                                            "75%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            percentvalue("100");
                                          },
                                          child: Text(
                                            "Max",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      color: Color(0xffc79509),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  padding: EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        if (amountcontroller.text == "0.00" ||
                                            amountcontroller.text == '') {
                                          ToastShowClass.toastShow(
                                              context,
                                              "The selected Quantity is invalid",
                                              Colors.red);
                                          setState(() {
                                            order2 = false;
                                          });
                                        } else {
                                          setState(() {
                                            order2 = true;
                                          });
                                          checkstatus("limit");
                                        }
                                      },
                                      child: order2 == false
                                          ? Text(
                                              "Place ${widget.currency_data['currency_name'].toString()} Order",
                                              style: TextStyle(fontSize: 15))
                                          : Container(
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        WalletBal.toString() +
                                            " " +
                                            widget.familycoin.toString(),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "TRIGGER PRICE",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                            // Text("0.36%",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                                            // SizedBox(width: 50,),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: TextField(
                                          enabled: true,
                                          onChanged: calcuate,
                                          decoration: InputDecoration(
                                            hintText: triggercontroller.text,
                                            hintStyle: TextStyle(
                                                color: day == false
                                                    ? Colors.white38
                                                    : Colors.black45),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          autofocus: false,
                                          keyboardType: TextInputType.number,
                                          controller: triggercontroller,
                                        ),
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AT PRICE",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                            // Text("0.36%",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                                            // SizedBox(width: 50,),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 200,
                                            child: TextField(
                                              enabled: true,
                                              onChanged: calcuate,
                                              decoration: InputDecoration(
                                                hintText:
                                                    atpricecontroller.text,
                                                hintStyle: TextStyle(
                                                    color: day == false
                                                        ? Colors.white38
                                                        : Colors.black45),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              autofocus: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: atpricecontroller,
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: (){
                                          //     setState(() {
                                          //       low=true;
                                          //       getlowprice();
                                          //       totalcontroller.text= (double.parse(atpricecontroller.text.toString())*double.parse(amountcontroller.text.toString())).toString();
                                          //     });
                                          //   },
                                          //   child: Align(
                                          //       alignment: Alignment.centerRight,
                                          //       child: Text("HIGHEST PRICE",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),)),
                                          // ),
                                        ],
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      //currency_data['FROMSYMBOL']
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AMOUNT",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              currency_data['currency_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: calcuate,
                                        decoration: InputDecoration(
                                          hintText: amountcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black),
                                        autofocus: false,
                                        keyboardType: TextInputType.number,
                                        controller: amountcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "TOTAL",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: amountcalculate,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          enabled: true,
                                          hintText: totalcontroller.text == null
                                              ? "0.00"
                                              : totalcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black),
                                        autofocus: false,
                                        controller: totalcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            percentvalue("25");
                                          },
                                          child: Text(
                                            "25%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            percentvalue("50");
                                          },
                                          child: Text(
                                            "50%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            percentvalue("75");
                                          },
                                          child: Text(
                                            "75%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            percentvalue("100");
                                          },
                                          child: Text(
                                            "Max",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      color: Color(0xffc79509),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  padding: EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        if (amountcontroller.text == "0.00" ||
                                            amountcontroller.text == '') {
                                          ToastShowClass.toastShow(
                                              context,
                                              "The selected Quantity is invalid",
                                              Colors.red);
                                          setState(() {
                                            order3 = false;
                                          });
                                        } else {
                                          setState(() {
                                            order3 = true;
                                          });
                                          checkstatus("stop_limit");
                                        }
                                      },
                                      child: order3 == false
                                          ? Text(
                                              "Place ${widget.currency_data['currency_name'].toString()} Order",
                                              style: TextStyle(fontSize: 15))
                                          : Container(
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        WalletBal.toString() +
                                            " " +
                                            widget.familycoin.toString(),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: type == "sell" ? true : false,
          child: Container(
            height: 600.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: DefaultTabController(
                    initialIndex: 1,
                    length: 3,
                    child: new Scaffold(
                      appBar: PreferredSize(
                        preferredSize:
                            Size.fromHeight(45.0), // here the desired height
                        child: new AppBar(
                          backgroundColor:
                              day == false ? Colors.black : Colors.white,
                          elevation: 0.0,
                          centerTitle: true,
                          flexibleSpace: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: day == false
                                      ? Colors.black
                                      : Colors.white,
                                  // border: Border(
                                  //  right: BorderSide()
                                  // ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        blurRadius: 1)
                                  ],
                                ),
                                child: new TabBar(
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xffc79509),
                                  ),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  unselectedLabelStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: day == false
                                      ? Colors.white38
                                      : Colors.black45,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: [
                                    new Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Text(
                                          "Market",
                                          style: TextStyle(
                                              fontFamily: "IBM Plex Sans"),
                                        ),
                                      ),
                                    ),
                                    new Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Text(
                                          "Limit",
                                          style: TextStyle(
                                              fontFamily: "IBM Plex Sans"),
                                        ),
                                      ),
                                    ),
                                    new Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Text(
                                          "Stop Limit",
                                          style: TextStyle(
                                              fontFamily: "IBM Plex Sans"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          automaticallyImplyLeading: false,
                        ),
                      ),
                      body: new TabBarView(
                        children: [
                          Expanded(
                            child: Container(
                              color: day == false ? Colors.black : Colors.white,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 30),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "AMOUNT",
                                                    style: TextStyle(
                                                        color: day == false
                                                            ? Colors.white54
                                                            : Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  VerticalDivider(
                                                      color: day == false
                                                          ? Colors.white54
                                                          : Colors.black45),
                                                  Text(
                                                    currency_data[
                                                            'currency_name']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: day == false
                                                            ? Colors.white54
                                                            : Colors.black45),
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            TextField(
                                              onChanged: calcuate,
                                              decoration: InputDecoration(
                                                hintText:
                                                    marketamountcontroller.text,
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black),
                                              autofocus: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  marketamountcontroller,
                                            ),
                                            Divider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 15, right: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          WalletBal =
                                                              WalletBalsell;
                                                        });
                                                        percentvalue("25");
                                                      },
                                                      child: Text(
                                                        "25%",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          WalletBal =
                                                              WalletBalsell;
                                                        });
                                                        percentvalue("50");
                                                      },
                                                      child: Text(
                                                        "50%",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          WalletBal =
                                                              WalletBalsell;
                                                        });
                                                        percentvalue("75");
                                                      },
                                                      child: Text(
                                                        "75%",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          WalletBal =
                                                              WalletBalsell;
                                                        });
                                                        percentvalue("100");
                                                      },
                                                      child: Text(
                                                        "Max",
                                                        style: TextStyle(
                                                            color: day == false
                                                                ? Colors.white
                                                                : Colors.black),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffc79509),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              padding: EdgeInsets.only(top: 10),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    if (amountcontroller.text ==
                                                            "0.00" ||
                                                        amountcontroller.text ==
                                                            '') {
                                                      ToastShowClass.toastShow(
                                                          context,
                                                          "The selected Quantity is invalid",
                                                          Colors.red);
                                                      setState(() {
                                                        order1 = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        order1 = true;
                                                      });
                                                      checkstatus("market");
                                                    }
                                                  },
                                                  child: order1 == false
                                                      ? Text(
                                                          "Place ${widget.currency_data['currency_name'].toString()} Order",
                                                          style: TextStyle(
                                                              fontSize: 15))
                                                      : Container(
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: day == false
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          Walletqty.toString() +
                                              " " +
                                              currency_data['currency_name']
                                                  .toString(),
                                          style: TextStyle(
                                              color: day == false
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AT PRICE",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                            // Text("0.36%",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                                            // SizedBox(width: 50,),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 200,
                                            child: TextField(
                                              enabled: true,
                                              onChanged: calcuate,
                                              decoration: InputDecoration(
                                                hintText:
                                                    atpricecontroller.text,
                                                hintStyle: TextStyle(
                                                    color: day == false
                                                        ? Colors.white
                                                        : Colors.black),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black),
                                              autofocus: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: atpricecontroller,
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: (){
                                          //     setState(() {
                                          //       low=true;
                                          //       getlowprice();
                                          //       totalcontroller.text= (double.parse(atpricecontroller.text.toString())*double.parse(amountcontroller.text.toString())).toString();
                                          //     });
                                          //   },
                                          //   child: Align(
                                          //       alignment: Alignment.centerRight,
                                          //       child: Text("HIGHEST PRICE",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),)),
                                          // ),
                                        ],
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      //currency_data['FROMSYMBOL']
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AMOUNT",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              currency_data['currency_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: calcuate,
                                        decoration: InputDecoration(
                                          hintText: amountcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black),
                                        autofocus: false,
                                        keyboardType: TextInputType.number,
                                        controller: amountcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("25");
                                          },
                                          child: Text(
                                            "25%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("50");
                                          },
                                          child: Text(
                                            "50%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("75");
                                          },
                                          child: Text(
                                            "75%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("100");
                                          },
                                          child: Text(
                                            "Max",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Walletqty.toString() +
                                            " " +
                                            currency_data['currency_name']
                                                .toString(),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "TOTAL",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: amountcalculate,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          enabled: true,
                                          hintText: totalcontroller.text == null
                                              ? "0.00"
                                              : totalcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black),
                                        autofocus: false,
                                        controller: totalcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      color: Color(0xffc79509),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  padding: EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        if (amountcontroller.text == "0.00" ||
                                            amountcontroller.text == '') {
                                          ToastShowClass.toastShow(
                                              context,
                                              "The selected Quantity is invalid",
                                              Colors.red);
                                          setState(() {
                                            order2 = false;
                                          });
                                        } else {
                                          setState(() {
                                            order2 = true;
                                          });
                                          checkstatus("limit");
                                        }
                                      },
                                      child: order2 == false
                                          ? Text(
                                              "Place ${widget.currency_data['currency_name'].toString()} Order",
                                              style: TextStyle(fontSize: 15))
                                          : Container(
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: day == false ? Colors.black : Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "TRIGGER PRICE",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                            // Text("0.36%",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                                            // SizedBox(width: 50,),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: TextField(
                                          enabled: true,
                                          onChanged: calcuate,
                                          decoration: InputDecoration(
                                            hintText: triggercontroller.text,
                                            hintStyle: TextStyle(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                              color: day == false
                                                  ? Colors.white
                                                  : Colors.black),
                                          autofocus: false,
                                          keyboardType: TextInputType.number,
                                          controller: triggercontroller,
                                        ),
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AT PRICE",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: Colors.white54),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: Colors.white54),
                                            ),
                                            SizedBox(width: 10),
                                            // Text("0.36%",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                                            // SizedBox(width: 50,),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 200,
                                            child: TextField(
                                              enabled: true,
                                              onChanged: calcuate,
                                              decoration: InputDecoration(
                                                hintText:
                                                    atpricecontroller.text,
                                                hintStyle: TextStyle(
                                                    color: day == false
                                                        ? Colors.white54
                                                        : Colors.black45),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white
                                                      : Colors.black),
                                              autofocus: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: atpricecontroller,
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: (){
                                          //     setState(() {
                                          //       low=true;
                                          //       getlowprice();
                                          //       totalcontroller.text= (double.parse(atpricecontroller.text.toString())*double.parse(amountcontroller.text.toString())).toString();
                                          //     });
                                          //   },
                                          //   child: Align(
                                          //       alignment: Alignment.centerRight,
                                          //       child: Text("HIGHEST PRICE",style: TextStyle(color:  Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),)),
                                          // ),
                                        ],
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "AMOUNT",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              currency_data['currency_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: calcuate,
                                        decoration: InputDecoration(
                                          hintText: amountcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black),
                                        autofocus: false,
                                        keyboardType: TextInputType.number,
                                        controller: amountcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("25");
                                          },
                                          child: Text(
                                            "25%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("50");
                                          },
                                          child: Text(
                                            "50%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("75");
                                          },
                                          child: Text(
                                            "75%",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              WalletBal = WalletBalsell;
                                            });
                                            percentvalue("100");
                                          },
                                          child: Text(
                                            "Max",
                                            style: TextStyle(
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Walletqty.toString() +
                                            " " +
                                            currency_data['currency_name']
                                                .toString(),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Text(
                                              "TOTAL",
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            VerticalDivider(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black45),
                                            Text(
                                              widget.familycoin,
                                              style: TextStyle(
                                                  color: day == false
                                                      ? Colors.white54
                                                      : Colors.black45),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      TextField(
                                        onChanged: amountcalculate,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          enabled: true,
                                          hintText: totalcontroller.text == null
                                              ? "0.00"
                                              : totalcontroller.text,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            color: day == false
                                                ? Colors.white
                                                : Colors.black),
                                        autofocus: false,
                                        controller: totalcontroller,
                                      ),
                                      Divider(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black45),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      color: Color(0xffc79509),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  padding: EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        if (amountcontroller.text == "0.00" ||
                                            amountcontroller.text == '') {
                                          ToastShowClass.toastShow(
                                              context,
                                              "The selected Quantity is invalid",
                                              Colors.red);
                                          setState(() {
                                            order3 = false;
                                          });
                                        } else {
                                          setState(() {
                                            order3 = true;
                                          });
                                          checkstatus("stop_limit");
                                        }
                                      },
                                      child: order3 == false
                                          ? Text(
                                              "Place ${widget.currency_data['currency_name'].toString()} Order",
                                              style: TextStyle(fontSize: 15))
                                          : Container(
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: day == false ? Colors.black : Colors.white,
      key: scaffoldState,
      body: StreamBuilder(
          stream: currency_data['listed'] == "true"
              ? _channel_own.stream
              : _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("wait ing ");
              return screendata();
            } else if (snapshot.hasError) {
              return screendata();
            } else if (snapshot.connectionState == ConnectionState.active) {
              //place your code here. It will prevent double data call.
              item = json.decode(snapshot.hasData ? snapshot.data : '');
              if (currency_data['listed'] == "true") {
                log(item.toString());
                if (item.keys.contains("ohlc")) {
                  currency_data['PRICE'] = item['c'];
                  currency_data['HIGHDAY'] = item['h'];
                  currency_data['LOWDAY'] = item['l'];

                  currency_data['24chg'] =
                      item['P'] == null ? "0.00" : item['P'];
                  vol = item['v'] == null ? "0.00" : item['v'];

                  try {
                    Status = 'E';

                    if (double.parse(currency_data['VOLUMEDAYTO']) ==
                        prevprice) {
                      Status = 'E';
                      print("E");
                    } else if (double.parse(currency_data['VOLUMEDAYTO']) >
                        prevprice) {
                      Status = 'G';
                      print("G");
                    } else {
                      Status = 'S';
                      print("S");
                    }
                    prevprice = double.parse(currency_data['VOLUMEDAYTO']);

                    Status_currentprice = 'E';

                    if (double.parse(currency_data['PRICE']) ==
                        currentprice_pre) {
                      Status_currentprice = 'E';
                      print("E");
                    } else if (double.parse(currency_data['PRICE']) >
                        currentprice_pre) {
                      Status_currentprice = 'G';
                      print("G");
                    } else {
                      Status_currentprice = 'S';
                      print("S");
                    }
                    currentprice_pre = double.parse(currency_data['PRICE']);
                  } catch (e) {}
                } else {}
              } else {
                //print("check iktem data ???" + item.toString());
                currency_data['PRICE'] = item['c'];
                currency_data['HIGHDAY'] = item['h'];
                currency_data['LOWDAY'] = item['l'];
                currency_data['24chg'] = item['P'] == null ? "0.00" : item['P'];
                vol = item['v'] == null ? "0.00" : item['v'];

                //atpricecontroller.text = currency_data['PRICE'].toString();

                // currency_data['VOLUMEDAYTO']=item['P'];
                try {
                  Status = 'E';

                  if (double.parse(currency_data['VOLUMEDAYTO']) == prevprice) {
                    Status = 'E';
                    print("E");
                  } else if (double.parse(currency_data['VOLUMEDAYTO']) >
                      prevprice) {
                    Status = 'G';
                    print("G");
                  } else {
                    Status = 'S';
                    print("S");
                  }
                  prevprice = double.parse(currency_data['VOLUMEDAYTO']);

                  Status_currentprice = 'E';

                  if (double.parse(currency_data['PRICE']) ==
                      currentprice_pre) {
                    Status_currentprice = 'E';
                    print("E");
                  } else if (double.parse(currency_data['PRICE']) >
                      currentprice_pre) {
                    Status_currentprice = 'G';
                    print("G");
                  } else {
                    Status_currentprice = 'S';
                    print("S");
                  }
                  currentprice_pre = double.parse(currency_data['PRICE']);
                } catch (e) {}
              }
              return screendata();
            } else {
              return screendata();
            }
          }),
    );
  }

  Widget screendata() {
    var grayText = TextStyle(
        color: day == false ? Colors.white : Colors.black,
        fontFamily: "IBM Plex Sans",
        fontSize: 12.5);
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Flexible(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.02, left: 15.0, right: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )),
                            Text(
                              currency_data['currency_name']
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.w600,
                                fontSize: 20.5,
                              ),
                            ),
                            Text(
                              ' / ' + widget.familycoin,
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: "IBM Plex Sans",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            InkWell(
                                onTap: () {
                                  if (status == 'true') {
                                    if (fav == false) {
                                      setState(() {
                                        fav = true;
                                        ToastShowClass.toastShow(
                                            context,
                                            "${widget.pair} added to favourites",
                                            Colors.blue);
                                        SharedPreferenceClass.SetSharedData(
                                          "FavPair",
                                          widget.pair.toLowerCase() +
                                              widget.familycoin +
                                              '@ticker',
                                        );
                                        addtofav();
                                      });
                                    } else {
                                      setState(() {
                                        ToastShowClass.toastShow(
                                            context,
                                            "${widget.pair} removed from favourites",
                                            Colors.blue);
                                        fav = false;
                                        Deletetofav(widget.pair.toString() +
                                            widget.familycoin);
                                      });
                                    }
                                  } else {
                                    ToastShowClass.toastShow(context,
                                        "You're not Login!", Colors.blue);
                                  }
                                },
                                child: fav == false
                                    ? Icon(
                                        Icons.star_border_outlined,
                                        color: Color(0xffc79509),
                                        size: 25,
                                      )
                                    : Icon(
                                        Icons.star,
                                        color: Color(0xffc79509),
                                        size: 30,
                                      )),
                          ],
                        ),
                        Text(
                          currency_data['PRICE'] == null
                              ? "0.00"
                              : double.parse(currency_data['PRICE']).toString(),
                          style: TextStyle(
                              color: Status_currentprice == 'S'
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 25.0,
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 7.0),
                              child: Text(
                                "Vol :",
                                style: TextStyle(
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 11.0),
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(vol,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                  fontFamily: 'IBM Plex Sans',
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 7.0),
                              child: Text(
                                "24Chnge :",
                                style: TextStyle(
                                    color: day == false
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 11.0),
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(
                                currency_data['24chg'] == null
                                    ? "0.00"
                                    : double.parse(currency_data['24chg'])
                                            .toStringAsFixed(2) +
                                        "%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    fontFamily: 'IBM Plex Sans',
                                    color:
                                        double.parse(currency_data['24chg']) < 0
                                            ? Colors.redAccent
                                            : Color(0xFF00C087))),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Row(
                          //   children: <Widget>[
                          //     Text(
                          //       currency_data['LASTVOLUME'].toString(),
                          //       style: grayText,
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.only(left: 10.0),
                          //       child: Text(
                          //         currency_data['VOLUMEDAYTO']==null?"0.00":Cr.format(currency_data['VOLUMEDAYTO']),style: TextStyle(color:Colors.red),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 7.0),
                                child: Text(
                                  "High :",
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: "IBM Plex Sans",
                                      fontSize: 11.0),
                                ),
                              ),
                              SizedBox(
                                height: 7.0,
                              ),
                              Text(
                                currency_data['HIGHDAY'] == null
                                    ? "0.00"
                                    : double.parse(currency_data['HIGHDAY'])
                                        .toStringAsFixed(4),
                                style: grayText,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 7.0),
                                child: Text(
                                  "Low :",
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: "IBM Plex Sans",
                                      fontSize: 11.0),
                                ),
                              ),
                              Text(
                                currency_data['LOWDAY'] == null
                                    ? "0.00"
                                    : double.parse(currency_data['LOWDAY'])
                                        .toStringAsFixed(4),
                                style: grayText,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: currentIndex == 0 ? true : false,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      width: screenSize.width * 0.98,
                      // alignment: Alignment.bottomLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("1m");
                                  isclick = true;
                                }
                                selected = "1";
                              });
                            },
                            child: Container(
                                color: selected == "1"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "1m",
                                  style: TextStyle(
                                      color: selected == "1"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("5m");
                                  isclick = true;
                                }
                                selected = "5";
                              });
                            },
                            child: Container(
                                color: selected == "5"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "5m",
                                  style: TextStyle(
                                      color: selected == "5"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("15m");
                                  isclick = true;
                                }
                                selected = "15";
                              });
                            },
                            child: Container(
                                color: selected == "15"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "15m",
                                  style: TextStyle(
                                      color: selected == "15"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("30m");
                                  isclick = true;
                                }
                                selected = "30";
                              });
                            },
                            child: Container(
                                color: selected == "30"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "30m",
                                  style: TextStyle(
                                      color: selected == "30"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("1h");
                                  isclick = true;
                                }
                                selected = "1h";
                              });
                            },
                            child: Container(
                                color: selected == "1h"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "1h",
                                  style: TextStyle(
                                      color: selected == "1h"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("2h");
                                  isclick = true;
                                }
                                selected = "2h";
                              });
                            },
                            child: Container(
                                color: selected == "2h"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "2h",
                                  style: TextStyle(
                                      color: selected == "2h"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("4h");
                                  isclick = true;
                                }
                                selected = "4h";
                              });
                            },
                            child: Container(
                                color: selected == "4h"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "4h",
                                  style: TextStyle(
                                      color: selected == "4h"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("6h");
                                  isclick = true;
                                }
                                selected = "6h";
                              });
                            },
                            child: Container(
                                color: selected == "6h"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "6h",
                                  style: TextStyle(
                                      color: selected == "6h"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("12h");
                                  isclick = true;
                                }
                                selected = "12h";
                              });
                            },
                            child: Container(
                                color: selected == "12h"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "12h",
                                  style: TextStyle(
                                      color: selected == "12h"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("1d");
                                  isclick = true;
                                }
                                selected = "1d";
                              });
                            },
                            child: Container(
                                color: selected == "1d"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "1d",
                                  style: TextStyle(
                                      color: selected == "1d"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isclick) {
                                  binanceFetchcandle("1w");
                                  isclick = true;
                                }
                                selected = "1w";
                              });
                            },
                            child: Container(
                                color: selected == "1w"
                                    ? Color(0xffc79509)
                                    : day == false
                                        ? Colors.white10
                                        : Colors.black12,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "1w",
                                  style: TextStyle(
                                      color: selected == "1w"
                                          ? Colors.white
                                          : day == false
                                              ? Colors.white38
                                              : Colors.black38,
                                      fontSize: 10),
                                )),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              callPage(currentIndex),
              Visibility(
                visible:
                    Ordertype == "complete" && currentIndex == 4 ? true : false,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      if (all == true) {
                        setState(() {
                          all = false;
                          currencycompletedata.clear();
                          for (int i = 0; i < completedata.length; i++) {
                            if (completedata[i]['currency']
                                        .toString()
                                        .toUpperCase() +
                                    completedata[i]['with_currency']
                                        .toString()
                                        .toUpperCase() ==
                                currency_data['currency_name']
                                        .toString()
                                        .toUpperCase() +
                                    widget.familycoin.toUpperCase()) {
                              currencycompletedata.add(completedata[i]);

                            }
                          }
                          completedata.clear();
                          completedata.addAll(currencycompletedata);

                        });
                        print("N A M E " + currencycompletedata.toString());
                      } else {
                        setState(() {
                          all = true;
                          getcompletedata(1);
                        });
                      }
                    },
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff17394f),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            all == true
                                ? currency_data['currency_name']
                                        .toString()
                                        .toUpperCase() +
                                    " orders"
                                : "All orders",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Stack(
          children: [
            Card(
              color: day == false ? Color(0xff181818) : Color(0xffffffff),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        binanceFetchcandle("1m");

                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.stacked_bar_chart,
                              color: currentIndex == 0
                                  ? Colors.white
                                  : Colors.white),
                          Text("Chart",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: currentIndex == 0
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: currentIndex == 0
                                      ? FontWeight.bold
                                      : FontWeight.w500)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.web,
                              color: currentIndex == 1
                                  ? Colors.white
                                  : Colors.white),
                          Text("Order",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: currentIndex == 1
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: currentIndex == 1
                                      ? FontWeight.bold
                                      : FontWeight.w500)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          atpricecontroller.text = currency_data['PRICE'] ==
                                  null
                              ? "0.00"
                              : double.parse(currency_data['PRICE']).toString();

                          print("AT PRICE ? " +
                              atpricecontroller.text.toString());
                          currentIndex = 2;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.05),
                        child: Text(
                          "Buy/Sell",
                          style: TextStyle(
                              fontSize: 10,
                              color: currentIndex == 2
                                  ? Colors.white
                                  : Colors.white,
                              fontWeight: currentIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.w500),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 3;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.reorder_sharp,
                              color: currentIndex == 3
                                  ? Colors.white
                                  : Colors.white),
                          Text("Trade",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: currentIndex == 3
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: currentIndex == 3
                                      ? FontWeight.bold
                                      : FontWeight.w500)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 4;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.import_export,
                              color: currentIndex == 4
                                  ? Colors.white
                                  : Colors.white),
                          Text("My Order",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: currentIndex == 4
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: currentIndex == 4
                                      ? FontWeight.bold
                                      : FontWeight.w500)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0.0, -0.4),
              child: Align(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: day == false ? Colors.black : Colors.white,
                    radius: 25.0,
                    child: Image.asset("assets/image/logo2.png"),
                  ),
                ),
                alignment: FractionalOffset(0.5, 0.0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void calcuate(String value) {
    print("C AL " + currency_data['decimal_pair'].toString());
    totalcontroller.text = '0';
    totalcontroller.text = (double.parse(atpricecontroller.text.toString()) *
            double.parse(amountcontroller.text.toString()))
        .toStringAsFixed(currency_data['decimal_pair'] == null
            ? 0
            : int.parse(currency_data['decimal_pair'].toString()));
    print(totalcontroller.text.toString() + " TO TAL ");
  }

  void amountcalculate(String value) {
    amountcontroller.text = '0';
    setState(() {
      amountcontroller.text = (double.parse(totalcontroller.text.toString()) /
              double.parse(atpricecontroller.text.toString()))
          .toStringAsFixed(currency_data['decimal_currency'] == null
              ? 0
              : int.parse(currency_data['decimal_currency'].toString()));
    });
  }

  void percentvalue(String bal) {
    print("va le totallll  " + WalletBal.toString());

    totalcontroller.text = '0';
    amountcontroller.text = '0';
    totalcontroller.text =
        (double.parse(WalletBal) * double.parse(bal.toString()) / 100)
            .toStringAsFixed(currency_data['decimal_currency'] == null
                ? 0
                : int.parse(currency_data['decimal_currency'].toString()));
    print("va le  " + atpricecontroller.text.toString());

    amountcontroller.text = (double.parse(totalcontroller.text.toString()) /
            double.parse(atpricecontroller.text.toString()))
        .toString();
    print("va le " + amountcontroller.text.toString());
  }

  Widget _loadingData(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 20,
        itemBuilder: (ctx, i) {
          return loadingCard(ctx, i);
        },
      ),
    );
  }

  Widget loadingCard(BuildContext ctx, int i) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Shimmer.fromColors(
        baseColor: Color(0xFF3B4659),
        highlightColor: Color(0xFF606B78),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(ctx).hintColor,
                          radius: 13.0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 15.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                    color: Theme.of(ctx).hintColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(
                              height: 12.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(ctx).hintColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 15.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              color: Theme.of(ctx).hintColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 12.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                                color: Theme.of(ctx).hintColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    height: 25.0,
                    width: 55.0,
                    decoration: BoxDecoration(
                        color: Theme.of(ctx).hintColor,
                        borderRadius: BorderRadius.all(Radius.circular(2.0))),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
              child: Container(
                width: double.infinity,
                height: 0.5,
                decoration: BoxDecoration(color: Colors.black12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Limit {
  String id;
  String name;
  Limit(this.id, this.name);

  static List<Limit> getlimit() {
    return <Limit>[
      Limit('1', 'Limit'),
      Limit('2', 'No Limit'),
    ];
  }
}

class SymbolsSearchModal extends StatefulWidget {
  const SymbolsSearchModal({
    Key key,
    this.onSelect,
    this.symbols,
  }) : super(key: key);

  final Function(String symbol) onSelect;
  final List<String> symbols;

  @override
  State<SymbolsSearchModal> createState() => _SymbolSearchModalState();
}

class _SymbolSearchModalState extends State<SymbolsSearchModal> {
  String symbolSearch = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height * 0.75,
          color: Theme.of(context).backgroundColor.withOpacity(0.5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  onChanged: (value) {
                    setState(() {
                      symbolSearch = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: widget.symbols
                      .where((element) => element
                          .toLowerCase()
                          .contains(symbolSearch.toLowerCase()))
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 50,
                              height: 30,
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: const Color(0xFF494537),
                                onPressed: () {
                                  widget.onSelect(e);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    color: Color(0xFFF0B90A),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key key, this.onChanged}) : super(key: key);
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      cursorColor: const Color(0xFF494537),
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Color(0xFF494537),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color(0xFF494537)), //<-- SEE HER
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color(0xFF494537)), //<-- SEE HER
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color(0xFF494537)), //<-- SEE HER
        ),
      ),
      onChanged: onChanged,
    );
  }
}
