import 'dart:async';
import 'dart:convert';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/library/intro_views_flutter-2.4.0/lib/Models/asks_bids_response.dart';
import 'package:exchange/library/intro_views_flutter-2.4.0/lib/Models/crypto_response.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Price extends StatefulWidget {
  final List currency;
  final String symbol;
  final String currencyNeed;
  final String pair;
  bool firstTime;

  Price(
      {key,
      this.currency,
      this.symbol,
      this.firstTime,
      this.currencyNeed,
      this.pair});
  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {
  Future<void> fetchdata;
  bool firstime = true;
  List<List<String>> bids;
  List<List<String>> asks;
  StreamController _controller = StreamController();
  var socket = SocketResponse();
  List<SocketResponse> res = [];
  WebSocketChannel _channel = IOWebSocketChannel.connect(
    Uri.parse(APIClasses.biananceSocketUrl),
  );

  WebSocketChannel channel_usdt = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );
  Future<void> connectToServer() {
    var jsonString = json.encode(subRequest_usdt);
    channel_usdt.sink.add(jsonString);
  }

  @override
  void initState() {
    connectToServer();
    fetchdata = fetchData();
    firstime = widget.firstTime;
    super.initState();
    _channel.stream.listen((event) {
      res.add(socketResponseFromJson(event));
      _controller.add(event);
    }, onError: (e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchdata,
        builder: (c, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            ));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Text("Volume", style: TextStyle(
                   color: day == false
                       ? Colors.white
                       : Color(0xff0a0909),fontSize: 12),),
                 Text("Price", style: TextStyle(
                   color: day == false
                       ? Colors.white
                       : Color(0xff0a0909),fontSize: 12))
               ],
             ),
              SizedBox(height: 3,),
              Expanded(
                flex: 1,

                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: bids.length == 0 ? 0 : bids.length,
                    itemBuilder: (c, i) {
                      if (bids.isEmpty) {
                        return Center(child: Text('No data'));
                      }
                      if(bids.isNotEmpty && bids.length > 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Text(
                                double.parse(
                                    bids[i].isEmpty ? "0.0" : bids[i].first)
                                    .toStringAsFixed(4),
                                style: TextStyle(
                                  color: Colors.green[600],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                double.parse(bids.isEmpty ? "0.0" : bids[i].last)
                                    .toStringAsFixed(4),
                                style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Color(0xff0a0909),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Text('No data');
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 2, top: 10),
                child: Text(
                  double.parse(bids.isEmpty ? "0.0" : bids.first[0]).toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                child: Text(
                  "= ${double.parse(bids.isEmpty ? "0.0" : bids.last[0]).toStringAsFixed(2)} USD",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: asks.isEmpty ? 0 : asks.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (c, i) {
                      if (asks.isEmpty) {
                        return Center(child: Text('No data'));
                      }
                      if(asks.isNotEmpty && asks.length > 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  double.parse(asks.isEmpty ? '0.0' : asks[i].first)
                                      .toStringAsFixed(4),
                                  style: TextStyle(color: Colors.red)),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                double.parse(asks.isEmpty ? '0.0' : asks[i].last)
                                    .toStringAsFixed(4),
                                style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Color(0xff0a0909),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Text("no data");
                    }),
              ),
            ],
          );
        });
  }

  Future<void> fetchData() async {
    final symbol = widget.firstTime == false ? widget.symbol : 'BTCUSDT';
    final Map<String, String> paramDic = {
      "limit": "10",
    };
    try {
      final response = await APIMainClassbinance(
          APIClasses.openorder + symbol, paramDic, "Get");
      if (response?.statusCode == 200) {
        var data = newDataFromJson(response.body);
        setState(() {
          bids = data.data.bids;
          asks = data.data.asks;
        });
      } else {
        throw Exception('Unable to fetch data ');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
