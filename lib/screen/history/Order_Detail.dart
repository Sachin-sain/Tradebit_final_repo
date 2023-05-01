
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/constantClass.dart';

class OrderDetail extends StatefulWidget {
  List orderdetail=[];
  OrderDetail({this.orderdetail});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  @override
  void initState() {
    print("JHSDACXJNBC  "+widget.orderdetail[0]["data"][0]["commission"].toString());

    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Order Detail",style: TextStyle(fontFamily: "IBM Plex Sans"),),backgroundColor: Color(0xff17394f),),
    backgroundColor:day==false?Colors.black:Colors.white,

    body: Column(

      children: [
        Container(
          color: widget.orderdetail[0]['order_data']['order_type']=="buy"?Colors.green.shade100:Colors.red.shade100,
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.orderdetail[0]['order_data']['currency'].toString()+' / '+widget.orderdetail[0]['order_data']['with_currency'].toString(),style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans",fontSize: 14)),
                Text(widget.orderdetail[0]['order_data']['order_type'].toString().toUpperCase(),style: TextStyle(color:widget.orderdetail[0]['order_data']['order_type']=="buy"?Colors.green:Colors.red,fontSize: 14,fontFamily: "IBM Plex Sans",fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 5,top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Type",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
                  Text(widget.orderdetail[0]['order_data']['type'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Placed on",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
                  Text(DateFormat("dd MMM, hh:mm").format( DateTime.parse(widget.orderdetail[0]['order_data']['created_at'].toString()).toLocal()).toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filled / Amount",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
                  Text(widget.orderdetail[0]['order_data']['quantity'].toString()+" "+widget.orderdetail[0]['order_data']['currency'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Average Price",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
                  Text("\$ "+widget.orderdetail[0]['order_data']['at_price'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),),

                ],
              ),
              SizedBox(height: 10,),
              Divider(color: day==false?Colors.white54:Colors.black54,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
                  Text("\$ "+widget.orderdetail[0]['order_data']['total'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",fontWeight: FontWeight.bold),),

                ],
              ),
              Divider(color: day==false?Colors.white54:Colors.black54,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Fee",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
              //     Text(widget.orderdetail[0]['order_data']['commission_currency']==null?"0 "+widget.orderdetail[0]['order_data']
              //     ['with_currency'].toString():widget.orderdetail[0]['commission_currency'].toString()+" "+widget.orderdetail[0]['with_currency'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),),
              //
              //   ],
              // ),
              SizedBox(height: 30,),
              Text("Trade Details",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.25,
                      child: Text("Date / Time",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),)),
                  Container(
                      width: MediaQuery.of(context).size.width*0.25,
                      child: Text("Filled",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),)),
                 // Spacer(),

                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    child:Text("Price",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),
                  ),
                  Text("Comission",style: TextStyle(color:day==false?Colors.white54:Colors.black54,fontSize: 14,fontFamily: "IBM Plex Sans",),),

                ],
              ),Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.25,
                      child: Text(DateFormat("dd MMM, hh:mm").format( DateTime.parse(widget.orderdetail[0]['order_data']['created_at'].toString()).toLocal()).toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),)),
                  Container(
                      width: MediaQuery.of(context).size.width*0.25,
                      child: Text(widget.orderdetail[0]['order_data']['quantity'].toString()+" "+widget.orderdetail[0]['order_data']['with_currency'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),)),
                  // Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                      child: Text(widget.orderdetail[0]["data"][0]['at_price'].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),)),
Expanded(
                      child: Text(widget.orderdetail[0]["data"][0]["commission"].toString(),style: TextStyle(color:day==false?Colors.white:Colors.black,fontSize: 14,fontFamily: "IBM Plex Sans",),)),

                ],
              ),


            ],
          ),
        )
      ],
    ),
    );

  }

}
