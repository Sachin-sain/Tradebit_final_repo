import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/library/intro_views_flutter-2.4.0/lib/Models/asks_bids_response.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class Price extends StatefulWidget {
  const Price({key});
  @override
  State<Price> createState() => _PriceState();
}
class _PriceState extends State<Price> {
   WebSocketChannel channel;
  List<List<String>> bids = [];
  List<List<String>> asks = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Column(

        children: [
          Expanded(
            child: ListView.separated(itemBuilder: (c,i){
              // future:fetchData();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(bids[i].first, style: TextStyle(color: Colors.red),),
                    AutoSizeText(bids[i].last, style: TextStyle(color: Colors.blueGrey),),
                ],
              );
            }, separatorBuilder: (c,i){
              return SizedBox();
            }, itemCount: bids.length ?? 0,
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.separated(itemBuilder: (c,i){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(asks[i].first, style: TextStyle(color: Colors.green),),

                    AutoSizeText(asks[i].last, style: TextStyle(color: Colors.blueGrey),),
                ],
              );
            }, separatorBuilder: (c,i){
              return SizedBox();
            }, itemCount: asks.length ?? 0,
            ),
          )
        ],
      );
  }
  Future<void> fetchData() async {
    final Symbol = "BTCUSDT";
    final Map<String, String> paramDic = {
      "limit": "20",
    };
    try {
      final response = await APIMainClassbinance(APIClasses.openorder + Symbol, paramDic, "Get");
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













