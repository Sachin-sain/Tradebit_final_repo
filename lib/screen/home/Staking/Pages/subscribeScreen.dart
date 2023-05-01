// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_statements, missing_return

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/ToastClass.dart';
import '../../../../config/constantClass.dart';
import '../Constants/Common.dart';
import '../Constants/colors.dart';
import '../Holding/api.dart';

class SubscribeScreen extends StatefulWidget {
  final data;
  final planTypeData;

  const SubscribeScreen(
      {Key key, @required this.data, @required this.planTypeData})
      : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final _lock_Amount_Controller = TextEditingController();

  Color fieldcolor = AppColors.golden;
  bool readTnC = false;
  bool submit = false;
  String SelectedCoin_balance = "0";
  String Plan_start_time = "0.00";
  @override
  Widget build(BuildContext context) {
    final Color black = day==false?Colors.white:Colors.black;
    final Color white = day==false?Colors.black:Colors.white;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: day==false?Colors.black:Colors.white,
        bottomSheet: Container(
          padding: EdgeInsets.only(bottom: 10),
          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
          height: height * 0.07,
          width: width,
          child: ElevatedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: AppColors.blue)),
                backgroundColor: MaterialStateProperty.all(white)),
            onPressed: () {
              if (double.tryParse(_lock_Amount_Controller.text) == null) {
                ToastShowClass.toastShow(
                    context, 'Please Enter Valid amount', Colors.red);
                return;
              }

              if (!readTnC) {
                ToastShowClass.toastShow(
                    context, "Please Agree Terms And Conditions", Colors.blue);
                return;
              }
              if (double.parse(_lock_Amount_Controller.text) >
                  double.parse(SelectedCoin_balance)) {
                ToastShowClass.toastShow(context,
                    "Entered amount is greater than the balance", Colors.blue);
                _lock_Amount_Controller.text.isEmpty
                    ? fieldcolor = Colors.red
                    : AppColors.golden;
                setState(() {});
                return;
              }

              if (double.parse(_lock_Amount_Controller.text) <
                  double.parse(widget.planTypeData["min_stake_amount"] == null
                      ? '0'
                      : widget.planTypeData["min_stake_amount"].toString())) {
                ToastShowClass.toastShow(
                    context,
                    "Entered amount is less than the minimum required amount",
                    Colors.blue);
                _lock_Amount_Controller.text.isEmpty
                    ? fieldcolor = Colors.red
                    : AppColors.golden;
                setState(() {});
                return;
              }
              if (_formKey.currentState.validate()) {
                setState(() {
                  submit = true;
                });
                fieldcolor = AppColors.golden;
                Future.delayed(Duration(seconds: 4), () {
                  setState(() {
                    submit = false;
                  });
                });
                subscribeApi(context, _lock_Amount_Controller.text.toString(),
                    widget.planTypeData["id"].toString());
              }
              // if(_formKey.currentState!.validate() ){  setState(() {});
              // submit = true;
              // fieldcolor = AppColors.golden;
              // Future.delayed(Duration(seconds: 4), () {
              //   setState(() {
              //     submit = false;
              //   });
              // });
              // subscribeApi(context, _lock_Amount_Controller.text.toString(), widget.planTypeData["id"].toString());
              //
              // }
              //
              // if (_formKey.currentState!.validate() && readTnC == true &&
              //     _lock_Amount_Controller.text >
              //         double.parse(SelectedCoin_balance) {
              // setState(() {});
              // submit = true;
              // fieldcolor = AppColors.golden;
              // Future.delayed(Duration(seconds: 4), () {
              // setState(() {
              // submit = false;
              // });
              // });
              // subscribeApi(context, _lock_Amount_Controller.text.toString(), widget.planTypeData["id"].toString());
              // } else {
              //
              // if( double.parse(_lock_Amount_Controller.text) > double.parse(SelectedCoin_balance)){
              // ToastShowClass.toastShow(context, "Entered amount is greater than the balance", Colors.blue);
              // }else{
              // readTnC == true ? "" : ToastShowClass.toastShow(context, "Please Agree Terms And Conditions", Colors.blue);
              // print("--------else---------");
              // }
              //
              // print("fail");
              // _lock_Amount_Controller.text.isEmpty
              // ? fieldcolor = Colors.red
              //     : AppColors.golden;
              // setState(() {});
              // }
            },
            child: submit == true
                ? Center(child: CircularProgressIndicator())
                : Text(
                    'Confirm',
                    style: TextStyle( fontFamily: "IBM Plex Sans",
                        color: day==false?Colors.white:Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 25,
                          color: black,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        'STAKE ${widget.data['stake_currency']}',
                        style: TextStyle(
                            color: black, fontFamily: "IBM Plex Sans",
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lock  Amount',
                              style: TextStyle(
                                  color: black, fontFamily: "IBM Plex Sans",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Available Amount: ${SelectedCoin_balance.toString()} ${widget.data['stake_currency']}',
                              style: TextStyle(
                                  color: black, fontFamily: "IBM Plex Sans",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Container(
                              height: height * 0.05,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.010),
                              decoration: BoxDecoration(
                                  border: Border.all(color: fieldcolor)),
                              child: SizedBox(
                                width: width * 0.65,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _lock_Amount_Controller,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      fieldcolor = Colors.red;
                                    } else {}
                                  },
                                  style: TextStyle(
                                      color: black, fontFamily: "IBM Plex Sans",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter the Amount",
                                    hintStyle: TextStyle(
                                        color: black.withOpacity(0.5), fontFamily: "IBM Plex Sans",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.05,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueGrey)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              child: Text(
                                widget.data['stake_currency'],
                                style: TextStyle(color: Colors.blueGrey, fontFamily: "IBM Plex Sans",),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.blue)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.021),
                                child: Text(
                                  'Max',
                                  style:
                                      TextStyle( fontFamily: "IBM Plex Sans",color: AppColors.blue),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _lock_Amount_Controller.text =
                                      SelectedCoin_balance.toString();
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          'Locked Amount Limitation',
                          style: TextStyle( fontFamily: "IBM Plex Sans",
                              color: black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          children: [
                            Text(
                              'Minimum :',
                              style: TextStyle( fontFamily: "IBM Plex Sans",color: AppColors.iconColor),
                            ),
                            SizedBox(
                              width: width * 0.15,
                            ),
                            Text(
                              widget.planTypeData["min_stake_amount"]
                                      .toString() +
                                  " " +
                                  widget.data['stake_currency'],
                              style: TextStyle( fontFamily: "IBM Plex Sans",
                                  color: AppColors.iconColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              'Maximum :',
                              style: TextStyle( fontFamily: "IBM Plex Sans",color: AppColors.iconColor),
                            ),
                            SizedBox(
                              width: width * 0.15,
                            ),
                            Text(
                              widget.planTypeData["max_stake_amount"]
                                      .toString() +
                                  " " +
                                  widget.data['stake_currency'],
                              style: TextStyle( fontFamily: "IBM Plex Sans",
                                  color: AppColors.iconColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          'Summary',
                          style: TextStyle( fontFamily: "IBM Plex Sans",
                              color: black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        _stepperWidget(
                            width,
                            height,
                            'Stake Date',
                            DateFormat("dd-MMM-yyyy")
                                .format(
                                    DateTime.parse(DateTime.now().toString())
                                        .toLocal())
                                .toString()),
                        _stepperWidget(
                            width,
                            height,
                            'Value Date',
                            DateFormat("dd-MMM-yyyy")
                                .format(
                                    DateTime.parse(DateTime.now().toString())
                                        .toLocal())
                                .toString()),
                        _stepperWidget(
                            width,
                            height,
                            'Interest Period',
                            widget.planTypeData["roi_interval"]
                                        .toString()
                                        .toLowerCase() ==
                                    "d"
                                ? "Daily"
                                : widget.planTypeData["roi_interval"]
                                            .toString()
                                            .toLowerCase() ==
                                        "m"
                                    ? "Month"
                                    : widget.planTypeData["roi_interval"]
                                                .toString()
                                                .toLowerCase() ==
                                            "y"
                                        ? "Year"
                                        : ""),
                        _stepperWidget(
                            width,
                            height,
                            'Interest End Date',
                            DateFormat("dd-MMM-yyyy")
                                .format(DateTime.parse(DateTime.now()
                                        .add(Duration(
                                            days:
                                                widget.data['s_maturity_days']))
                                        .toString())
                                    .toLocal())
                                .toString()),
                        _stepperWidget(
                            width, height, 'Redemption Period', '2 Days'),
                        _stepperWidget(
                            width,
                            height,
                            'Redemption Date',
                            DateFormat("dd-MMM-yyyy")
                                .format(DateTime.parse(DateTime.now()
                                        .add(Duration(days: 2))
                                        .add(Duration(
                                            days:
                                                widget.data['s_maturity_days']))
                                        .toString())
                                    .toLocal())
                                .toString(),
                            last: true),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Divider(
                          color: AppColors.iconColor,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Et. APR',
                              style: TextStyle( fontFamily: "IBM Plex Sans",
                                  color: AppColors.iconColor, fontSize: 16),
                            ),
                            Text(
                              widget.planTypeData["roi_percentage"].toString() +
                                  "%",
                              style: TextStyle( fontFamily: "IBM Plex Sans",
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated Interest',
                              style: TextStyle( fontFamily: "IBM Plex Sans",
                                  color: AppColors.iconColor, fontSize: 16),
                            ),
                            Text(
                              '- -',
                              style: TextStyle( fontFamily: "IBM Plex Sans",
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: AppColors.blue,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            SizedBox(
                              width: width * 0.8,
                              child: Text(
                                'The APR is adjusted daily based on the on-chain staking rewards.and the specific Apr is subject to the page display on the day.',
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                style: TextStyle( fontFamily: "IBM Plex Sans",
                                    color: AppColors.iconColor, fontSize: 14),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                side: BorderSide(color: AppColors.iconColor),
                                activeColor: AppColors.blue,
                                value: readTnC,
                                onChanged: (val) {
                                  setState(() {
                                    readTnC = val;
                                  });
                                  print("readTnC" + readTnC.toString());
                                }),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            SizedBox(
                              width: width * 0.75,
                              child: Text(
                                'I have read and I agree to Bitqix Exchange Staking Services Agreement.',
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: TextStyle( fontFamily: "IBM Plex Sans",
                                    color: AppColors.iconColor, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.08)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String Plan_Expiry_time = "0.00";

  final _formKey = GlobalKey<FormState>();

  getcoinBalance() {
    print("--------------------------------");
    for (var i = 0; i < StakingCommonClass.Portfilio_bal.length; i++) {
      if (StakingCommonClass.Portfilio_bal[i]["symbol"]
              .toString()
              .toLowerCase() ==
          widget.data['stake_currency'].toString().toLowerCase()) {
        SelectedCoin_balance =
            StakingCommonClass.Portfilio_bal[i]["quantity"].toString();
        print("SelectedCoin_balance-----------------------" +
            SelectedCoin_balance.toString());
      } else {
        print("enter inelse-------------------------");
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    print("data " + widget.data.toString());
    getcoinBalance();

    super.initState();
  }

  Widget _stepperWidget(double width, double height, String text, String value,
      {bool last}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.diamond_outlined,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: width * 0.04,
                ),
                Text(
                  text,
                  style: TextStyle( fontFamily: "IBM Plex Sans",
                      color: AppColors.iconColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle( fontFamily: "IBM Plex Sans",
                  color: AppColors.iconColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        if (last == null)
          SizedBox(
            height: height * 0.03,
            child: VerticalDivider(
              color: Colors.green,
              thickness: 0.5,
              width: 20,
            ),
          ),
      ],
    );
  }
}

formattedDateTime(String dateTime) {
  return DateFormat("dd-MMM-yyyy hh:mm:ss")
      .format(DateTime.parse(dateTime).toLocal())
      .toString();
}
