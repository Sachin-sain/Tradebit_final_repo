import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../config/constantClass.dart';

class Comingsoon extends StatefulWidget {
  @override
  _ComingsoonState createState() => _ComingsoonState();
}

class _ComingsoonState extends State<Comingsoon> {
  var _colorizeColors = [
    Colors.white,
    Colors.blue,
    Colors.black,
    Colors.green,
  ];
  var _colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: Stack(children: [
          // Container(
          // height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   child: day==false?Image.asset('assets/image/background.png',fit: BoxFit.fill,)
          //       :Image.asset('assets/image/plainwhite.png',fit: BoxFit.fill,)),

          Center(
            child: Card(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText("COMING SOON",
                        textStyle: _colorizeTextStyle,
                        colors: _colorizeColors,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
