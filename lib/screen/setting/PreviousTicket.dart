// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/constantClass.dart';
import 'View_Tickets.dart';

class PreviousTicket extends StatefulWidget {
  const PreviousTicket({Key key}) : super(key: key);

  @override
  _PreviousTicketState createState() => _PreviousTicketState();
}

class _PreviousTicketState extends State<PreviousTicket> {
    List tickets=[];
    bool fetched=false;
    @override
    void initState() {
      GetTickets();
      // ignore: todo
      // TODO: implement initState
      super.initState();
    }

    Future<void> GetTickets() async {
      final paramDic = {
        "": "",
      };
      print(paramDic);
      var response;
      response = await LBMAPIMainClass(APIClasses.ticket_view, paramDic, "Get");
      var data = json.decode(response.body);
      print(response);
      if (data["status_code"] == '1') {

       setState(() {
         tickets=data['data'];
         fetched=true;
       });
      print(tickets.toString());
      }

        else {
        // ToastShowClass.toastShow(context, data["message"], Colors.red);
      }
    }
    // Future<void> viewticket() async {
    //   final paramDic = {
    //    "":"",
    //
    //   };
    //   print(paramDic.toString());
    //   final uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.ticket_view);
    //   print(uri.toString());
    //
    //   HttpClient httpClient = HttpClient();
    //
    //   HttpClientRequest request = await httpClient.getUrl(uri);
    //   request.headers.set('content-type', 'application/json');
    //   request.headers.set('Authorization', 'Bearer '+await SharedPreferenceClass.GetSharedData('token'));
    //
    //   request.add(utf8.encode(json.encode(paramDic)));
    //   HttpClientResponse response = await request.close();
    //   // var response = await LBMAPIMainClass(APIClasses.LBM_register, paramDic, "Post");
    //   String reply = await response.transform(utf8.decoder).join();
    //   var data = jsonDecode(reply);
    //   print(data);
    //
    //   if(data["status_code"]=='1'){
    //
    //     tickets=data['data'];
    //     print("view "+tickets.toString());
    //
    //   }
    //
    //   else{
    //
    //   }
    //
    // }


    @override
  Widget build(BuildContext context) {
      print(tickets.length.toString());
    return Scaffold(
              appBar: AppBar(
                backgroundColor: day==false?Colors.black:Colors.white,
                title: Text("View Previous Ticket",style: TextStyle(fontFamily: "IBM Plex Sans",color: day == false ? Colors.white : Colors.black,)),),
                backgroundColor: day==false?Colors.black:Colors.white,
      body: fetched==true?tickets.length>0?
    ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, i) {



          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new View_Tickets(category_id: tickets[i]['category_id'],)));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: day==true?Colors.black12:Colors.white12,)
                ),
                // color: day==true?Colors.black12:Colors.white10,
                // height: 120,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: [
                          Row(
                            children: [
                              Text("Ticket Type:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold),),
                              SizedBox(width: 5,),
                              Text(tickets[i]['content'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,)),

                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Status:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),),
                              SizedBox(width: 5,),
                              Text(tickets[i]['status'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans")),
                            ],
                          ),
                             ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Row(

                            children: [
                              Text("Email:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),),
                              SizedBox(width: 5,),
                              Text(tickets[i]['author_email'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans" )),
                            ],
                          ),

                          Row(
                            children: [
                              Text("Action:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),),
                              SizedBox(width: 5,),
                             Icon(Icons.remove_red_eye,color: day==false?Colors.white:Colors.black,size: 20,)
                             // Text(tickets[i]['author_email'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans" )),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Name:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),),
                          SizedBox(width: 5,),
                          Text(tickets[i]['author_name'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans")),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Row(
                            children: [

                              Text("Title:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold),),
                              SizedBox(width: 5,),
                              Text(tickets[i]['title'],style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,)),
                            ],
                          )

                        ],
                      ),
                      Row(
                        children: [
                          Text("Ticket Generated:",style: TextStyle(fontSize:12,color: day==false?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans"),),
                          SizedBox(width: 5,),
                          Text(DateFormat("dd-MMM-yyyy hh:mm:ss a").format( DateTime.parse(tickets[i]['created_at'].toString()).toLocal()).toString(),style: TextStyle(fontFamily: "IBM Plex Sans",fontSize:12,color: day==false?Colors.white:Colors.black,)),
                        ],
                      ),




                    ],
                  ),
                ),),
            ),
          );
        },)
         :Center(child: Container(child: Text("No Tickets Generated",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans"),),))  :_loadingData(context),);


  }
    Widget _loadingData(BuildContext context) {
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

}
