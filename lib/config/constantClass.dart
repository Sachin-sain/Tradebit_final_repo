// ignore_for_file: non_constant_identifier_names, missing_return, unnecessary_statements

import 'dart:convert';
import 'package:exchange/component/coinData.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/screen/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'APIClasses.dart';
import 'APIMainClass.dart';
import 'SharedPreferenceClass.dart';
import 'package:http/http.dart' as http;

String mode;
String alerts;
String Connection;

Future<bool> getMode() async {
  mode = await SharedPreferenceClass.GetSharedData("day");
  alerts = await SharedPreferenceClass.GetSharedData("alert") == null
      ? "false"
      : await SharedPreferenceClass.GetSharedData("alert");
  firstTime = await SharedPreferenceClass.GetSharedData('first_time') == "null"
      ? "false"
      : await SharedPreferenceClass.GetSharedData('first_time');

  mode == "daytrue" ? true : false;
  print("checkmodettr" + alerts.toString());
  print("checkmodettr" + firstTime.toString());
}

String firstTime;
int firsttimesearch = 0;
int firsttimebtc = 0;
int firsttimeeth = 0;
int firsttimeusdt = 0;
int firsttimexrp = 0;
int firsttimefav = 0;
int firsttimehome = 0;
int firsttimegainer = 0;
int firsttimeloser = 0;
int firsttimewallet = 0;
int firsttimewallet1 = 0;
int firsttimeopenoredr = 0;
int firsttimebtcdetail = 0;
int firsttimeethdetail = 0;
int firsttimeusdtdetail = 0;
int firsttimexrpdetail = 0;
int firsttimemarketDepth = 0;
int firsttimeordervol = 0;
int firsttimetradehistory = 0;
bool day = mode != null
    ? mode == "daytrue"
        ? true
        : false
    : false;
String listed = "";
String length;
int notification_count = 0;

var subRequest_usdthome = {
  'method': "SUBSCRIBE",
  'params': [
    "btcusdt@ticker",
    "ethusdt@ticker",
    "xrpusdt@ticker",
    "etcusdt@ticker"
  ],
  'id': 1,
};

var subRequest_usdt;

var subRequest_btc;
var subRequest_eth;
var subRequest_bnb;
var subRequest_FAV;
var subRequest_Search;
var subRequest_inr;
List ticker_data_own = [];
List ticker_data_owninr = [];
var subRequest_btc_own;
var subRequest_btc_owninr;
List ticker_data_INR = [];

List ticker_data = [];
Map<String, dynamic> btcMarketList_raw;
Map<String, dynamic> btcMarketList_display;
var data;
Map<dynamic, List<dynamic>> currency_find = new Map();
String selectedPair = "";
bool isSwitched = false;
bool alert = alerts == 'true' ? true : false;
bool notify = true;

String Verifiedstatus;
int fees;
String bnbPAIR = "";

List bnb = [];

Map<dynamic, dynamic> cfind = new Map();
List<PairFrontdata> pairfront = [];
List<String> marketfamily = [];

class PairFrontdata {
  String coin;
  String paircoin;
  List datacoin;
  PairFrontdata({this.coin, this.paircoin, this.datacoin});
}

Map<dynamic, List<Map<String, dynamic>>> currency_pair123 = new Map();
Map<dynamic, Map<dynamic, List<Map<String, dynamic>>>> Currency_data =
    new Map();
Map<dynamic, Map<dynamic, List<Map<String, dynamic>>>> Currency_datasearch =
    new Map();
Map<dynamic, Map<dynamic, List<Map<String, dynamic>>>> Currency_datacheck =
    new Map();
Map<dynamic, Map<dynamic, List<Map<String, dynamic>>>> Currency_dataold =
    new Map();
List<CoinsData> allCoinsListData = [];
List<dynamic> currencyList = [];
List<dynamic> tickerList = [];
List<dynamic> listedTickerList = [];
List datacheck;

bool checkstatus = false;

Widget interneterror() {
  return Container(
    child: Center(
      child: Column(
        children: [
          Icon(
            Icons.wifi_off,
            size: 50,
            color: Colors.white,
          ),
          Text("Connection failed: Please check your network settings. ")
        ],
      ),
    ),
  );
}

