// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_init_to_null, must_call_super, deprecated_member_use, missing_return

import 'dart:core';
import 'dart:io';

import 'package:async/async.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/setting/AttachmentAddDialogBox.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class VerifyKYC extends StatefulWidget {
  static const routeName = '/VerifyKYC';

  String kyc_Status;
  String kyc_msg;

  VerifyKYC({this.kyc_Status, this.kyc_msg});

  @override
  State<VerifyKYC> createState() => _VerifyKYCState();
}

class _VerifyKYCState extends State<VerifyKYC> {
  // String status;
  DateTime selectedfromDate;
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController middlenamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  final TextEditingController docnumbercontroller = TextEditingController();
  final TextEditingController pannumbercontroller = TextEditingController();
  Doc _selectDoc;
  String DocName;
  bool enable = true;
  List<Doc> _docList = Doc.getDoc();
  File imageFront = null, imagepancard = null, imageback = null;
  String firstFRONT = '', secondBACK = '', PANImage = '';
  bool isUploadfront = false;
  bool isUploadback = false;
  bool isUploadpan = false;
  String token;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  initState() {
    //  Getverification();
    gettoken();
    selectedfromDate = DateTime.now();
  }

  gettoken() async {
    token = await SharedPreferenceClass.GetSharedData('token');
  }


