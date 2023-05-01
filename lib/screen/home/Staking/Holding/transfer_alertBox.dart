
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../../config/constantClass.dart';
import '../Constants/Common.dart';
import '../Constants/colors.dart';
import 'api.dart';

class TransferAlertBox extends StatefulWidget {
  var withdrable;
  var currency;
  TransferAlertBox({@required this.withdrable, @required this.currency});

  @override
  State<TransferAlertBox> createState() => _BottomsheetScreenState();
}

class _BottomsheetScreenState extends State<TransferAlertBox> {

  final _amountController = TextEditingController();



  bool transfer = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Color black = day==false?Colors.white:Colors.black;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(onTap: (){

    },
      child: Scaffold(key: _formKey,
        backgroundColor: Colors.transparent,
        body: InkWell(onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height / 2.7,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: ContainerDecoration.copyWith(
                        color:day==false?Colors.black:Colors.white,border: Border.all(color: Colors.blue,width: 2) ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Transfer to Wallet",
                                style: style_white.copyWith(
                                    color: black,
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              InkWell(
                                  child: Icon(Icons.cancel,
                                      color:black),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: height / 51,
                          ),
                          Text(
                            "Do you want to transfer ?",
                            style: style_white.copyWith(
                                color:
                                black,
                                fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: height / 41,
                          ),
                          Row(
                            children: [
                              Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color:black),
                              ),
                              Spacer(),
                              Text(
                                "Withdrawal Amount : ${double.parse(widget.withdrable.toString()).toStringAsFixed(5)} ${widget.currency.toString()}",
                                style: TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: black),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: width / 1.6,
                                  child: TextFormField( keyboardType: TextInputType.number,style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),controller: _amountController,
                                    decoration:
                                    textFromFilled_de3coration.copyWith(hintText: "Enter The Amount",hintStyle: TextStyle( fontFamily: "IBM Plex Sans",color: Theme.of(context).textTheme.bodyText1.color,fontSize: 12,fontWeight: FontWeight.bold),
                                      errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 10.0,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                            bottomLeft:  Radius.circular(10))
                                       ,borderSide: BorderSide(color: AppColors.golden),),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                            bottomLeft:  Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color:  AppColors.golden),
                                      ),
                                    ),
                                  )),
                              Container(
                                height: height / 16,
                                width: width / 8,
                                child: Center(child: Text(widget.currency.toString(),style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),)),
                                decoration:ContainerDecoration.copyWith(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0),
                                        bottomLeft:  Radius.circular(0)),
                                    border:
                                        Border.all(color: AppColors.golden)),
                              ),
                              InkWell(
                                child: Container(
                                  height: height / 16,

                                  width: width / 8,
                                  child: Center(child: Text("Max")),
                                  decoration: ContainerDecoration.copyWith(
                                      color: AppColors.golden,
                                      border: Border.all(color: AppColors.golden),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),
                                        topRight:  Radius.circular(10),),),
                                ),onTap: (){
                                _amountController.text = widget.withdrable.toString();
                              },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(""),
                              Spacer(),
                              InkWell(
                                child: Container(
                                  height: height / 18,
                                  width: width / 4,
                                  decoration: ContainerDecoration.copyWith(
                                      color: AppColors.golden,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(child:transfer == true?Center(child: CircularProgressIndicator(),): Text(" Transfer")),
                                ),onTap: (){
                                transfer = true;
                                  setState((){});

                                transfer_to_account(context,_amountController.text.toString(),widget.currency.toString());

                                Future.delayed(Duration(seconds: 4),(){
                                  setState((){
                                    transfer = false;
                                  });
                                });
                              },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                child: Container(
                                  height: height / 18,
                                  width: width / 4,
                                  decoration: ContainerDecoration.copyWith(

                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: Text(" Cancel",style: TextStyle(color: black ,fontFamily: "IBM Plex Sans",),)),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