Future<List<CoinsData>> getAllCoins() async {
  String url = 'https://server.bitqixnode.co.in/list-crypto/get';
  List<CoinsData> coinsList = [];

  try {
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    if (data['status_code'].toString() == '1') {
      print("D A T A ? " + data['data'].toString());
      allCoinsListData.clear();
      currencyList.clear();
      tickerList.clear();

      for (var i = 0; i < data['data'].keys.length; i++) {
        currencyList.add(data['data'].keys.elementAt(i).toString());
        for (var j = 0;
            j < data['data'][data['data'].keys.elementAt(i).toString()].length;
            j++) {
          coinsList.add(CoinsData(
            coinImage: data['data'][data['data'].keys.elementAt(i).toString()]
                [j]['image'],
            coinName: data['data'][data['data'].keys.elementAt(i).toString()][j]
                ['name'],
            coinShortName: data['data']
                [data['data'].keys.elementAt(i).toString()][j]['currency'],
            coinPrice: data['data'][data['data'].keys.elementAt(i).toString()]
                [j]['price'],
            coinPercentage: data['data']
                [data['data'].keys.elementAt(i).toString()][j]['change'],
            coinSymbol: data['data'][data['data'].keys.elementAt(i).toString()]
                [j]['symbol'],
            coinPairWith: data['data']
                [data['data'].keys.elementAt(i).toString()][j]['pair_with'],
            coinHighDay: data['data'][data['data'].keys.elementAt(i).toString()]
                [j]['high'],
            coinLowDay: data['data'][data['data'].keys.elementAt(i).toString()]
                [j]['low'],
          ));
        }
      }

      for (var i = 0; i < data['tickers'].length; i++) {
        tickerList.add(
            data['tickers'].elementAt(i).toString().toLowerCase() + "@ticker");
      }
      for (var i = 0; i < data['listed_tickers'].length; i++) {
        listedTickerList.add(
            data['listed_tickers'].elementAt(i).toString().toLowerCase() +
                "@kline");
      }

      return coinsList;
    } else {
      ToastMessage.showToast(null, 'Something went wrong!!', Colors.red);
      return coinsList;
    }
  } catch (e) {
    ToastMessage.showToast(null, e.toString(), Colors.red);
    allCoinsListData = [];
    currencyList = [];
    return coinsList;
  }
}