  void updatekyc() async {
    final uri = new Uri.https(APIClasses.LBM_BaseURL, APIClasses.kycupdate);

    MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ' + token;
    request.fields['first_name'] = firstnamecontroller.text.toString();
    request.fields['middle_name'] = middlenamecontroller.text.toString();
    request.fields['last_name'] = lastnamecontroller.text.toString();
    request.fields['date_birth'] = datecontroller.text.toString();
    request.fields['address'] = addresscontroller.text.toString();
    request.fields['identity_type'] = DocName.toString();
    request.fields['identity_number'] = docnumbercontroller.text.toString();
    request.fields['pan_card_number'] = pannumbercontroller.text.toString();
    print(request.toString());
    var file1;
    var file2;
    var file3;
    print(request.fields);
    if (imageFront != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFront.openRead()));
      var length = await imageFront.length();
      file1 = new http.MultipartFile('identity_front_path', stream, length,
          filename: "frontimage");
      request.files.add(file1);
      print("LENGTHTHTH " + length.toString());
    }
    if (imageback != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageback.openRead()));
      var length = await imageback.length();
      file2 = new http.MultipartFile('identity_back_path', stream, length,
          filename: "backimage");
      request.files.add(file2);
    }
    if (imagepancard != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imagepancard.openRead()));
      var length = await imagepancard.length();
      file3 = new http.MultipartFile('pan_card_path', stream, length,
          filename: "pancard");
      request.files.add(file3);
    }
    // print(request.files.first);
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.body}");
    // listen for response
    print("done1");
    if (response.statusCode == 200) {
      setState(() {
        Verifiedstatus = 'pending';
      });

      print("done");
      ToastShowClass.toastShow(
          context, 'KYC Submitted Successfully', Colors.blue);
      setState(() {
        enable = true;
      });
      Navigator.of(context).pop();
    } else {
      print("wrong");
      setState(() {
        enable = true;
      });
      ToastShowClass.toastShow(context, 'Invalid data ', Colors.blue);
    }
  }

  _selectfromDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff143047), // header background color
              onPrimary: Colors.white, // header text color
              surface: Colors.black,
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
      firstDate: DateTime(1947),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedfromDate)
      setState(() {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(selected);
        // selectedfromDate = formatted;
        datecontroller.text = formatted.toString().split(" ")[0];
      });
  }

  getFrontDisplayImage() {
    setState(() {
      imageFront = frontUpdateKycFilePath;
      if (imageFront == null) {
        isUploadfront = false;
        frontUpdateKycFilePath = null;
      } else {
        isUploadfront = true;
        frontUpdateKycFilePath = null;
      }
    });
  }

  getBackDisplayImage() {
    setState(() {
      imageback = backUpdateKycFilePath;
      if (imageback == null) {
        isUploadback = false;
        backUpdateKycFilePath = null;
      } else {
        isUploadback = true;
        backUpdateKycFilePath = null;
      }
    });
  }

  getPanDisplayImage() {
    setState(() {
      imagepancard = panUpdateKycFilePath;
      if (imagepancard == null) {
        isUploadpan = false;
        panUpdateKycFilePath = null;
      } else {
        isUploadpan = true;
        panUpdateKycFilePath = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: day == false ? Colors.black : Colors.white,
              title: Text("KYC Detail",
                  style: TextStyle(
                    fontFamily: "IBM Plex Sans",
                    color: day == false ? Colors.white : Colors.black,
                  )),
            ),
            backgroundColor: day == false ? Colors.black : Colors.white,
            body: Verifiedstatus == "new" || Verifiedstatus == "rejected"
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: widget.kyc_msg == '' ? false : true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Your kyc is Rejected due to following Reasons.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  widget.kyc_msg == null
                                      ? "abc"
                                      : widget.kyc_msg,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),

                          Text(
                            "Basic Detail:",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color:
                                    day == false ? Colors.white : Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            controller: firstnamecontroller,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please Enter First Name';
                              }

                              return null;
                            },
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,
                              hintText: 'Enter First Name',
                              labelText: 'First Name',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            controller: middlenamecontroller,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),

                            // validator: (input) {
                            //         if (input.isEmpty) {
                            //           return 'Please Enter Middle Name';
                            //         }
                            //         else{
                            //           return null;
                            //         }
                            //       },
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,

                              hintText: 'Enter Middle Name',
                              labelText: 'Middle Name',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            controller: lastnamecontroller,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please Enter Last Name';
                              } else {
                                return null;
                              }
                            },
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,
                              hintText: 'Enter Last Name',
                              labelText: 'Last Name',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                // width:250,
                                child: new TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.datetime,
                                  controller: datecontroller,
                                  style: TextStyle(
                                      color: day == false
                                          ? Colors.white
                                          : Colors.black),

                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please Enter Date Of Birth';
                                    } else {
                                      return null;
                                    }
                                  },
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: day == false
                                              ? Colors.white54
                                              : Colors.black54,
                                        )),
                                    filled: true, //<-- SEE HERE
                                    fillColor: day == false
                                        ? Colors.black
                                        : Colors.white,
                                    border: InputBorder.none,
                                    hintText: 'Enter Date Of Birth',
                                    labelText: 'Date Of Birth',
                                    hintStyle: TextStyle(
                                        color: day == false
                                            ? Colors.white54
                                            : Colors.black54),
                                    labelStyle: TextStyle(
                                        color: day == false
                                            ? Colors.white54
                                            : Colors.black54),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  _selectfromDate(context);
                                },
                                child: Icon(
                                  Icons.calendar_today,
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            controller: addresscontroller,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                            maxLines: 2,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please Enter Address';
                              } else {
                                return null;
                              }
                            },
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,

                              hintText: 'Enter Address',
                              labelText: 'Address',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Divider(
                          //  color:day==false?Colors.white:Colors.black45,height: 15,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Identity Verification:",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color:
                                    day == false ? Colors.white : Colors.black),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Document Type",
                            style: TextStyle(
                                fontSize: 12.0,
                                color:
                                    day == false ? Colors.white : Colors.black),
                          ),
                          Container(
                            child: DropdownButton<Doc>(
                              underline: Container(
                                height: 1,
                                color:
                                    day == false ? Colors.white : Colors.black,
                              ),
                              dropdownColor:
                                  day == false ? Colors.black : Colors.white,
                              iconEnabledColor:
                                  day == false ? Colors.white : Colors.black,
                              iconDisabledColor: day == false
                                  ? Colors.white54
                                  : Colors.black54,
                              isExpanded: true,
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black),
                              hint: Text(
                                "Select Document Type",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black45),
                              ),
                              value: _selectDoc,
                              onChanged: (Doc Value) {
                                setState(() {
                                  _selectDoc = Value;
                                  DocName = _selectDoc.value;
                                });
                              },
                              items: _docList.map((Doc user) {
                                return DropdownMenuItem<Doc>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: day == false
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            controller: docnumbercontroller,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please Enter Document Number';
                              } else {
                                return null;
                              }
                            },
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,

                              hintText: 'Enter Document Number',
                              labelText: 'Document Number',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              prefixIcon: const Icon(
                                  Icons.document_scanner_outlined,
                                  color: Colors.white70),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Upload Front",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        image = "front";
                                      });
                                      showGeneralDialog(
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                return Transform.scale(
                                                  scale: a1.value,
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child:
                                                        AttachmentAddDialogBox(
                                                            "Front"),
                                                  ),
                                                );
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 400),
                                              barrierDismissible: false,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation1,
                                                  animation2) {})
                                          .then((value) =>
                                              getFrontDisplayImage());
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black54)),
                                        height: 100,
                                        width: 150,
                                        child: imageFront == null
                                            ? Icon(
                                                Icons.image_outlined,
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 100,
                                              )
                                            : Container(
                                                height: 100,
                                                width: 150,
                                                child: Image.file(imageFront),
                                              )),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Upload Back",
                                    style: TextStyle(
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        image = "back";
                                      });
                                      showGeneralDialog(
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                return Transform.scale(
                                                  scale: a1.value,
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child:
                                                        AttachmentAddDialogBox(
                                                            "Back"),
                                                  ),
                                                );
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 400),
                                              barrierDismissible: false,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation1,
                                                  animation2) {})
                                          .then(
                                              (value) => getBackDisplayImage());
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: day == false
                                                    ? Colors.white54
                                                    : Colors.black54)),
                                        height: 100,
                                        width: 150,
                                        child: imageback == null
                                            ? Icon(
                                                Icons.image_outlined,
                                                color: day == false
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 100,
                                              )
                                            : Container(
                                                height: 100,
                                                width: 150,
                                                child: Image.file(imageback),
                                              )),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "PAN Card Verification:",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color:
                                    day == false ? Colors.white : Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            enabled: false,
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,

                              labelText: 'PAN Card',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            controller: pannumbercontroller,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please Enter Pan Document Number';
                              } else {
                                return null;
                              }
                            },
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: day == false
                                        ? Colors.white54
                                        : Colors.black54,
                                  )),
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  day == false ? Colors.black : Colors.white,
                              border: InputBorder.none,

                              hintText: 'Enter Document Number',
                              labelText: 'Document Number',
                              hintStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              labelStyle: TextStyle(
                                  color: day == false
                                      ? Colors.white54
                                      : Colors.black54),
                              prefixIcon: const Icon(
                                Icons.document_scanner_outlined,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Upload Document",
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                image = "pan";
                              });
                              showGeneralDialog(
                                      transitionBuilder:
                                          (context, a1, a2, widget) {
                                        return Transform.scale(
                                          scale: a1.value,
                                          child: Opacity(
                                            opacity: a1.value,
                                            child:
                                                AttachmentAddDialogBox("Pan"),
                                          ),
                                        );
                                      },
                                      transitionDuration:
                                          Duration(milliseconds: 400),
                                      barrierDismissible: false,
                                      barrierLabel: '',
                                      context: context,
                                      pageBuilder:
                                          (context, animation1, animation2) {})
                                  .then((value) => getPanDisplayImage());
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: day == false
                                            ? Colors.white54
                                            : Colors.black54)),
                                height: 100,
                                width: 150,
                                child: imagepancard == null
                                    ? Icon(
                                        Icons.image_outlined,
                                        color: day == false
                                            ? Colors.white
                                            : Colors.black,
                                        size: 100,
                                      )
                                    : Container(
                                        height: 100,
                                        width: 150,
                                        child: Image.file(imagepancard),
                                      )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color:Color(0xffc79509),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: GestureDetector(
                              onTap: () {
                                final formState = _formKey.currentState;

                                if (formState.validate()) {
                                  if (imageFront == null) {
                                    ToastShowClass.toastShow(
                                        context,
                                        "Please Choose the Front Image",
                                        Colors.red);
                                  } else if (imageback == null) {
                                    ToastShowClass.toastShow(
                                        context,
                                        "Please Choose the Back Image",
                                        Colors.red);
                                  } else if (imagepancard == null) {
                                    ToastShowClass.toastShow(
                                        context,
                                        "Please Choose the Pan Image",
                                        Colors.red);
                                  } else {
                                    setState(() {
                                      enable = false;
                                    });
                                    updatekyc();
                                  }
                                }
                              },
                              child: enable == true
                                  ? Text(
                                      "Save",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  : Container(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                : Verifiedstatus == "pending"
                    ? Center(
                        child: Container(
                          child: Text(
                            "Your Kyc has been submitted successfully and Pending For Approval.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontSize: 14),
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          child: Text(
                            "Your Kyc verification is successfully completed.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    day == false ? Colors.white : Colors.black,
                                fontSize: 14),
                          ),
                        ),
                      )));
  }
}

class Doc {
  String value;
  String name;

  Doc(this.value, this.name);

  static List<Doc> getDoc() {
    return <Doc>[
      Doc('aadhaar', 'Aadhaar Card'),
      Doc('voter', 'Voter Card'),
      Doc('driving', 'Driving License'),
      Doc('passport', 'Passport'),
    ];
  }
}
