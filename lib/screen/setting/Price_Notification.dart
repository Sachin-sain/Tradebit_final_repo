import 'package:custom_switch/custom_switch.dart';
import 'package:exchange/screen/setting/Foreground_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import '../../config/SharedPreferenceClass.dart';
import '../../config/constantClass.dart';

class PriceNotification extends StatefulWidget {
  @override
  State<PriceNotification> createState() => _PriceNotificationState();
}

class _PriceNotificationState extends State<PriceNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: day == false ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: day == false ? Colors.black : Colors.white,
          title: Text("Notification"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 15, right: 15),
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Price Alert",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: CustomSwitch(
                              value: alert,
                              activeColor: Color(0xff17394f),
                              onChanged: (value) {
                                print("VALUE : $value");
                                setState(() async {
                                  alert = value;
                                  SharedPreferenceClass.SetSharedData(
                                      "alert", alert.toString());
                                  if (alert == true) {
                                    FlutterBackgroundService().sendData(
                                      {"action": "setAsForeground"},
                                    );
                                    WidgetsFlutterBinding.ensureInitialized();
                                    await initializeService();
                                  } else {
                                    FlutterBackgroundService().sendData(
                                      {"action": "stopService"},
                                    );
                                    await initializeService();
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: day == false ? Colors.white : Color(0xff17394f),
                      height: 15,
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Notification",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: CustomSwitch(
                              value: notify,
                              activeColor: Color(0xff17394f),
                              onChanged: (value) {
                                print("VALUE : $value");
                                setState(() {
                                  notify = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )))));
  }
}