Future<void> currencyget() async {
  final paramDic = {
    "": "",
  };
  var response =
      await APIMainClassbinance(APIClasses.currencyget, paramDic, "Get");
  data = json.decode(response.body);
  ticker_data.clear();
  ticker_data_INR.clear();
  if (response.statusCode == 200) {
    for (int k = 0; k < data['tickers'].length; k++) {
      String result = data['tickers'][k].toString().substring(
          data['tickers'][k].toString().length - 3,
          data['tickers'][k].toString().length);
      if (result == 'INR') {
        ticker_data_INR.add(data['tickers'][k]
                .toString()
                .replaceAll('INR', 'USDT')
                .toLowerCase() +
            "@ticker");
      } else {
        ticker_data
            .add(data['tickers'][k].toString().toLowerCase() + "@ticker");
      }
    }
    for (int k = 0; k < data['listed_tickers'].length; k++) {
      String result = data['listed_tickers'][k].toString().substring(
          data['listed_tickers'][k].toString().length - 3,
          data['listed_tickers'][k].toString().length);
      if (result == 'INR') {
        ticker_data_owninr.add(data['listed_tickers'][k]
                .toString()
                .replaceAll('INR', 'USDT')
                .toLowerCase() +
            "@ticker");
      } else {
        ticker_data_own.add(
            data['listed_tickers'][k].toString().toLowerCase() + "@ticker");
      }
    }
    print("ticker data" + ticker_data_owninr.toString());
    print("ticker data INR" + ticker_data_own.toString());
    marketfamily.add("FAV");
    for (int j = 0; j < data['data'].length; j++) {
      marketfamily.add(data['data'].keys.toList()[j].toString().toUpperCase());

      bnb.clear();
      bnbPAIR = "";
      bnb = data['data'][data['data'].keys.toList()[j].toString()];
      for (int i = 0; i < bnb.length; i++) {
        if (bnbPAIR == "") {
          bnbPAIR = bnb[i]['currency'];
        } else {
          bnbPAIR = bnbPAIR + "," + bnb[i]['currency'];
        }
        pairfront.add(PairFrontdata(
            coin: data['data'].keys.toList()[j].toString(),
            paircoin: bnb[i]['symbol'].toString(),
            datacoin: [
              {'currency_name': ''},
              {'pair': ''},
              {'icon': ''},
              {'currentprice': 0.0},
              {'lastprice': 0.0},
              {'24chg': 0.0},
              {'listed': 0},
              {'decimal_currency': ''},
              {'decimal_pair': ''}
            ]));
      }

      currency_find.putIfAbsent(
          data['data'].keys.toList()[j].toString(), () => [bnbPAIR.toString()]);
    }
  } else {}

  for (int m = 0; m < pairfront.length; m++) {
    currency_pair123.putIfAbsent(
        pairfront[m].paircoin.toString(),
        () => [
              {'currency_name': ''},
              {'pair': ''},
              {'icon': ''},
              {'currentprice': 0.0},
              {'lastprice': 0.0},
              {'24chg': 0.0},
              {'listed': false},
              {'decimal_currency': ''},
              {'decimal_pair': '0.0'},
              {'low': '0.0'},
              {'high': '0.0'}
            ]);
    if (m != pairfront.length - 1) {
      if (pairfront[m].coin.toString() == pairfront[m + 1].coin.toString()) {
      } else {
        Currency_data.putIfAbsent(
            pairfront[m].coin.toString(), () => new Map.from(currency_pair123));
        Currency_dataold.putIfAbsent(
            pairfront[m].coin.toString(), () => new Map.from(currency_pair123));
        currency_pair123.clear();
      }
    } else {
      Currency_data.putIfAbsent(
          pairfront[m].coin.toString(), () => new Map.from(currency_pair123));
      Currency_dataold.putIfAbsent(
          pairfront[m].coin.toString(), () => new Map.from(currency_pair123));
    }
  }
  subRequest_FAV = {
    'method': "SUBSCRIBE",
    'params': ticker_data,
    'id': 1,
  };
  subRequest_bnb = {
    'method': "SUBSCRIBE",
    'params': ticker_data,
    'id': 1,
  };
  subRequest_inr = {
    'method': "SUBSCRIBE",
    'params': ticker_data_INR,
    'id': 1,
  };

  subRequest_eth = {
    'method': "SUBSCRIBE",
    'params': ticker_data,
    'id': 1,
  };

  subRequest_btc = {
    'method': "SUBSCRIBE",
    'params': ticker_data,
    'id': 1,
  };

  subRequest_btc_own = {
    'method': "ADD",
    'params': ticker_data_own,
    'id': 1,
  };
  subRequest_btc_owninr = {
    'method': "ADD",
    'params': ticker_data_owninr,
    'id': 1,
  };
}

