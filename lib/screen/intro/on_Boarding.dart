// ignore_for_file: camel_case_types

import 'package:exchange/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:exchange/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:exchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:exchange/component/style.dart';
class onBoarding extends StatefulWidget {

  @override
  _onBoardingState createState() => _onBoardingState();
}
class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      new PageViewModel(
          pageColor:Colors.black,
          iconColor: Colors.black,
          bubbleBackgroundColor: Colors.black,
          mainImage: Padding(
            padding: const EdgeInsets.only(bottom: 300.0),
            child: Image.asset(
              'assets/ilustration/boarding1.png',
            ),
          )),
      new PageViewModel(
          pageColor:Colors.black,
          iconColor: Colors.black,
          bubbleBackgroundColor: Colors.black,
          mainImage: Padding(
            padding: const EdgeInsets.only(bottom: 300),
            child: Image.asset(
              'assets/ilustration/boarding2.png',

            ),
          )),
      new PageViewModel(
          pageColor:Colors.black,
          iconColor: Colors.black,
          bubbleBackgroundColor: Colors.black,
          mainImage: Padding(
            padding: const EdgeInsets.only(bottom: 300),
            child: Image.asset(
              'assets/ilustration/boarding3.png',
            ),
          )),
    ];

    return Scaffold(
   body:Container(
        alignment: Alignment.topCenter,
          child: IntroViewsFlutter(
            pages,
            pageButtonsColor: Colors.transparent,
            skipText: GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>bottomNavBar(index: 0,)),
                );
              },
              child: Text("SKIP", style: txtStyle.descriptionStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.0),
              ),
            ),
            doneText: Text("DONE", style: txtStyle.descriptionStyle.copyWith(color:Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.0),
            ),
            onTapDoneButton: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>bottomNavBar(index: 0,)),
              );
            },
          ),
        ),
    );

  }
}
