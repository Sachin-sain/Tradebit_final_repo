import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../config/constantClass.dart';

class price extends StatefulWidget {
  @override
  State<price> createState() => _priceState();
}

class _priceState extends State<price> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(var i = 0; i <= 10; i++)
          Container(
              padding: EdgeInsets.only(left: 20),
              child: AutoSizeText("0.38102", style: TextStyle(color: Color(0xffcf304a),fontWeight: FontWeight.w600),)
          ),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.only(left: 20),
            child: AutoSizeText("0.3832", style: TextStyle(color: Color(0xffcf304a), fontSize: 20,fontWeight: FontWeight.bold),)
        ),
        SizedBox(
          height: 10,
        ),
        for (var i = 0; i <= 7; i++)
          Container(
              padding: EdgeInsets.only(left: 23), child: AutoSizeText("0.38102", style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),)
          ),
      ],
    );
  }
}
