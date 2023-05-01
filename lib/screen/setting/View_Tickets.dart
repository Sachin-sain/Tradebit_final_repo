
// ignore_for_file: must_be_immutable, camel_case_types, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/constantClass.dart';

class View_Tickets extends StatefulWidget {
  String category_id;
  View_Tickets({this.category_id});

  @override
  State<View_Tickets> createState() => _View_TicketsState();
}

class _View_TicketsState extends State<View_Tickets> {

  List Comments=[];
  List Comments_data=[];
  bool submit=false;
  final TextEditingController commentcontroller = TextEditingController();
  bool fetched=false;
  @override
  void initState() {
    GetComments();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }
  Future<void> GetComments() async {
    final paramDic = {
      "": "",
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.get_Comments+widget.category_id, paramDic, "Get");
    var data = json.decode(response.body);
    print(data);
    if (data["status_code"] == '1') {
      setState(() {
        Comments.add(data['data']);
        Comments_data=Comments[0]['comments'];
        fetched=true;
      });
      print("L E N "+Comments_data.length.toString());
    }

    else {
      // ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  } Future<void> CreateComments() async {
    final paramDic = {
      "comment": commentcontroller.text.toString(),
      "ticket_id": widget.category_id.toString(),
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.create_Comments, paramDic, "Post");
    var data = json.decode(response.body);
    print(data);
    if (data["status_code"] == '1') {
      setState(() {
        submit=false;
        commentcontroller.text='';
      });
     Navigator.of(context).pop();

    }

    else {
      // ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ticket Info",style: TextStyle(fontFamily: "IBM Plex Sans")),backgroundColor: Color(0xff17394f),),
      backgroundColor: day==false?Color(0xff143047):Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child:fetched==true? Comments_data.length>0?Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                    width:40,
                    child: Text("Name:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),)),
                SizedBox(width: 5,),
                Text(Comments[0]['author_name'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans")),
              ],
            ), Row(
              children: [
                SizedBox(
                    width:40,child: Text("Status:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),)),
                SizedBox(width: 5,),
                Text(Comments[0]['status'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans")),
              ],
            ),
            SizedBox(height: 10,),
            Text("Comments",style: TextStyle(fontSize:14,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),),
            SizedBox(height: 15,),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: day==true?Colors.black12:Colors.white12,)
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                  itemCount: Comments_data.length,
                  itemBuilder:  (context, i){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: day==true?Colors.black12:Colors.white12,)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person_outline_rounded,color: day==false?Colors.white:Colors.black,size: 25,),
                                  SizedBox(width: 5,),
                                  Text(Comments[0]['author_name'].toString(),style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,)),

                                ],
                              ),
                              Row(
                                children: [
                                  Text(DateFormat("dd-MMM-yyyy hh:mm:ss a").format( DateTime.parse(Comments[0]['created_at'].toString()).toLocal()).toString(),style: TextStyle(fontFamily: "IBM Plex Sans",fontSize:12,color: day==false?Colors.white:Colors.black,)),
                                ],
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 25,right: 5,top: 5),
                            child: Text(Comments_data[i]['comment'].toString(),style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,)),
                          ),



                        ],
                      ),
                    ),
                  ),
                );
              })
            ),
            SizedBox(height: 15,),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: day==true?Colors.black12:Colors.white12,)
              ),
              child:  TextFormField(
                maxLines: 5,
                controller: commentcontroller,
                style: TextStyle(color: day==false?Colors.white:Colors.black),

                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please Enter First Name';
                  }

                  return null;
                },
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(10),

                  hintText: 'Leave a comment here.',
                  hintStyle: TextStyle(color:day==false?Colors.white54:Colors.black54 ),

                ),
              ),

            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: (){
              setState(() {
                submit=true;
                CreateComments();
              });

            },
              // color: Color(0xff17394f),
              child: submit==false?Text("Submit",style: TextStyle(fontFamily: 'IBM Plex Sans'),):CircularProgressIndicator(color: Colors.white),
            ),
          ],
        ):Center(child: Container(child: Text("No Comments",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),)):
        _loadingData(context),

    ),
    );
  }
}  Widget _loadingData(BuildContext context) {
  return Container(
    color:  Colors.transparent,
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 12,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx, i);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx, int i) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 15.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(ctx)
                                      .hintColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 12.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                                color: Theme
                                    .of(ctx)
                                    .hintColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 15.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(ctx)
                                .hintColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          height: 12.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              color: Theme
                                  .of(ctx)
                                  .hintColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 25.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                      color: Theme
                          .of(ctx)
                          .hintColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(color: Colors.white12),
            ),
          )
        ],
      ),
    ),
  );
}
