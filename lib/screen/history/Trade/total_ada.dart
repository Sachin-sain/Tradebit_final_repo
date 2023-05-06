import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../config/constantClass.dart';

class ada extends StatefulWidget {
  @override
  State<ada> createState() => _adaState();
}

class _adaState extends State<ada> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        for (var i = 0; i <= 10; i++)
          Container(
              padding: EdgeInsets.only(left: 20),
              child: AutoSizeText("0.3810215", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909)))
          ),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.only(left: 20,right: 5),
            child: AutoSizeText("= 0.38", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909), fontSize: 16,fontWeight: FontWeight.bold,))
        ),

        SizedBox(
          height: 10,
        ),
        for (var i = 0; i <= 7; i++)
          Container(
              padding: EdgeInsets.only(left: 23,right: 5), child: AutoSizeText("0.3810219", style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),),)
          ),
      ],
    );
  }
}
