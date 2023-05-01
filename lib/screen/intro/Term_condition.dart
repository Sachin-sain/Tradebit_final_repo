import 'package:exchange/screen/intro/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Terms extends StatefulWidget {
  const Terms({Key key}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    padding: const EdgeInsets.only(left:0,right: 0,top: 5),
    itemCount: terms.length,
    itemBuilder: (BuildContext context, int index){
      return Padding(
        padding: const EdgeInsets.only(top: 20,right: 10,left: 15),
        child: Html(
          defaultTextStyle: TextStyle(color: Colors.black,fontFamily: "IBM Plex Sans"),
        data: terms[index]['content']),
      );
    }
    ));
  }
}
