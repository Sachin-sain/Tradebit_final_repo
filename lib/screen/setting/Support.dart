// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/setting/PreviousTicket.dart';
import 'package:exchange/screen/setting/contactus.dart';
import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  bool support = true;

  bool prevticket = false;
  String category;
  List<String> Category = [];
  List<String> tickets = [];
  bool contact = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: day == false ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: day == false ? Colors.black : Colors.white,
          title: Text("Ticket Support",
              style: TextStyle(
                fontFamily: "IBM Plex Sans",
                color: day == false ? Colors.white : Colors.black,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                  color: day == false ? Colors.white54 : Colors.black54),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("You control your data, and we respect that.",
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans'),
                    textAlign: TextAlign.center,),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(' Please reach out to us. Our team will be happy to help you out.',
                      style: TextStyle(
                          color: day == false ? Colors.white : Colors.black,
                          fontFamily: 'Poplins'),
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Color(0xffc79509),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      new Contactus()));
                            });
                          },
                          // color: Color(0xff17394f),
                          child: Text(
                            "Create Ticket",
                            style: TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xffc79509),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      new PreviousTicket()));
                            });
                          },
                          // color: Color(0xff17394f),
                          child: Text(
                            "View Previous Tickets",
                            style: TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
