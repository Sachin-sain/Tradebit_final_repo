// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:exchange/screen/setting/NotificationManager.dart';
import 'package:exchange/screen/setting/PriceAlertDatabase.dart';
import 'package:exchange/screen/setting/createPriceAlertScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///get priceAlert coin list
  List<PriceAlertModel> priceAlertList = [];

  // var list = await PriceAlertDatabase.db.getAllProducts() as List;
  // //print()
  // for (var i=0; i<list.length; i++) {
  //   priceAlertList.add(PriceAlertModel(
  //       id: list.elementAt(i)['id'],
  //       coinName: list.elementAt(i)['coinName'],
  //       coinImage: list.elementAt(i)['coinImage'],
  //       coinSymbol: list.elementAt(i)['coinSymbol'],
  //       coinPrice: list.elementAt(i)['coinPrice'],
  //       isNotified: list.elementAt(i)['isNotified'],
  //       priceUp: list.elementAt(i)['priceUp'],
  //   ));
  //
  //
  //   var contain = tickersList.where((element) => element == list.elementAt(i)['coinSymbol'].toString().toLowerCase() + '@ticker');
  //   if(contain.isEmpty) {
  //     //print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  //     tickersList.add(list.elementAt(i)['coinSymbol'].toLowerCase() + "@ticker");
  //   }
  //
  // }

  //print('!!!!!!!!!!!!!!! '  + list.toString());

  ///

  /// websocket
  var subRequest_usdthome = {
    'method': "SUBSCRIBE",
    //'params': ConstantClass.tickerList,
    //'params': tickersList,
    'params': [
      "ethbtc@ticker",
      "bttbtc@ticker",
      "winbtc@ticker",
      "dentbtc@ticker",
      "xrpbtc@ticker",
      "etcbtc@ticker",
      "dogebtc@ticker",
      "bnbbtc@ticker",
      "yfibtc@ticker",
      "cakebtc@ticker",
      "vetbtc@ticker",
      "maticbtc@ticker",
      "trxbtc@ticker",
      "eosbtc@ticker",
      "btcusdt@ticker",
      "ethusdt@ticker",
      "bttusdt@ticker",
      "winusdt@ticker",
      "dentusdt@ticker",
      "xrpusdt@ticker",
      "etcusdt@ticker",
      "dogeusdt@ticker",
      "bnbusdt@ticker",
      "yfiusdt@ticker",
      "cakeusdt@ticker",
      "vetusdt@ticker",
      "maticusdt@ticker",
      "trxusdt@ticker",
      "eosusdt@ticker",
      "usdcusdt@ticker",
      "denteth@ticker",
      "xrpeth@ticker",
      "etceth@ticker",
      "bnbeth@ticker",
      "veteth@ticker",
      "trxeth@ticker",
      "eoseth@ticker",
      "bttbnb@ticker",
      "winbnb@ticker",
      "xrpbnb@ticker",
      "etcbnb@ticker",
      "dogebnb@ticker",
      "yfibnb@ticker",
      "cakebnb@ticker",
      "vetbnb@ticker",
      "maticbnb@ticker",
      "trxbnb@ticker",
      "eosbnb@ticker"
    ],
    'id': 1,
  };

  var jsonString = json.encode(subRequest_usdthome);
  channel_home.sink.add(jsonString);
  //var snapshot = channel_home.stream;
  var result = channel_home.stream.transform(
    StreamTransformer<dynamic, dynamic>.fromHandlers(
      handleData: (number, sink) {
        //print("###################123456"+sink.toString());
        if (number == 70) {
          sink.addError("Hit seventy");
        } else {
          sink.add(number);
        }
      },
    ),
  );
  var snapshot;
  result.listen((event) {
    snapshot = jsonDecode(event);
  });
  //result.listen((data) => print("###################123"+data));
  ///

  if (Platform.isIOS) FlutterBackgroundServiceIOS.registerWith();
  if (Platform.isAndroid) FlutterBackgroundServiceAndroid.registerWith();

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event["action"] == "setAsForeground") {
      service.setAsForegroundService();
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setAsBackgroundService();
    }

    if (event["action"] == "stopService") {
      service.stopService();
    }
  });

  // bring to foreground
  service.setAsForegroundService();
  Timer.periodic(const Duration(seconds: 5), (timer) async {

    if (!(await service.isRunning())) timer.cancel();
    await Notify.instantNotify('Price ALert', snapshot['s'].toString() + ' reached at ' + snapshot['p'].toString());



    var list = await PriceAlertDatabase.db.getAllProducts() as List;
    //print()
    priceAlertList.clear();
    for (var i=0; i<list.length; i++) {
      priceAlertList.add(PriceAlertModel(
        id: list.elementAt(i)['id'],
        coinName: list.elementAt(i)['coinName'],
        coinImage: list.elementAt(i)['coinImage'],
        coinSymbol: list.elementAt(i)['coinSymbol'],
        coinPrice: list.elementAt(i)['coinPrice'],
        isNotified: list.elementAt(i)['isNotified'],
        priceUp: list.elementAt(i)['priceUp'],
      ));


      // var contain = tickersList.where((element) => element == list.elementAt(i)['coinSymbol'].toString().toLowerCase() + '@ticker');
      // if(contain.isEmpty) {
      //   //print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      //   tickersList.add(list.elementAt(i)['coinSymbol'].toLowerCase() + "@ticker");
      // }

      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' + priceAlertList.elementAt(0).coinSymbol + ' ===== '+ priceAlertList.elementAt(0).coinPrice.toString());

    }


    if(list.isEmpty) {
      service.stopService();
    }


    ///

    // if(snapshot != null && snapshot.containsKey('s') == true) {
    //   var contain = priceAlertList.where((element) => element.coinSymbol == snapshot['s']);
    //
    //   if(contain.isNotEmpty) {
    //     //Notify.instantNotify('title', 'body');
    //     for(var i=0; i<contain.length; i++) {
    //       if(contain.elementAt(i).priceUp == 0){
    //         if(double.parse(snapshot['c']) >= contain.elementAt(i).coinPrice) {
    //           // await PriceAlertDatabase.db.delete(contain.elementAt(i).id);
    //           // priceAlertList.removeWhere((element) => element.id == contain.elementAt(i).id);
    //           print('foundPriceAlertUP@@@@@@@@@@@@@ ' + snapshot['s'].toString() + ' == ' + contain.elementAt(i).toString());
    //         }
    //       }
    //       else {
    //         if(double.parse(snapshot['c']) <= contain.elementAt(i).coinPrice) {
    //           await Notify.instantNotify('Price ALert', contain.elementAt(i).coinName.toString() + ' reached at ' + contain.elementAt(i).coinPrice.toString());
    //           // await PriceAlertDatabase.db.delete(contain.elementAt(i).id);
    //           // priceAlertList.removeWhere((element) => element.id == contain.elementAt(i).id);
    //           print('foundPriceAlertDOWN@@@@@@@@@@@@@ ' + snapshot['s'].toString() + ' == ' + contain.elementAt(i).toString());
    //         }
    //       }
    //     }
    //   }
    //   else {
    //     //Notify.instantNotify('title2', 'body2');
    //     //service.stopService();
    //   }
    // }


    //result.listen((data) => print("###################123"+data));
    //print('snapshot@@@@@@@@@@@@@' + priceAlertList.elementAt(1).coinName.toString());
    //print('snapshot@@@@@@@@@@@@@' + snapshot['c'].toString());
    //print('foundPriceAlert@@@@@@@@@@@@@ ' + snapshot['s'].toString() + ' == ' + snapshot['c'].toString());
    //connectToServer();
    ///


    service.setNotificationInfo(
      title: "Price Alert",
      content: snapshot['s'].toString() + ' price reached at ' + snapshot['c'].toString(),
    );

    // test using external plugin
    // final deviceInfo = DeviceInfoPlugin();
    // String device;
    // if (Platform.isAndroid) {
    //   final androidInfo = await deviceInfo.androidInfo;
    //   device = androidInfo.model;
    // }
    //
    // if (Platform.isIOS) {
    //   final iosInfo = await deviceInfo.iosInfo;
    //   device = iosInfo.model;
    // }
    //
    // service.sendData(
    //   {
    //     "current_date": DateTime.now().toIso8601String(),
    //     "device": device,
    //   },
    // );
  });
}


///websockeet
WebSocketChannel channel_home = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);

Future<dynamic> connectToServer() async {
  var subRequest_usdthome = {
    'method': "SUBSCRIBE",
    'params': ['btcusdt@ticker'],
    'id': 1,
  };

  var jsonString = json.encode(subRequest_usdthome);
  channel_home.sink.add(jsonString);
  //var snapshot = channel_home.stream;
  // var s1 = StreamBuilder(
  //     builder: (context, snapshot) {
  //       print('snapshot@@@@@@@@@@@@@' + snapshot.toString());
  //      return Container();
  //     });


  var result = channel_home.stream.transform(
    StreamTransformer.fromHandlers(
      handleData: (number, sink) {
        print('snapshot@@@@@@@@@@@@@123' + sink.toString());
        // if (number == 70) {
        //   sink.addError("Hit seventy");
        // } else {
        //   sink.add(number);
        // }
      },
    ),
  );

  result.listen((data) => print(data));

  print('snapshot@@@@@@@@@@@@@' + result.toString());
}
///
