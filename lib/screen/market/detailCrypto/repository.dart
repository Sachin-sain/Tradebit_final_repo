import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;

Future<List<Candle>> fetchCandles(
    {String symbol, String interval,double rate,String familycoin,String islisted}) async {
  List owndata=[];
  if(islisted=="true"){

    final uri = Uri.parse(
        "https://server.bitqixnode.co.in/orders/getohlc?symbol=$symbol&interval=$interval&limit=10000");
    print("own datra"+uri.toString());
    owndata.clear();
    final res = await http.get(uri);
    var data=json.decode(res.body);

      for(var i=0; i<data['data'].length; i++) {
        print("start"+data['data'][i]['ohlc']['v'].toString());

        owndata.add(
            [
              data['data'][i]['start_time'],
              data['data'][i]['ohlc']['o'].toString(),
              data['data'][i]['ohlc']['h'].toString(),
              data['data'][i]['ohlc']['l'].toString(),
              data['data'][i]['ohlc']['c'].toString(),
              data['data'][i]['ohlc']['v'].toString(),
              data['data'][i]['end_time'],
              "0",
              0,
              "0",
              "0",
              "0"

              // data['data'][i]['ohlc']['h'].toString(),
              /// data['data'][i]['ohlc']['l'].toString(),
              // data['data'][i]['ohlc']['o'].toString(),
              // data['data'][i]['ohlc']['c'].toString(),
              /// data['data'][i]['ohlc']['v'].toString(),

            ]
        );



        // candleList.add(Candle(
        //   date: DateTime.fromMillisecondsSinceEpoch(data['data'][i]['start_time']),
        //   high: double.parse(data['data'][i]['ohlc']['h'].toString()),
        //   low: double.parse(data['data'][i]['ohlc']['l'].toString()),
        //   open: double.parse(data['data'][i]['ohlc']['o'].toString()),
        //   close: double.parse(data['data'][i]['ohlc']['c'].toString()),
        //   volume: double.parse(data['data'][i]['ohlc']['v'].toString())==0?54.0546326:double.parse(data['data'][i]['ohlc']['v'].toString()),
        // ));
      }
    print("o w n d a t a =-==-=-=-");
    print(owndata.toString());
    return (owndata)
        .map((e) => Candle.fromJson(e)).toList();
  }

  else{
    final uri = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=10000");
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
    // .toList()
    // .reversed
        .toList();

  }

}
