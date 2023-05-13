// ignore_for_file: must_be_immutable, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';


import 'package:exchange/component/coinData.dart';
import 'package:exchange/component/textFormFieldDecoration.dart';
import 'package:exchange/config/Color.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/setting/PriceAlertDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'Foreground_Service.dart';

class CreatePriceAlertScreen extends StatefulWidget {

  // var coinDetails;

  Data data;
  CreatePriceAlertScreen({this.data});

  @override
  State<CreatePriceAlertScreen> createState() => _CreatePriceAlertScreenState();
}

class Data {
  String coinName;
  String coinSymbol;
  String coinPrice;
  String coinImage;

  Data({this.coinName, this.coinSymbol, this.coinPrice, this.coinImage});
}

class _CreatePriceAlertScreenState extends State<CreatePriceAlertScreen> {

  String selectedCoin = '';
  String selectedCoinSymbol = '';
  List<PriceAlertModel> priceAlert = [];
  int priceUP = 0;
  bool isProgress = false;

  var selectedCoinDetail = {'coinName': '', 'coinSymbol': '', 'coinPrice': '', 'coinImage': ''};

  final TextEditingController _userPrice = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();


  addPriceAlert(snapshot) {
    var contain = priceAlert.where((element) => element.coinSymbol == selectedCoinDetail['coinSymbol']);
    if(_userPrice.text.isNotEmpty) {
      if(double.parse(_userPrice.text.toString()) >= double.parse(selectedCoinDetail['coinPrice'].toString()) * 50.0) {
        ToastMessage.showToast(context, 'Alert should not be greater than 50 times the current price', Colors.red);
        setState(() {
          isProgress = false;
        });
      }
      else {
        if(contain.isNotEmpty) {
          for(var i=0; i<contain.length; i++) {
            print('!!!!!!!!! ' + contain.length.toString() + '==' + selectedCoinDetail['coinName'].toString());
            if(contain.elementAt(i).coinPrice == double.parse(_userPrice.text.toString())) {
              print('@@##!!'  + contain.elementAt(i).coinName.toString());
              ToastMessage.showToast(context, 'You can\'t create same price alert again', Colors.red);
              setState(() {
                isProgress = false;
              });
              return;
            }
            else {
              ///insert into local database
              PriceAlertDatabase.db.insert(
                  int.parse(getTimestamp().toString()),
                  selectedCoinDetail['coinName'].toString(),
                  selectedCoinDetail['coinImage'].toString(),
                  selectedCoinDetail['coinSymbol'].toString(),
                  double.parse(_userPrice.text.toString()),
                  0,
                  priceUP,
              );
              ///

              ///insert into list
              priceAlert.add(PriceAlertModel(
                  id: int.parse(getTimestamp().toString()),
                  coinName: selectedCoinDetail['coinName'].toString(),
                  coinImage: selectedCoinDetail['coinImage'].toString(),
                  coinSymbol: selectedCoinDetail['coinSymbol'].toString(),
                  coinPrice: double.parse(_userPrice.text.toString()),
                  isNotified: 0,
                  priceUp: priceUP,
              ));

              ToastMessage.showToast(context, 'Price Alert Added Successfully', Colors.green);

              setState(() {
                isProgress = false;
              });

              checkPrice(snapshot, selectedCoinSymbol, selectedCoin);
              return;

            }
          }
        }
        else {
          ///insert into local database
          PriceAlertDatabase.db.insert(
              int.parse(getTimestamp().toString()),
              selectedCoinDetail['coinName'].toString(),
              selectedCoinDetail['coinImage'].toString(),
              selectedCoinDetail['coinSymbol'].toString(),
              double.parse(_userPrice.text.toString()),
              0,
              priceUP,
          );
          ///

          ///insert into list
          priceAlert.add(PriceAlertModel(
              id: int.parse(getTimestamp().toString()),
              coinName: selectedCoinDetail['coinName'].toString(),
              coinImage: selectedCoinDetail['coinImage'].toString(),
              coinSymbol: selectedCoinDetail['coinSymbol'].toString(),
              coinPrice: double.parse(_userPrice.text.toString()),
              isNotified: 0,
              priceUp: priceUP,
          ));

          ToastMessage.showToast(context, 'Price Alert Added Successfully', Colors.green);

          setState(() {
            isProgress = false;
          });

          checkPrice(snapshot, selectedCoinSymbol, selectedCoin);
          return;
        }
      }
    }
  }


