// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../config/constantClass.dart';

class Report extends StatefulWidget {
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  DateTime selectedfromDate = DateTime.now();
  String fromdate = "";
  DateTime selectedtoDate = DateTime.now().add(Duration(days: 7));
  String todate = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  _selecttoDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              onSecondary: Colors.white,
              primary: Color(0xff143047), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black,

              // body text color
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child,
        );
      },
      context: context,
      initialDate: selectedtoDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedtoDate)
      setState(() {
        selectedtoDate = selected;
      });
  }

  _selectfromDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              onSecondary: Colors.white,
              primary: Color(0xff143047), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black,

              // body text color
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child,
        );
      },
      context: context,
      initialDate: selectedfromDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedfromDate)
      setState(() {
        selectedfromDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: day == false ? Colors.black : Colors.white,
        title: Text("Download Trading Report",
            style: TextStyle(
              fontFamily: "IBM Plex Sans",
              color: day == false ? Colors.white : Colors.black,
            )),
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border:
                Border.all(color: day == false ? Colors.white : Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get your trading report on your email.",
                    style: TextStyle(
                        color: day == false ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poplins')),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  day == false ? Colors.white : Colors.black),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "From Date",
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poplins'),
                            ),
                            InkWell(
                              onTap: () {
                                _selectfromDate(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                    size: 20,
                                  ),
                                  Text(
                                    "  ${selectedfromDate.day}/${selectedfromDate.month}/${selectedfromDate.year}",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poplins'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  day == false ? Colors.white : Colors.black),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "To Date",
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poplins'),
                            ),
                            InkWell(
                              onTap: () {
                                _selecttoDate(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                    size: 20,
                                  ),
                                  Text(
                                    "  ${selectedtoDate.day}/${selectedtoDate.month}/${selectedtoDate.year}",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  '''The report will include:
1. Exchange Trades
2. P2P Trades
3. STF Trades
4. Current Coin Balance
5. Deposit and withdrawals
6. Ledger History
7. Airdrops and other distributions
                ''',
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color:Color(0xffc79509),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Request Trading Report",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
