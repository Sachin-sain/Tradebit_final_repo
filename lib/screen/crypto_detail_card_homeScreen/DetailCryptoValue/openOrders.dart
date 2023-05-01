// import 'dart:convert';
//
//
// import 'package:exchange/component/CardDetail/AmountSell.dart';
// import 'package:exchange/component/CardDetail/BuyAmount.dart';
// import 'package:exchange/config/APIClasses.dart';
// import 'package:exchange/config/constantClass.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:wakelock/wakelock.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// String SYMBOL="";
//
// class openOrders extends StatefulWidget {
//   final Widget child;
//   String symbol;
//   String familyicon;
//   String pairicon;
//   double rate;
//   String length;
//   String listed;
//   openOrders({Key key, this.child,this.symbol,this.familyicon,this.pairicon,this.rate,this.length,this.listed}) : super(key: key);
//
//   _openOrdersState createState() => _openOrdersState();
// }
//
// class _openOrdersState extends State<openOrders> {
//   @override
//   void initState() {
//     print("dashh"+widget.symbol.toString());
//     Wakelock.enable();
//     if(widget.symbol.contains('ξ')){
//       widget.symbol='ETH';
//       setState(() {
//         SYMBOL= widget.symbol.toLowerCase();
//       });
//
//
//     }else{
//       setState(() {
//         SYMBOL= widget.symbol.toLowerCase();
//       });
//
//
//     }
//     connectToServer();
//
//     // TODO: implement initState
//     super.initState();
//   }
//   static NumberFormat Cr = new NumberFormat("###0.00", "en_US");
//   static NumberFormat Crone = new NumberFormat("###0.0", "en_US");
//   var item;
//
//
//   WebSocketChannel channel_usdt = IOWebSocketChannel.connect(
//     Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
//   );
//   WebSocketChannel channel_usdtOwn =IOWebSocketChannel.connect(
//     Uri.parse(APIClasses.websocket_url),
//   );
//
//   Future<void> connectToServer() {
//     print("SYM "+widget.familyicon.toString());
//     var jsonString;
//     if(widget.familyicon=="INR"){
//       widget.listed=='true'?
//       jsonString= json.encode({
//         'method': "ADD",
//         'params': [
//           widget.symbol.toLowerCase()+'usdt@depth20@1000ms',
//         ],
//         'id': 3,
//       }):jsonString= json.encode({
//         'method': "SUBSCRIBE",
//         'params': [
//           widget.symbol.toLowerCase()+'usdt@depth20@1000ms',
//         ],
//         'id': 3,
//       });
//       print("SYM "+jsonString.toString());
//     }else{
//       widget.listed=='true'?
//       jsonString = json.encode({
//         'method': "ADD",
//         'params': [
//           widget.pairicon.toLowerCase()+'@depth20@1000ms',
//         ],
//         'id': 3,
//       }):jsonString = json.encode({
//         'method': "SUBSCRIBE",
//         'params': [
//           widget.pairicon.toLowerCase()+'@depth20@1000ms',
//         ],
//         'id': 3,
//       });
//     }
//
//     widget.listed=='true'?channel_usdtOwn.sink.add(jsonString):channel_usdt.sink.add(jsonString);
//
//   }
//
//   @override
//   void dispose() {
//     channel_usdt.sink.close();
//     // firsttimemarketDepth=0;
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double mediaQuery = MediaQuery.of(context).size.width / 2.2;
//     var screensize = MediaQuery.of(context).size;
//     return Container(
//       color:  Colors.transparent,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           //  Divider(color:  day==false?Colors.white38:Colors.black45,),
//
//           Container(
//             color: Colors.transparent,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 7.0,top: 5.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(left: 12.0),
//                     child: Text(
//                       "Buy Amount",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: "IBM Plex Sans"),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 15),
//                     child: Text(
//                       "Price",
//                       style: TextStyle(
//                           color: Colors.white, fontFamily: "IBM Plex Sans"),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10.0),
//                     child: Text(
//                       "Amount Sell",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: "IBM Plex Sans"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 5.0,
//           ),
//
//
//           StreamBuilder(
//               stream: widget.listed=='true'?channel_usdtOwn.stream:channel_usdt.stream,
//               builder: (context, snapshot) {
//                 print("LIST LENGTH "+amountSellList.length.toString()+"    -====  "+length.toString());
//                 if (snapshot.connectionState == ConnectionState.waiting ) {
//                   return length!="0"?Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         //  height: screensize.height*buyAmountList.length,
//                         width: mediaQuery,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           primary: false,
//                           itemCount: buyAmountList.length,
//                           itemBuilder: (BuildContext ctx, int i) {
//                             return _buyAmount(mediaQuery, buyAmountList[i]);
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 5,),
//                       Container(
//                         //  height: screensize.height*buyAmountList.length,
//                         width: mediaQuery,
//                         child:  amountSellList.length>0?ListView.builder(
//                           shrinkWrap: true,
//                           primary: false,
//                           itemCount: amountSellList.length,
//                           itemBuilder: (BuildContext ctx, int i) {
//                             return _amountSell(mediaQuery, amountSellList[i]);
//                           },
//                         ):Column(),
//                       ),
//                     ],):Center(child: Container(child: Text("No Open Orders"),));
//                 }
//                 // else if(snapshot.connectionState == ConnectionState.waiting && firsttimemarketDepth==1){
//                 //   return
//                 // }
//                 //
//                 else if (snapshot.hasError) {
//                   return Center(child: Text(snapshot.error.toString()));
//                 }
//                 else if (snapshot.connectionState == ConnectionState.active) {
//                   //place your code here. It will prevent double data call.
//                   item = json.decode(snapshot.hasData ? snapshot.data : '');
//                   firsttimemarketDepth=1;
//                   if(snapshot.hasData) {
//                     try{
//                       if(item['bids'].length>0) {
//                         print("openOrderDetail" + item['bids'].toString());
//                         double lastamount = 0.0;
//                         double lastamountasks = 0.0;
//                         double large_value = 0.0;
//
// //buy
//                         for (int i = 0; i < item['bids'].length; i++) {
//                           buyAmountList[i].price =
//                               Cr.format(double.parse(item['bids'][i][0].toString()))
//                                   .toString();
//                           lastamount =
//                               lastamount + double.parse(item['bids'][i][1].toString());
//                           buyAmountList[i].value = Cr.format(lastamount).toString();
//                           print(buyAmountList[i].value.toString() + "------------" +
//                               buyAmountList[i].price.toString());
//                         }
//
// //sell
//                         for (int i = 0; i < item['asks'].length; i++) {
//                           amountSellList[i].price =
//                               Cr.format(double.parse(item['asks'][i][0].toString()))
//                                   .toString();
//                           lastamountasks =
//                               lastamountasks + double.parse(item['asks'][i][1].toString());
//                           amountSellList[i].value = Cr.format(lastamountasks).toString();
//                           print(amountSellList[i].value.toString() + "------------" +
//                               amountSellList[i].price.toString());
//                         }
//                         large_value = double.parse(amountSellList[9].value) >
//                             double.parse(buyAmountList[9].value) ? double.parse(
//                             amountSellList[9].value) : double.parse(
//                             buyAmountList[9].value);
//
//
//                         for (int i = 0; i < item['asks'].length; i++) {
//                           buyAmountList[i].percent =
//                               (double.parse(buyAmountList[i].value) / large_value)
//                                   .toString();
//                           amountSellList[i].percent =
//                               (double.parse(amountSellList[i].value) / large_value)
//                                   .toString();
//                         }
//                       }
//                     }catch(Exception){
//                        print("no datatatta");
//                     }
//                   }
//                   return length!="0"?Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         //height: screensize.height*buyAmountList.length,
//                         width: mediaQuery,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           primary: false,
//                           itemCount:listed=="true"?int.parse(length):buyAmountList.length,
//                           itemBuilder: (BuildContext ctx, int i) {
//                             return _buyAmount(mediaQuery, buyAmountList[i]);
//                           },
//                         ),
//                       ),
//
//
//                       SizedBox(width: 5,),
//                       Container(
//                         //  height: screensize.height*buyAmountList.length,
//                         width: mediaQuery,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           primary: false,
//                           itemCount: amountSellList.length,
//                           itemBuilder: (BuildContext ctx, int i) {
//                             return _amountSell(mediaQuery, amountSellList[i]);
//                           },
//                         ),
//                       ),
//                     ],):Center(child: Container(child: Text("No Open Orders"),));
//                 }
//                 return length!="0"?Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       //  height: screensize.height*buyAmountList.length,
//                       width: mediaQuery,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         primary: false,
//                         itemCount:buyAmountList.length,
//                         itemBuilder: (BuildContext ctx, int i) {
//                           return _buyAmount(mediaQuery, buyAmountList[i]);
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 5,),
//                     Container(
//                       //  height: screensize.height*buyAmountList.length,
//                       width: mediaQuery,
//                       child: amountSellList.length>0?ListView.builder(
//                         shrinkWrap: true,
//                         primary: false,
//                         itemCount:amountSellList.length,
//                         itemBuilder: (BuildContext ctx, int i) {
//                           return _amountSell(mediaQuery, amountSellList[i]);
//                         },
//                       ):Column(),
//                     ),
//                   ],):Center(child: Container(child: Text("No Open Orders"),));
//               }),
//
//         ],
//       ),
//     );
//   }
//   Widget _buyAmount(double _width, buyAmount item) {
//     double price=double.parse(item.price)*widget.rate;
//     print(price.toString());
//     print("price.toString()");
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0,left:5.0),
//       child: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//               color: Colors.green.withOpacity(0.2),
//               width: _width * double.parse(Crone.format(double.parse(item.percent))), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
//               height: 25,
//             ),
//           ),
//           Container(
//             width:  _width,
//             height: 25,
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //           Padding(
//                 //   padding: const EdgeInsets.only(right: 8.0),
//                 //   child: Text(
//                 //     item.number,
//                 //     style: TextStyle(
//                 //         color: Theme.of(context).hintColor,
//                 //         fontFamily: "IBM Plex Sans",
//                 //         fontSize: 15.0),
//                 //   ),
//                 // ),
//
//                 Text(
//                   item.value,
//                   style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 12.0,color: day==false?Colors.white:Colors.black),
//                 ),
//                 Spacer(),
//                 Text(
//                   widget.familyicon=="INR"? Cr.format(price).toString(): double.parse(item.price).toStringAsFixed(2),
//                   style: TextStyle(
//                       color: Colors.green[600],
//                       fontWeight: FontWeight.w700,
//                       fontFamily: "IBM Plex Sans",
//                       fontSize: 12.0),
//                 ),
//               ],),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _amountSell(double _width, amountSell item) {
//     double price=double.parse(item.price)*widget.rate;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0,right:00.0),
//       child: Stack(
//         children: <Widget>[
//           Container(
//
//             width:_width,
//             height: 25,
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.familyicon=="INR"? Cr.format(price).toString(): double.parse(item.price).toStringAsFixed(2),
//                   style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w700,
//                       fontFamily: "IBM Plex Sans",
//                       fontSize: 12.0),
//                 ),
//                 Spacer(),
//                 Text(
//                   item.value,
//                   style: TextStyle(fontFamily: "IBM Plex Sans", fontSize: 12.0,color: day==false?Colors.white:Colors.black),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(right: 8.0),
//                 //   child: Text(
//                 //     item.number,
//                 //     style: TextStyle(
//                 //         color: Theme.of(context).hintColor,
//                 //         fontFamily: "IBM Plex Sans",
//                 //         fontSize: 15.0),
//                 //   ),
//                 // ),
//               ],),
//           ),
//           Container(
//             color: Colors.redAccent.withOpacity(0.2),
//             width: _width * double.parse(Crone.format(double.parse(item.percent))), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
//             height: 25,
//           ),
//         ],
//       ),
//     );
//   }
// }