  ///get priceAlert coin list
  getAllPriceAlertList() async {
    var list = await PriceAlertDatabase.db.getAllProducts() as List;
    //print()
    for (var i=0; i<list.length; i++){
      priceAlert.add(PriceAlertModel(
          id: list.elementAt(i)['id'],
          coinName: list.elementAt(i)['coinName'],
          coinImage: list.elementAt(i)['coinImage'],
          coinSymbol: list.elementAt(i)['coinSymbol'],
          coinPrice: list.elementAt(i)['coinPrice'],
          isNotified: 0,
          priceUp: priceUP,
      ));
    }
    print('!!!!!!!!!!!!!!! '  + list.toString());
  }
  ///

  ///get timestamp
  getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
  ///


  /// API

  List<CoinsData> allCoinsList = [];
  List<dynamic> tickersList = tickerList;
  WebSocketChannel channel_home = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);

  getCOinhs() async {
    allCoinsList = await getAllCoins();
    print(" AL  NO MAY "+allCoinsList.toString());
    selectDefaultCoin();

  }

  Future<void> connectToServer() async {
    var subRequest_usdthome = {
      'method': "SUBSCRIBE",
      'params': tickersList,
      'id': 1,
    };

    var jsonString = json.encode(subRequest_usdthome);
    channel_home.sink.add(jsonString);
  }

  selectDefaultCoin() {

    if(widget.data.coinName == null) {
      if(allCoinsList.isNotEmpty) {
        selectedCoinDetail['coinName'] = allCoinsList[0].coinName;
        selectedCoinDetail['coinSymbol'] = allCoinsList[0].coinSymbol;
        selectedCoinDetail['coinPrice'] = allCoinsList[0].coinPrice;
        selectedCoinDetail['coinImage'] = allCoinsList[0].coinImage;
      }
      else {
        ToastMessage.showToast(context, 'Something went wrong!!', Colors.amber);
      }
    }


    if(widget.data.coinName != null && widget.data.coinName.isNotEmpty && widget.data.coinSymbol != null && widget.data.coinSymbol.isNotEmpty && widget.data.coinPrice != null) {
      selectedCoinDetail['coinName'] = widget.data.coinName;
      selectedCoinDetail['coinSymbol'] = widget.data.coinSymbol;
      selectedCoinDetail['coinPrice'] = widget.data.coinPrice;
      selectedCoinDetail['coinImage'] = widget.data.coinImage;
    }
    else {
      if(allCoinsList.isNotEmpty) {
        selectedCoinDetail['coinName'] = allCoinsList[0].coinName;
        selectedCoinDetail['coinSymbol'] = allCoinsList[0].coinSymbol;
        selectedCoinDetail['coinPrice'] = allCoinsList[0].coinPrice;
        selectedCoinDetail['coinImage'] = allCoinsList[0].coinImage;
      }
      else {
        ToastMessage.showToast(context, 'Something went wrong!!', Colors.amber);
      }
    }
  }


  void disConnectFromServer() {
    channel_home.sink.close();
  }
  ///


  void checkPrice(snapshot, selectedCoinSymbol, selectedCoin) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeService();
    // var data = json.decode(snapshot.data as String);
    //
    // print('******1 ' + _userPrice.text.toString());
    // if(double.parse(_userPrice.text.toString()) >= double.parse(data['c'].toString())) {
    //   print('******23');
    //   //await Notify.instantNotify('Price Alert', '$selectedCoinSymbol price reached ' + _userPrice.text.toString());
    // }
  }

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await getAllCoins();
      await getCOinhs();
      await connectToServer();
      await getAllPriceAlertList();

      setState(() { });
    });
    //print('@@@@@@@@@@4321'+ ConstantClass.allCoinsListData.toString());
    // selectDefaultCoin();
    super.initState();
  }

  @override
  void dispose() {
    disConnectFromServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Create Price Alert', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 17, fontWeight: FontWeight.w800),),
        leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),);
            }
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          // stream: channel_home.stream,
          builder: (context, snapshot) {

            var list;

            // (snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data != null) ?
            // list = json.decode(snapshot.data as String) : channel_home.stream;

            if(snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data != null) {
              list = json.decode(snapshot.data as String);
              if(selectedCoinDetail['coinSymbol'].toString() == list['s'].toString()) {
                //print('******');
                selectedCoinDetail['coinPrice'] = list['c'];
              }
            }
            else {
              channel_home.stream;
            }


            return Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.3),
                          borderRadius: BorderRadius.circular(2)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
                      child:  InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/showAllCoins", arguments: {'title': 'Select Coin', 'autoFocus': false, 'prevScreen': 'priceAlertScreen'});
                          // showDialog(context: context, builder: (BuildContext context) {
                          //   return StatefulBuilder(builder: ((context, setState) {
                          //     return allCoinsDialogBox(snapshot);
                          //   }));
                          // });
                        },
                        child: Row(
                          children: [
                            Image.network(selectedCoinDetail['coinImage'].toString(), height: width * 0.08, width: width * 0.08, fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: width * 0.083,
                                    width: width * 0.083,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey.shade400, width: 1)
                                    ),
                                    child: Center(
                                      child: Text(
                                          selectedCoinDetail['coinName'].toString() == null
                                              ? '-'
                                              : selectedCoinDetail['coinName'].toString()[0]),
                                    ),
                                  ),
                            ),
                            SizedBox(width: width * 0.03,),
                            Text(selectedCoinDetail['coinName'].toString(), style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 16, fontWeight: FontWeight.w600),),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 22,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03,),
                    Container(
                      width: width,
                      child: TextFormField(
                          controller: _userPrice,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Enter Price';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                          decoration: textFormFieldInputDecoration.copyWith(hintText: 'Enter Price', hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 16,),)
                      ),
                    ),
                    SizedBox(height: height * 0.03,),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                priceUP = 0;
                              });
                            },
                            child: Container(
                              //height: height * 0.03,
                              //width: width * 0.12,
                              decoration: BoxDecoration(
                                color: priceUP == 0 ? Colors.orange : Colors.white,
                                borderRadius: BorderRadius.circular(4)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.007),
                              child: Row(
                                children: [
                                  Text('Price Up', style: TextStyle(color: priceUP == 0 ? Colors.white : Colors.black, fontWeight: FontWeight.w600, fontSize: 14),),
                                  Icon(Icons.arrow_upward_sharp, size: 18, color: priceUP == 0 ? Colors.white : Colors.black),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02,),
                          InkWell(
                            onTap: () {
                              setState(() {
                                priceUP = 1;
                              });
                            },
                            child: Container(
                              //height: height * 0.03,
                              //width: width * 0.12,
                              decoration: BoxDecoration(
                                  color: priceUP == 0 ? Colors.white : Colors.orange,
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.007),
                              child: Row(
                                children: [
                                  Text('Price Low', style: TextStyle(color: priceUP == 0 ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 14),),
                                  Icon(Icons.arrow_downward_sharp, size: 18, color: priceUP == 0 ? Colors.black : Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.03,),
                    Text("Current Price:  " + selectedCoinDetail['coinPrice'].toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""), style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 14, fontWeight: FontWeight.w600),),
                    SizedBox(height: height * 0.03,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isProgress = true;
                        });

                        final formState = _formKey.currentState;
                        if (formState.validate()) {
                          formState.save();

                          addPriceAlert(snapshot);

                        } else {
                          setState(() {
                            isProgress = false;
                          });
                        }
                      },
                      child: Container(
                          height: height * 0.044,
                          width: width,
                          decoration: BoxDecoration(
                              color: ColorCollections.royalBlue,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child: Center(
                              child: isProgress
                                  ? Container(
                                height: height,
                                width: width,
                                margin: EdgeInsets.only(left:5,right:5),child: Center(child: CircularProgressIndicator(),),
                              )
                                  : Text('Create Price Alert', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),))),
                    ),
                    SizedBox(height: height * 0.04,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coin Name', style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 14, fontWeight: FontWeight.w600),),
                        Text('Alert Price', style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 14, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    SizedBox(height: height * 0.04,),
                    priceAlert.isEmpty
                        ? noPriceAlert()
                        : SizedBox(
                      //height: height * 0.4,
                      child: ListView.builder(
                          itemCount: priceAlert.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context ,index) {
                            return priceAlertItemCard(index);
                          }),
                    )
                  ],
                ),
              ),
            );

            // if(snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data != null) {
            //   //print('****** '+ selectedCoinDetail['coinSymbol'].toString() + ' == ' + list['s'].toString());
            //   if(selectedCoinDetail['coinSymbol'].toString() == list['s'].toString()) {
            //     //print('******');
            //     selectedCoinDetail['coinPrice'] = list['c'];
            //   }
            //   return Container(
            //     margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
            //     child: Form(
            //       key: _formKey,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Container(
            //             decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.grey, width: 0.3),
            //                 borderRadius: BorderRadius.circular(2)
            //             ),
            //             padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
            //             child:  InkWell(
            //               onTap: () {
            //                 showDialog(context: context, builder: (BuildContext context) {
            //                   return StatefulBuilder(builder: ((context, setState) {
            //                     return allCoinsDialogBox(snapshot);
            //                   }));
            //                 });
            //               },
            //               child: Row(
            //                 children: [
            //                   Image.network(selectedCoinDetail['coinImage'].toString(), height: width * 0.08, width: width * 0.08, fit: BoxFit.fill,),
            //                   SizedBox(width: width * 0.03,),
            //                   Text(selectedCoinDetail['coinName'].toString(), style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 16, fontWeight: FontWeight.w600),),
            //                   Spacer(),
            //                   Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).accentIconTheme.color, size: 22,)
            //                 ],
            //               ),
            //             ),
            //           ),
            //           SizedBox(height: height * 0.03,),
            //           Container(
            //             width: width,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.all(Radius.circular(1.0)),
            //                 border: Border.all(color: Colors.white70, width: 0.3)
            //             ),
            //             child: TextFormField(
            //               controller: _userPrice,
            //               validator: (input) {
            //                 if (input!.isEmpty) {
            //                   return 'Enter Price';
            //                 } else {
            //                   return null;
            //                 }
            //               },
            //               style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
            //               decoration: textFormFieldInputDecoration.copyWith(hintText: 'Enter Price', hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 16,),)
            //             ),
            //           ),
            //           SizedBox(height: height * 0.03,),
            //           Text("Current Price:  " + selectedCoinDetail['coinPrice'].toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""), style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 14, fontWeight: FontWeight.w600),),
            //           SizedBox(height: height * 0.03,),
            //           GestureDetector(
            //             onTap: () {
            //
            //               setState(() {
            //                 isProgress = true;
            //               });
            //
            //               var contain = priceAlert.where((element) => element.coinSymbol == selectedCoinDetail['coinSymbol']);
            //
            //
            //               final formState = _formKey.currentState;
            //               if (formState!.validate()) {
            //                 formState.save();
            //
            //                 if(_userPrice.text.isNotEmpty) {
            //                   if(double.parse(_userPrice.text.toString()) >= double.parse(selectedCoinDetail['coinPrice'].toString()) * 50.0) {
            //                     ToastMessage.showToast(context, 'Alert should not be greater than 50 times the current price', Colors.red);
            //                     setState(() {
            //                       isProgress = false;
            //                     });
            //                   }
            //                   else {
            //                     if(contain.isNotEmpty) {
            //                       for(var i=0; i<contain.length; i++) {
            //                         print('!!!!!!!!! ' + contain.length.toString() + '==' + selectedCoinDetail['coinName'].toString());
            //                         if(contain.elementAt(i).coinPrice == double.parse(_userPrice.text.toString())) {
            //                           print('@@##!!'  + contain.elementAt(i).coinName.toString());
            //                           ToastMessage.showToast(context, 'You can\'t create same price alert again', Colors.red);
            //                           setState(() {
            //                             isProgress = false;
            //                           });
            //                         }
            //                         else {
            //                           ///insert into local database
            //                           PriceAlertDatabase.db.insert(
            //                               int.parse(getTimestamp().toString()),
            //                               selectedCoinDetail['coinName'].toString(),
            //                               selectedCoinDetail['coinImage'].toString(),
            //                               selectedCoinDetail['coinSymbol'].toString(),
            //                               double.parse(_userPrice.text.toString()));
            //                           ///
            //
            //                           ///insert into list
            //                           priceAlert.add(PriceAlertModel(
            //                               id: int.parse(getTimestamp().toString()),
            //                               coinName: selectedCoinDetail['coinName'].toString(),
            //                               coinImage: selectedCoinDetail['coinImage'].toString(),
            //                               coinSymbol: selectedCoinDetail['coinSymbol'].toString(),
            //                               coinPrice: double.parse(_userPrice.text.toString())));
            //
            //                           ToastMessage.showToast(context, 'Price Alert Added Successfully', Colors.green);
            //
            //                           setState(() {
            //                             isProgress = false;
            //                           });
            //
            //                           checkPrice(snapshot, selectedCoinSymbol, selectedCoin);
            //
            //                         }
            //                       }
            //                     }
            //                     else {
            //                       ///insert into local database
            //                       PriceAlertDatabase.db.insert(
            //                           int.parse(getTimestamp().toString()),
            //                           selectedCoinDetail['coinName'].toString(),
            //                           selectedCoinDetail['coinImage'].toString(),
            //                           selectedCoinDetail['coinSymbol'].toString(),
            //                           double.parse(_userPrice.text.toString()));
            //                       ///
            //
            //                       ///insert into list
            //                       priceAlert.add(PriceAlertModel(
            //                           id: int.parse(getTimestamp().toString()),
            //                           coinName: selectedCoinDetail['coinName'].toString(),
            //                           coinImage: selectedCoinDetail['coinImage'].toString(),
            //                           coinSymbol: selectedCoinDetail['coinSymbol'].toString(),
            //                           coinPrice: double.parse(_userPrice.text.toString())));
            //
            //                       ToastMessage.showToast(context, 'Price Alert Added Successfully', Colors.green);
            //
            //                       setState(() {
            //                         isProgress = false;
            //                       });
            //
            //                       checkPrice(snapshot, selectedCoinSymbol, selectedCoin);
            //                     }
            //                   }
            //                 }
            //
            //               } else {
            //                 setState(() {
            //                   isProgress = false;
            //                 });
            //               }
            //             },
            //             child: Container(
            //                 height: height * 0.044,
            //                 width: width,
            //                 decoration: BoxDecoration(
            //                     color: ColorCollections.royalBlue,
            //                     borderRadius: BorderRadius.circular(6)
            //                 ),
            //                 child: Center(
            //                     child: isProgress
            //                         ? Container(
            //                            height: height,
            //                            width: width,
            //                            margin: EdgeInsets.only(left:5,right:5),child: Center(child: CustomProgessBar(
            //                            radius: 14,
            //                            gradientColors: [
            //                              Colors.amber.shade100,
            //                              Colors.amber.shade600,
            //                            ],
            //                            strokeWidth: 2.0,
            //                          ),),
            //                          )
            //                         : Text('Create Price Alert', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),))),
            //           ),
            //           SizedBox(height: height * 0.04,),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text('Coin Name', style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 14, fontWeight: FontWeight.w600),),
            //               Text('Alert Price', style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 14, fontWeight: FontWeight.w600),),
            //             ],
            //           ),
            //           SizedBox(height: height * 0.04,),
            //           priceAlert.isEmpty
            //               ? noPriceAlert()
            //               : SizedBox(
            //             //height: height * 0.4,
            //             child: ListView.builder(
            //                 itemCount: priceAlert.length,
            //                 shrinkWrap: true,
            //                 physics: NeverScrollableScrollPhysics(),
            //                 itemBuilder: (context ,index) {
            //                   return priceAlertItemCard(index);
            //                 }),
            //           )
            //         ],
            //       ),
            //     ),
            //   );
            // }
            // else {
            //   return Container(
            //     height: height,
            //     width: width,
            //     margin: EdgeInsets.only(left:5,right:5),
            //     child: Center(child: CustomProgessBar(
            //       radius: 18,
            //       gradientColors: [
            //         Colors.amber.shade100,
            //         Colors.amber.shade600,
            //       ],
            //       strokeWidth: 6.0,
            //     ),),
            //   );
            // }
          },
        ),
      ),
    );
  }

  /// Price Alert item card
  Widget priceAlertItemCard(index) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).secondaryHeaderColor  : Colors.white,
          boxShadow: [BoxShadow(
            blurRadius: 3,
            color: Theme.of(context).secondaryHeaderColor,
          )],
        ),
        margin: EdgeInsets.symmetric(vertical: height * 0.006),
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.014),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(priceAlert[index].coinImage, height: width * 0.085, width: width * 0.085, fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: width * 0.083,
                        width: width * 0.083,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400, width: 1)
                        ),
                        child: Center(
                          child: Text(
                              priceAlert[index].coinName == null
                                  ? '-'
                                  : priceAlert[index].coinName[0]),
                        ),
                      ),
                ),
                SizedBox(width: width * 0.014,),
                SizedBox(
                    width: width * 0.24,
                    child: Marquee(
                        autoRepeat: true, animationDuration: Duration(milliseconds: 3000), backDuration: Duration(milliseconds: 300),
                        child: Text(priceAlert[index].coinName, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1.color, fontWeight: FontWeight.w700),))),
                SizedBox(height: height * 0.005,),
              ],
            ),
            //Text(allCoinsList[selectedCurrency][index]['price'], textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.w700),),
            SizedBox(
              width: width * 0.22,
              child: Text(
                priceAlert[index].coinPrice.toString().replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyText1.color ,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  PriceAlertDatabase.db.delete(priceAlert[index].id);
                  priceAlert.removeWhere((element) => element.id == priceAlert[index].id);

                  int count = await PriceAlertDatabase.db.countPriceAlertsLength();

                  if(count <= 0) {
                    FlutterBackgroundService().sendData({"action": "stopService"},);
                    await initializeService();
                  }

                  ToastMessage.showToast(context, 'Price Alert Deleted ', Colors.cyan);
                },
                icon: Icon(Icons.delete_rounded, color: Theme.of(context).textTheme.bodyText1.color,))
          ],
        ),
      ),
    );
  }
  ///

  /// all coins dialog box
  Widget allCoinsDialogBox(snapshot) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.67,
      color: ColorCollections.appColor,
      child: SizedBox(
        height: height * 0.55,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: height * 0.026),
            //itemCount: allCoinsList[selectedCurrency].length ,
            itemCount: allCoinsList.length ,
            itemBuilder: (context, index) {
              return allCoinsItemCard(index, snapshot);
            }),
      ),
    );
  }
  ///

  /// no Price Alert
  Widget allCoinsItemCard(index, snapshot) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      // onLongPress: () {
      //   showDialog(context: context, builder: (BuildContext context) {
      //     return priceAlertDialogBox(index, snapshot);
      //   });
      // },
      onTap: () {
        setState(() {
          selectedCoinDetail['coinName'] = allCoinsList[index].coinName;
          selectedCoinDetail['coinSymbol'] = allCoinsList[index].coinSymbol;
          selectedCoinDetail['coinPrice'] = allCoinsList[index].coinPrice;
          selectedCoinDetail['coinImage'] = allCoinsList[index].coinImage;
        });
        Navigator.pop(context);
      },
      child: Container(
        color: ColorCollections.appColor,
        margin: EdgeInsets.symmetric(vertical: height * 0.006),
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.014),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //Image.network(allCoinsList[selectedCurrency][index]['image'], height: width * 0.085, width: width * 0.085, fit: BoxFit.fill,),
                Image.network(allCoinsList[index].coinImage, height: width * 0.085, width: width * 0.085, fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: width * 0.083,
                        width: width * 0.083,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400, width: 1)
                        ),
                        child: Center(
                          child: Text(
                              allCoinsList[index].coinName == null
                                  ? '-'
                                  : allCoinsList[index].coinName[0]),
                        ),
                      ),),
                SizedBox(width: width * 0.014,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: width * 0.24,
                        child: Marquee(
                            autoRepeat: true, animationDuration: Duration(milliseconds: 3000), backDuration: Duration(milliseconds: 300),
                            child: Text(allCoinsList[index].coinName, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1.color, fontWeight: FontWeight.w700),))),
                    SizedBox(height: height * 0.005,),
                    Text(allCoinsList[index].coinShortName, style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 10),)
                  ],
                ),
              ],
            ),
            //Text(allCoinsList[selectedCurrency][index]['price'], textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.w700),),
            SizedBox(
              width: width * 0.22,
              child: Text(
                allCoinsList[index].coinPrice.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyText1.color ,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: width * 0.14,
              color: allCoinsList[index].coinPercentage.toString().startsWith('-') ? ColorCollections.red : ColorCollections.lightGreen,
              padding: EdgeInsets.all(4),
              child: Center(child: Text(allCoinsList[index].coinPercentage + '%', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),)),
              //child: Text(percent + '%', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),),
            )
          ],
        ),
      ),
    );
  }
  ///

  /// no Price Alert
  Widget noPriceAlert() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: SizedBox(
          width: width * 0.6,
          child: Text('No price alert created. All your price alerts will show here.', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 14, fontWeight: FontWeight.w600),)),
    );
  }
///
}

class PriceAlertModel {
  int id;
  String coinName;
  String coinImage;
  String coinSymbol;
  double coinPrice;
  int isNotified;
  int priceUp;

  PriceAlertModel({
     this.id,
     this.coinName,
     this.coinImage,
     this.coinSymbol,
     this.coinPrice,
     this.isNotified,
     this.priceUp,
  });
}