Future<void> BTCAPI({String CurrencyName}) async {
  final paramDic = {"": ""};
  print("CurrencyName" + CurrencyName);
  var response = await APIMainClassbinance(APIClasses.currencyget, paramDic, "Get");
  data = json.decode(response.body);
  btcMarketList_raw = null;
  if (response.statusCode == 200) {
    btcMarketList_raw = data['data'];
    print("cheeck" + CurrencyName);
    if (CurrencyName != "FAV") {
      for (int i = 0; i < btcMarketList_raw[CurrencyName].length; i++) {
        try {
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [0]['currency_name'] =
              btcMarketList_raw[CurrencyName][i]['currency'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [1]['pair'] =
              btcMarketList_raw[CurrencyName][i]['currency'].toString() +
                  ' / ' +
                  btcMarketList_raw[CurrencyName][i]['pair_with'].toString();
          Currency_data[CurrencyName]
                  [btcMarketList_raw[CurrencyName][i]['symbol'].toString()][2]
              ['icon'] = btcMarketList_raw[CurrencyName][i]['image'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [3]['currentprice'] =
              btcMarketList_raw[CurrencyName][i]['price'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [4]['lastprice'] =
              btcMarketList_raw[CurrencyName][i]['low'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [5]['24chg'] =
              btcMarketList_raw[CurrencyName][i]['change'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [6]['listed'] =
              btcMarketList_raw[CurrencyName][i]['listed'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [7]['decimal_currency'] =
              btcMarketList_raw[CurrencyName][i]['decimal_currency'].toString();
          Currency_data[CurrencyName]
                      [btcMarketList_raw[CurrencyName][i]['symbol'].toString()]
                  [8]['decimal_pair'] =
              btcMarketList_raw[CurrencyName][i]['decimal_pair'].toString();
          Currency_data[CurrencyName]
                  [btcMarketList_raw[CurrencyName][i]['symbol'].toString()][9]
              ['low'] = btcMarketList_raw[CurrencyName][i]['low'].toString();
          Currency_data[CurrencyName]
                  [btcMarketList_raw[CurrencyName][i]['symbol'].toString()][10]
              ['high'] = btcMarketList_raw[CurrencyName][i]['high'].toString();
        } catch (e) {}
      }
      Currency_datasearch.addAll(Currency_data);
    }
  } else {}
}

Map<String, bool> CurrencyName = {
  'BTC': false,
  'ETH': false,
  'BTT': false,
  'WIN': false,
  'DENT': false,
  'XRP': false,
  'ETC': false,
  'DOGE': false,
  'BNB': false,
  'YFI': false,
  'CAKE': false,
  'VET': false,
  'MATIC': false,
  'TRX': false,
  'EOS': false,
  'POLY': false,
  'USDC': false,
  'USDT': false,
};

String totalBalance;
String freezedtotalBalance;
bool walletBalanceLoading = false;
Future<void> getCryptoData() async {
  try {
    // selected_currency = await SharedPreferenceClass.GetSharedData('Currency');
    // selected_currency == null ? selected_currency = 'USDT' : selected_currency;
    final paramDic = {
      "": '',
    };
    var response =
        await APIMainClassbinance(APIClasses.Crypto_Data, paramDic, "Get");
    var data = json.decode(response.body);
    if (data['message'] == "Unauthenticated") {
      SharedPreferenceClass.RemoveAllSharedData();
      print('response body===>' + data['message'].toString());
      print("START 1 ");
    } else {
      savedothercryptodata.clear();
      if (response.statusCode == 200) {
        totalBalance = data['mainTotal'];
        freezedtotalBalance = data['freezedTotal'];
        savedothercryptodata = data['data'];
        print("SHARE " + savedothercryptodata.toString());
        // for(int i=0;i<savedothercryptodata.length;i++){
        // if(selectedcurrency==savedothercryptodata[i]['name']) {
        //   print("BAL ? " +savedothercryptodata[i]['c_bal'].toString());
        //   WalletBal=savedothercryptodata[i]['c_bal'];
        //   Walletqty = savedothercryptodata[i]['quantity'];
        //   print('Wallet Saved Data ==>' + WalletBal.toString());
        //   print(Walletqty.toString());
        // }
        //
        // if(currency==savedothercryptodata[i]['name']) {
        //   print("BAL ? " +savedothercryptodata[i]['c_bal'].toString());
        //   WalletBalsell=savedothercryptodata[i]['c_bal'];
        //   Walletqtysell = savedothercryptodata[i]['quantity'];
        //   print('Wallet Saved Data ==>' + WalletBal.toString());
        //   print(Walletqty.toString());
        // }}

        //walletBalanceLoading = false;

        walletBalanceLoading = true;
      } else {
        print('Failed => ');
        walletBalanceLoading = false;
      }
    }
  } catch (e) {
    walletBalanceLoading = false;
  }
}

var rate = 0.0;

Future<void> getRate() async {
  final paramDic = {
    "": "",
  };
  var response;
  response = await APIMainClassbinance(APIClasses.INRrate, paramDic, "Get");
  var data = json.decode(response.body);
  if (response.statusCode == 200) {
    rate = data['rate'];
  } else {
    //ToastShowClass.toastShow(context, data["message"], Colors.red);
  }
}
