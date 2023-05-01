import 'dart:ffi';
import 'package:flutter/material.dart';
import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/constantClass.dart';

class login_confirm extends StatelessWidget {
  final String Token;
  login_confirm({Key key, @required this.Token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: day == false ? Colors.black : Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: day == false ? Colors.black : Color(0xfff6f6f6),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confirm Authorization",
                style: TextStyle(
                    color: day == false ? Colors.white : Color(0xff0a0909),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  "Account login from an unknown device . Please confirm that it is you.",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: day == false ? Color(0xff181818) : Color(0xffffffff),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("IP Address ",style: TextStyle(color: Colors.grey, fontSize: 14)),
                        //     Text("1.68.5694", style: TextStyle(
                        //         color: day == false ? Colors.white : Color(0xff0a0909),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold))
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("Location ",style: TextStyle(color: Colors.grey, fontSize: 14)),
                        //     Text("Chandigarh", style: TextStyle(
                        //         color: day == false ? Colors.white : Color(0xff0a0909),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold))
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("Device ",style: TextStyle(color: Colors.grey, fontSize: 14)),
                        //     Text("Windows v111.0.0", style: TextStyle(
                        //         color: day == false ? Colors.white : Color(0xff0a0909),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold))
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 450,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0xffc79509),
                    borderRadius: BorderRadius.circular(5.0)),
                child: GestureDetector(
                    onTap: () {
                      qr_code(Token);
                    },
                    child: Center(
                      child: Text(
                        "Authorize",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 150),
                  child: TextButton(
                      onPressed: null,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Color(
                              0xffc79509,
                            ),
                            fontSize: 20),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Void> qr_code(qrtoken) async {
  final paramDic = {
    'token': qrtoken.toString()

  };
  print(qrtoken);
  print(paramDic.toString());
  var response = await LBMAPIMainClass(APIClasses.LMB_qr, paramDic, "Post");
  print(response);
}

