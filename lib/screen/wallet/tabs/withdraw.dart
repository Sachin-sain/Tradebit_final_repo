// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:exchange/screen/wallet/tabs/withdraw_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../config/APIClasses.dart';
import '../../../config/APIMainClass.dart';
import '../../../config/ToastClass.dart';
import '../../../config/constantClass.dart';

class network {
  String name;

  network({this.name});
}

class withDraw extends StatefulWidget {
  String currency;
  String currencySymbol;
  String qty;
  List network;
  withDraw(
      {Key key, this.currency, this.network, this.qty, this.currencySymbol})
      : super(key: key);

  _withDrawState createState() => _withDrawState();
}

class _withDrawState extends State<withDraw> {
  TextEditingController amountcontroller = new TextEditingController();
  TextEditingController walletcontroller = new TextEditingController();
  double gasfee = 0.0;
  network _selectnetwork;
  String networkName;
  bool enable = true;
  String _scanBarcode = '';
  List<network> _netList = [];
  Future<void> Withdrawdata() async {
    final paramDic = {
      "amount": amountcontroller.text.toString(),
      "toAddress": walletcontroller.text.toString(),
      "token_type": networkName.toString(),
      "currency": widget.currencySymbol.toString(),
    };
    print(paramDic);
    var response = await LBMAPIMainClass(APIClasses.withdraw, paramDic, "Post");
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print("dash " + data.toString());
      ToastShowClass.toastShow(context, data["message"], Colors.blue);

      if (data['status_text'].toString().toLowerCase() == 'success') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WithdrawOtp()));
      } else {
        Navigator.of(context).pop();
      }
    } else {
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    for (int i = 0; i < widget.network.length; i++)
      _netList.add(network(name: widget.network[i]['token_type'].toString()));
    setState(() {
      networkName = widget.network[0]['token_type'].toString();
      gasfee =
          double.parse(widget.network[0]['withdraw_commission'].toString());
    });

    print("NE T " + widget.network.toString());

    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      walletcontroller.text = _scanBarcode.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //   height:400.0,
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: day == false ? Colors.transparent : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 27.0,
              ),
              Row(
                children: [
                  Text(
                    "Destination Address",
                    style: TextStyle(
                        color: day == false
                            ? Colors.white
                            : Colors.black.withOpacity(0.7),
                        fontFamily: "IBM Plex Sans"),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () => scanQR(),
                      child: Icon(
                        Icons.qr_code_scanner,
                        color: day == false ? Colors.white : Colors.black,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 5.0,
                ),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Designation is required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: walletcontroller,
                  decoration: InputDecoration(
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xff244388))),
                    hintText: "Wallet Address",
                    hintStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54,
                        fontFamily: "IBM Plex Sans",
                        fontSize: 15.0),

                    // style: TextStyle(color:day==false?Colors.white:Colors.black),
                  ),
                ),
              ),
              //   Text("Designation is required",style: TextStyle(color: Colors.red,fontFamily: "IBM Plex Sans",fontSize: 10,fontWeight: FontWeight.w600),),

              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Text(
                  "Network",
                  style: TextStyle(
                    color: day == false
                        ? Colors.white
                        : Colors.black.withOpacity(0.7),
                    fontFamily: "IBM Plex Sans",
                  ),
                ),
              ),
              Container(
                child: DropdownButton<network>(
                  underline: Container(
                    height: 1,
                    color: day == false ? Colors.white : Colors.black,
                  ),
                  dropdownColor: day == false ? Colors.black : Colors.white,
                  iconEnabledColor: day == false ? Colors.white : Colors.black,
                  iconDisabledColor:
                      day == false ? Colors.white54 : Colors.black54,
                  isExpanded: true,
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black),
                  hint: Text(
                    widget.network[0]['token_type'].toString(),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: day == false ? Colors.white : Colors.black45),
                  ),
                  value: _selectnetwork,
                  onChanged: (network Value) {
                    setState(() {
                      _selectnetwork = Value;
                      networkName = _selectnetwork.name;
                    });
                  },
                  items: _netList.map((network user) {
                    return DropdownMenuItem<network>(
                      value: user,
                      child: Row(
                        children: <Widget>[
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: day == false ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Text(
                  "Amount",
                  style: TextStyle(
                    color: day == false
                        ? Colors.white
                        : Colors.black.withOpacity(0.7),
                    fontFamily: "IBM Plex Sans",
                  ),
                ),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Amount is required';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: calcuate,
                keyboardType: TextInputType.number,
                controller: amountcontroller,
                decoration: InputDecoration(
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xff244388))),
                    hintText: "Amount",
                    hintStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54,
                        fontFamily: "IBM Plex Sans",
                        fontSize: 15.0)),
                style: TextStyle(
                    color: day == false ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Transaction Fees: ${gasfee.toStringAsFixed(1)}",
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: "IBM Plex Sans",
                            fontSize: 12.0),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 6,
                      child: Text(
                        widget.qty + " " + widget.currency.toString(),
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: "IBM Plex Sans",
                            fontSize: 12.0),
                      )),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("Min Withdrawl: ${widget.network[0]['withdraw_min'].toString()} "+widget.currency,style: TextStyle(color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans",fontSize: 12.0)),
              //       Text("Max Withdrawl: ${widget.network[0]['withdraw_max'].toString()} "+widget.currency,style: TextStyle(color: day==false?Colors.white:Colors.black,fontFamily: "IBM Plex Sans",fontSize: 12.0))
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20.0,
              ),

              InkWell(
                onTap: () {
                  final formState = _formKey.currentState;
                  if (formState.validate()) {
                    Withdrawdata();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: day == false ? Colors.white : Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Proceed Withdraw",
                        style: TextStyle(
                            fontFamily: "IBM Plex Sans",
                            fontSize: 16.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            color: day == false ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  Text("Warning",
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "IBM Plex Sans",
                          fontSize: 14.0)),
                ],
              ),
              Divider(
                color: day == false ? Colors.white54 : Colors.black54,
              ),
              Text(
                  '''● Please Double-Check The Destination Address. Withdrawal Requests Cannot Be Cancelled After Submission.''',
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black,
                      fontFamily: "IBM Plex Sans",
                      fontSize: 10.0)),
              Text(
                  '''● Withdrawals To Smart Contract Addresses Will Be Lost Forever.''',
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black,
                      fontFamily: "IBM Plex Sans",
                      fontSize: 10.0))
            ],
          ),
        ),
      ),
    );
  }

  // withdraw_commission: 0, type: percentage,
  void calcuate(String value) {
    if (widget.network[0]['type'] == 'percentage') {
      gasfee = double.parse(amountcontroller.text.toString()) *
          double.parse(widget.network[0]['withdraw_commission'].toString());
      print(gasfee.toString() + " TO TAL ");
    } else {
      gasfee =
          double.parse(widget.network[0]['withdraw_commission'].toString());
    }
  }
}
