// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../config/SharedPreferenceClass.dart';

class Notificationpage extends StatefulWidget {
  @override
  _Notificationpage createState() => _Notificationpage();
}

List notificationdata = [];

Future<void> notification(String value) async {
  final uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.notification);
  print(uri.toString());

  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.getUrl(uri);
  request.headers.set('content-type', 'application/json');
  request.headers.set('Authorization',
      'Bearer ' + await SharedPreferenceClass.GetSharedData('token'));
  // request.add(utf8.encode(json.encode(paramDic)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  var data = jsonDecode(reply);
  print(data.toString());

  if (data["status_code"] == '1') {
    data["data"]["notifications"] == null
        ? notificationdata.clear()
        : notificationdata = data["data"]["notifications"];
    notification_count = data['data']['totalcount'];
    //  ToastShowClass.toastShow(context, data["message"], Colors.blue);
  } else {
    notificationdata.clear();
    // ToastShowClass.toastShow(context,data["message"], Colors.red);
  }
}

class _Notificationpage extends State<Notificationpage> {
  TextEditingController referralcode = new TextEditingController();
  TextEditingController referrallink = new TextEditingController();

  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  int page = 1;

  @override
  void initState() {
    notification(page.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeys,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notification",
              style: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  color: day == false ? Colors.white : Colors.black)),
          backgroundColor: day == false ? Colors.black : Colors.white,
        ),
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
            child: Container(
              child: Column(
                children: <Widget>[
                  // Divider(color:day==false?Colors.white:Color(0xff17394f),height: 15,thickness: 1.0,),
                  Container(
                    child: notificationdata.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: notificationdata.length,
                            itemBuilder: (ctx, i) {
                              return loadingCardData(ctx, i);
                            },
                          )
                        : Container(
                            child: Center(
                                child: Text(
                            "No Data",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                          ))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingCardData(BuildContext ctx, int i) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            color: notificationdata[0]["read_status"] == "notreaded"
                ? Color(0xff17394f).withOpacity(0.5)
                : Colors.transparent,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(Icons.notifications,
                      color: day == false ? Colors.white : Color(0xff17394f)),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Html(
                            data: notificationdata[i]["content"],
                            defaultTextStyle: TextStyle(
                                fontSize: 12,
                                color: day == false
                                    ? Colors.white
                                    : Color(0xff17394f),
                                fontWeight: notificationdata[0]
                                            ["read_status"] ==
                                        "notreaded"
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          )
                          //Text(notificationdata[i]["content"],style: TextStyle(fontSize: 12,color: day==false?Colors.white:Color(0xff17394f),fontWeight:notificationdata[0]["read_status"]=="notreaded"? FontWeight.bold:FontWeight.normal),)
                          ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      color: day == false ? Colors.white : Color(0xff17394f),
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            notificationdata[0]["read_status"] == "notreaded"
                                ? "Not Read"
                                : "Read",
                            style: TextStyle(
                                color: day == false
                                    ? Color(0xff17394f)
                                    : Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: day == false ? Colors.white : Color(0xff17394f),
          height: 15,
          thickness: 1.0,
        ),
      ],
    );
  }

  HeaderList() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                "Username",
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                "Email",
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Text("Direct Sponser ID", style: TextStyle(fontSize: 12)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                "Status",
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                "Created at",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
