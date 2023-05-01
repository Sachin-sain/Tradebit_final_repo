
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';

class SelectCurrency extends StatefulWidget {

  @override
  _SelectCurrencyState createState() => _SelectCurrencyState();
}

class _SelectCurrencyState extends State<SelectCurrency> {
   bool value=false;




   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,

      appBar: AppBar(title: Text("Select Currency",style: TextStyle(
          fontFamily: "IBM Plex Sans",
          fontSize: 19.5,
          fontWeight: FontWeight.w700,color: Colors.white),),
      backgroundColor: day==false?Color(0xff143047):Colors.white,
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
        child: Column(
          children: [
            for(int i=0;i<CurrencyName.length;i++)
              Column(
                children: [
                  InkWell(
                    onTap: (){
                     setState(() {
                       CurrencyName[CurrencyName.keys.elementAt(i)]=true;
                       print(CurrencyName.keys.elementAt(i));
                       SharedPreferenceClass.SetSharedData("Currency",CurrencyName.keys.elementAt(i));
                       CurrencyName.forEach((key, value) {
                         if(key!=CurrencyName.keys.elementAt(i)){
                           CurrencyName[key]=false;
                         }});
                     });
                     Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(CurrencyName.keys.elementAt(i),style: TextStyle(color: Colors.black),)),
                          if(CurrencyName.keys.elementAt(i)=='USDT') Icon(Icons.check)else
                          Visibility(
                              visible: CurrencyName[CurrencyName.keys.elementAt(i)],
                              child: Icon(Icons.check,color: Colors.black,)),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.black38,)
                ],
              ),

          ],
        ),
      ),
          )    );




  }
}
