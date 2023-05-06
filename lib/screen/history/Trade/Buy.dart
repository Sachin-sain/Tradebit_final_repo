import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../config/constantClass.dart';
import '../../intro/login.dart';
import '../../wallet/wallet.dart';

class buy extends StatefulWidget {
  @override
  State<buy> createState() => _buyState();
}

class _buyState extends State<buy> {
  @override
  String dropdownValue = 'Limit';
  var data;
  var data1;
  double _counter = 0.345666;
  double ADA = 0.56546;
  void _incrementCounter() {
    setState(() {
      _counter++;
      data = _counter.toStringAsExponential(1);
    });
  }

  void _incrementADA() {
    setState(() {
      ADA++;
      data1 = ADA.toStringAsExponential(1);
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
      data = _counter.toStringAsExponential(1);
    });
  }

  void _decrementADA() {
    setState(() {
      ADA--;
      data1 = ADA.toStringAsExponential(1);
    });
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
                  // IconButton(
                  //   padding: EdgeInsets.only(bottom: 5),
                  //   iconSize: 20,
                  //   color: Colors.grey,
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.circle,
                  //   ),
                  // ),
                  Padding(
                    padding:  EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        underline: SizedBox(),
                        // Step 3.
                        value: dropdownValue,
                        // Step 4.
                        items: <String>['Limit', 'Market', 'Stop Limit', 'Stop Market', 'OCO', 'trailing Spot'
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2),
                    iconSize: 20,
                    color: Colors.grey,
                    onPressed: () {
                      _decrementCounter();
                    },
                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText("$_counter", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2),
                    iconSize: 20,
                    color: Colors.grey,
                    onPressed: () {
                      _incrementCounter();
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                padding: EdgeInsets.only(right: 100),
                child: Text("=$data USD", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2),
                    iconSize: 20,
                    color: Colors.grey,
                    onPressed: () {
                      _decrementADA();
                    },
                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText("$ADA", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2),
                    iconSize: 20,
                    color: Colors.grey,
                    onPressed: () {
                      _incrementADA();
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
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
              alignment: Alignment.center,
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff313131),width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text("$ADA", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909)),),
            ),
            SizedBox(height: 5),
            Container(
                padding: EdgeInsets.only(right: 100),
                child: Text("= $data1 USD", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(right: 140),
                child: Text("Avail.", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
            ),
            SizedBox(height: 60,),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
              },
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0)
                  //boxShadow: Colors.white12,
                ),
                child: Center(
                  child: Text("buy BTC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "IBM Plex Sans", fontSize: 16.0,),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
