
// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/constantClass.dart';
import 'WebviewScreen.dart';

class receipt_detail extends StatefulWidget {
  List Datafetch=[];
   receipt_detail({Key key,this.Datafetch}) : super(key: key);

  @override
  State<receipt_detail> createState() => _receipt_detailState();
}

class _receipt_detailState extends State<receipt_detail> {

  @override
  void initState() {
    print("soychh ? "+widget.Datafetch[0]["transfer_detail"].toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Receipt",style: TextStyle(fontFamily: "IBM Plex Sans")) ,backgroundColor: Color(0xff17394f)),
      backgroundColor: day==false?Colors.black:Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.Datafetch[0]["status"].toString()=="pending"?Icon(Icons.timer,size: 50,color: Colors.yellow,):widget.Datafetch[0]["status"].toString()=="rejected"?Icon(Icons.cancel,color: Colors.red,size: 50,):Icon(Icons.check_circle,size: 50,color: Colors.green,),
            SizedBox(height: 10,),
            widget.Datafetch[0]["status"].toString()=="pending"?Text("Withdrawal Request Submitted...",
                style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)):
            Text(widget.Datafetch[0]["status"].toString().toUpperCase(),
                style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
            SizedBox(height: 10,),
            Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10),)),
child: Padding(
  padding: const EdgeInsets.all(18.0),
  child:   Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Row(
      children: [

Icon(Icons.circle,color: day==false? Colors.white:Colors.black),
      SizedBox(width: 10,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Withdrawal Request Submitted",style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
          Text(DateFormat("dd/MM/yyyy, hh:mm:ss").format( DateTime.parse(widget.Datafetch[0]["created_at"].toString()).toLocal()),
              style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black)),
        ],
      ),
      ],
    ),
      Row(
        children: [

          Icon(Icons.circle,color: day==false? Colors.white:Colors.black),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("System Processing",style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
              Text("Why hasn't my withdrawal arrival?",style: TextStyle(fontSize: 15,color:Colors.amber)),
            ],
          ),
        ],
      ),

      Row(
        children: [

          Icon(Icons.circle,color: day==false? Colors.white:Colors.black),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Withdrawal Request ${widget.Datafetch[0]["status"].toString().toUpperCase()}",style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
              Text(DateFormat("dd/MM/yyyy, hh:mm:ss").format( DateTime.parse(widget.Datafetch[0]["updated_at"].toString()).toLocal()),
                  style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black)),
            ],
          ),
        ],
      ),



  ]),
),
            ),
            SizedBox(height: 10,),
            Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10),)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child:   Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Amount : ",
                             style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                         Text(widget.Datafetch[0]["amount"].toString() + " " +widget.Datafetch[0]["currency"].toString(),
                             style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                       ],),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Network : ",
                              style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                          Text(widget.Datafetch[0]["chain_type"].toString() ,
                              style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Withdrawal : ",
                              style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(widget.Datafetch[0]["to_address"].toString() ,
                                style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                          ),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Address : ",
                              style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(widget.Datafetch[0]["from_address"].toString() ,
                                style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                          ),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Source : ",
                              style: TextStyle(fontSize: 15,color: day==false? Colors.white:Colors.black,fontWeight: FontWeight.w800)),
                          InkWell(
                            onTap: (){
                              if(widget.Datafetch[0]["transfer_detail"]!=null){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebviewScreen(name: widget.Datafetch[0]["currency"].toString().toLowerCase(),url:widget.Datafetch[0]["transfer_detail"]["transactionHash"].toString() ,)));
                              }

                            },
                            child: Text(widget.Datafetch[0]["transfer_detail"]!=null?"View In BlockChain Explorer":"----",style: TextStyle(fontSize: 15,color: Colors.blue)),
                          ),

                        ],),

                    ]),
              ),
            )
      ]),
    ),);
  }
}
