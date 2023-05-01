// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';

import '../../config/APIClasses.dart';

class RewardCentre extends StatefulWidget {


  @override
  State<RewardCentre> createState() => _RewardCentreState();
}

class _RewardCentreState extends State<RewardCentre> {
  int page=1;

  List referreldata=[];
  String total;
  @override
  void initState() {
    referral_link(page.toString());

    super.initState();
  }


  Future<void> referral_link(String value) async {
    final paramDic = {
      "page":value.toString(),
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.referrallink, paramDic, "Get");
    var data = json.decode(response.body);
    print(response);
    referreldata.clear();
    if(data["status_code"]=='1'){
      referreldata=data["data"];
      total=data['total'];
      print("d a t a  "+referreldata.toString());

    }
    else{
      setState(() {
        referreldata.clear();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reward Centre",style: TextStyle(fontFamily: "IBM Plex Sans"),),backgroundColor: Color(0xff17394f),),
    backgroundColor: day==false?Colors.black:Colors.white,
      body:   Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Container(padding: EdgeInsets.only(left: 5),
              // color: Colors.blueGrey[900],
                                 child:
                                HeaderList(),),
            Divider(color:day==false?Colors.white:Color(0xff17394f),height: 15,thickness: 1.0,),
            Container(
              padding: EdgeInsets.only(left: 5),
              child: referreldata.length>0? ListView.builder(

                shrinkWrap: true,
                primary: false,
                itemCount: referreldata.length,
                itemBuilder: (ctx, i) {
                  return loadingCardData(ctx, i);
                },
              ):Center(child: Container(child:Text("No Data",style: TextStyle(color:day==false?Colors.white:Color(0xff17394f),fontFamily: "IBM Plex Sans" ),))), ),
          ],
        ),
      ),

    );
  }

  HeaderList() {
    return   Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(

            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Username",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Email",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Direct Sponser ID",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans")),
              ),
              Container(

                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Status",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
              Container(

                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Created at",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
            ],
          ),
        ),

      ],
    );
  }
  Widget loadingCardData(BuildContext ctx, int i) {
    return   Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:  Row(

            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Username",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Email",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Direct Sponser ID",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans")),
              ),
              Container(

                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Status",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
              Container(

                width: MediaQuery.of(context).size.width * 0.20,
                child: Text("Created at",style: TextStyle(fontSize: 12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),
              ),
            ],
          ),
        ),

        Divider(color:day==false?Colors.white:Color(0xff17394f),height: 15,thickness: 1.0,),
      ],
    );

  }


}
