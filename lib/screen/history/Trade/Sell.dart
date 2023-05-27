import 'dart:async';
import 'dart:convert';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/library/intro_views_flutter-2.4.0/lib/Models/buy_btc_response.dart';
import 'package:flutter/material.dart';
import '../../../config/constantClass.dart';


class Sell extends StatefulWidget {
 final String currencyneed;
 final String pairCurrency;
 final String pair;
 final String price;
 bool firstTime;

  Sell({Key key, this.currencyneed, this.pairCurrency, this.pair,this.firstTime, this.price}) : super(key: key);
  @override
  State<Sell> createState() => SellState();
}

class SellState extends State<Sell> {
  List currency = [];
  List btclist = [];
  String price1;
  bool button = false;
  String dropdownValue = 'limit';
  String btc;
  var usdt = 0.00;
  double total = 0;
  TextEditingController controller = TextEditingController();
  TextEditingController controllerBtc = TextEditingController();

  void _incrementCounter() {
    setState(() {
      double currentValue = double.parse(controller.text != null ? controller.text : 0);
      setState(() {
        currentValue++;
        controller.text = (currentValue)
            .toString(); // incrementing value
        usdt =  (currentValue + 0.001);
      });
    });
  }

  void _incrementBTCCounter() {
    setState(() {
      double currentValue = double.parse(controllerBtc.text != null ? controllerBtc.text : 0);
      currentValue++;
      controllerBtc.text = (currentValue)
          .toString(); // incrementing value
      sum();
    });
  }

  void _decrementCounter() {
    setState(() {
      double currentValue = double.parse(controller.text != null ? controller.text : 0);
      currentValue--;
      controller.text =
          (currentValue > 0 ? currentValue : 0)
              .toString();
      usdt =   (currentValue > 0  ? currentValue + 0.001 : 0);
    });
  }

  void _decrementBTCCounter() {
    setState(() {
      double currentValue = double.parse(controllerBtc.text != null ? controllerBtc.text : 0);
      currentValue--;
      controllerBtc.text =
          (currentValue > 0 ? currentValue : 0)
              .toString();
      sum();
    });
  }

  @override
  void initState() {
    getData();
    controllerBtc.text = '0';
    controller.text = widget.firstTime ? price1 : double.parse(widget.price).toStringAsFixed(3);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        child: Column(
          children: [
            Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff313131),width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        underline: SizedBox(),
                        // Step 3.
                        value: dropdownValue,
                        // Step 4.
                        items: <String>['limit', 'market',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 13,color: Colors.grey),
                            ),
                          );
                        }).toList(),
                        // Step 5.
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff313131),width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  SizedBox(width: 5,),
                  GestureDetector(
                      onTap: () {
                        _incrementCounter();
                      },
                      child: Icon(Icons.add,color: Colors.grey,size: 18,)),
                  SizedBox(width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),fontSize: 14,fontWeight: FontWeight.bold,),
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: (){
                        _decrementCounter();
                      },
                      child: Icon(Icons.remove,color: Colors.grey,size: 18,)),
                  SizedBox(width: 5,)
                ],
              ),
            ),  SizedBox(
              height: 5,
            ),
            Container(
                height: 15,
                padding: EdgeInsets.only(right: 100),
                child: Text("= ${usdt} ", style: TextStyle(
                  fontSize: 12,
                  color: day == false ? Colors.white : Color(0xff0a0909),),)
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff313131),width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  SizedBox(width: 5,),
                  GestureDetector(
                      onTap: () {
                        _incrementBTCCounter();
                      },
                      child: Icon(Icons.add,color: Colors.grey,size: 18,)),
                  SizedBox(width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),fontSize: 14,fontWeight: FontWeight.bold,),
                      controller: controllerBtc,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: (){
                        _decrementBTCCounter();
                      },
                      child: Icon(Icons.remove,color: Colors.grey,size: 18,)),
                  SizedBox(width: 5,)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 5),
                  height: 20,
                  width: 35,
                  decoration: BoxDecoration(
                    color:  day == false ?Color(0xff313131) : Colors.grey,
                    border: Border.all(color: Color(0xff313131),width: 2),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text("25%", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909), fontSize: 12),),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 35,
                  decoration: BoxDecoration(
                    color:  day == false ?Color(0xff313131) : Colors.grey,
                    border: Border.all(color: Color(0xff313131),width: 2),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text("50%", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909), fontSize: 12),),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 35,
                  decoration: BoxDecoration(
                    color:  day == false ?Color(0xff313131) : Colors.grey,
                    border: Border.all(color: Color(0xff313131),width: 2),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    "75%", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909), fontSize: 12),),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 5),
                  height: 20,
                  width: 35,
                  decoration: BoxDecoration(
                    color:  day == false ?Color(0xff313131) : Colors.grey,
                    border: Border.all(color: Color(0xff313131),width: 2),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    "100%", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909), fontSize: 12),),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff313131),width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(text: total.toStringAsFixed(2)),
                textAlign: TextAlign.center,
                cursorWidth: 0,
                cursorHeight: 0,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 12),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,

                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
                height: 1,
                padding: EdgeInsets.only(right: 100),
                child: Text("=USD", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(right: 140),
                child: Text("Avail.", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  button ?  null : sellBtc();
                });
              },
              child: Container(
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0)
                  //boxShadow: Colors.white12,
                ),
                child: Center(
                  child: Text("Sell BTC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "IBM Plex Sans", fontSize: 16.0,),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  getData() async {
    final Map<String, String> paramDic = {
      "": "",
    };
    try {
      final response = await APIMainClassbinance(APIClasses.currencyget, paramDic, "Get");
      if (response?.statusCode == 200) {
        print(response.body);
        var data = json.decode(response.body);
        setState(() {
          currency.add(data['data']['USDT'][0]['price']);
          String k = currency[0].toString();
          price1 = widget.firstTime ? k : widget.price;
          controller.text = double.parse(price1).toStringAsFixed(2);
          usdt = double.parse(price1) + 0.001;
        });
      } else {
        throw Exception('Unable to fetch data ');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  sellBtc() async {
    setState(() {
      button = true;
    });
    try {
      final request = await APIMainClassbinance(
          APIClasses.buy,
          <String, String>{
            "order_type": "sell",
            "type": dropdownValue,
            "currency": widget.currencyneed,
            "with_currency": widget.pairCurrency,
            "stop_price": 0.toString(),
            "at_price": controller.text,
            "quantity": controllerBtc.text,
            "total": total.toString(),
          },
          "Post");
      if (request?.statusCode == 200) {
        String message = request.body;
        setState(() {
          PlaceOrderResponse res = placeOrderResponseFromJson(message);
          ToastClass.ToastShow(res.message,color: Colors.white);
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              button = false;
            });
          });
        });
      } else {
        button = false;
        throw Exception('Unable to fetch data ');
      }
    } catch (e) {
      button = false;
      throw Exception('Failed to fetch data: $e');
    }
  }
  double sum() {
    setState(() {
      total = double.parse(controller.text) * double.parse(controllerBtc.text);
      return total.toStringAsFixed(2);
    });
  }
}

