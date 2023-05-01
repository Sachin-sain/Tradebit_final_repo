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

///
/// Page View Model for on boarding
///


class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      new PageViewModel(
          pageColor: Color(0xff16152c),
          iconColor: Colors.white,
          bubbleBackgroundColor: Colors.white,
          mainImage: Image.asset(
            'assets/ilustration/boarding1.png',
            fit: BoxFit.fill,
          )),
      new PageViewModel(
          pageColor: Color(0xff16152c),
          iconColor: Colors.white,
          bubbleBackgroundColor: Colors.white,
          mainImage: Image.asset(
            'assets/ilustration/boarding2.png',
            fit: BoxFit.fill,
          )),
      new PageViewModel(
          pageColor: Color(0xff16152c),
          iconColor: Colors.white,
          bubbleBackgroundColor: Colors.white,
          mainImage: Image.asset(
            'assets/ilustration/boarding3.png',fit: BoxFit.fill,

          )),
    ];
    return Container(
        height: MediaQuery.of(context).size.height,
        child: IntroViewsFlutter(
          pages,
          pageButtonsColor: Colors.transparent,
          skipText: Text("SKIP", style: txtStyle.descriptionStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.0),
          ),
          doneText: Text("DONE", style: txtStyle.descriptionStyle.copyWith(color:Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.0),
          ),
          onTapDoneButton: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>bottomNavBar(index: 0,)),
            );
            // Navigator.of(context).pushReplacement(PageRouteBuilder(
            //     pageBuilder: (_, __, ___) => new login(themeBloc: _themeBloc))

            // );
          },
        ),
      );

  }
}
