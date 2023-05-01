// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../config/APIClasses.dart';
import '../../config/APIMainClass.dart';
import '../../config/SharedPreferenceClass.dart';
import '../../config/ToastClass.dart';
import '../../config/constantClass.dart';

class Contactus extends StatefulWidget {
  const Contactus({Key key}) : super(key: key);

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  String category_Id;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  List<Category> Categoryies = [];
  Category categoryValue;

  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();

  bool submitdata = false;
  @override
  void initState() {
    Getcategory();
    super.initState();
  }

  Future<void> Getcategory() async {
    final paramDic = {
      "": "",
    };
    print(paramDic);
    var response;
    response = await LBMAPIMainClass(APIClasses.get_Category, paramDic, "Get");
    var data = json.decode(response.body);
    List categories = [];

    print(response);
    if (data["status_code"] == '1') {
      setState(() {
        categories.addAll(data['data']);
        for (int i = 0; i < categories.length; i++) {
          Categoryies.add(new Category(
              name: categories[i]['name'], id: categories[i]['id'].toString()));
        }
      });
    } else {
      // ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Form(
      key: _formKeys,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Contact Us", style: TextStyle(fontFamily: "IBM Plex Sans")),
          backgroundColor: day == false ? Colors.black : Colors.white,
        ),
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new TextFormField(
                  cursorWidth: 0,
                  cursorHeight: 0,
                  controller: _titleController,
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please Enter Ticket Title';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),
                    hintText: 'Enter Title',
                    labelText: 'Title',
                    hintStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                    labelStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Choose Category",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: day == false ? Colors.white54 : Colors.black54)),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: day == false ? Colors.white54 : Colors.black54),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  height: screenSize.height * 0.07,
                  child: DropdownButtonFormField<Category>(
                    // underline: Container(
                    //   height: 1,
                    //   color:day==false?Colors.white:Colors.black,
                    // ),
                    dropdownColor: day == false ? Colors.black : Colors.white,
                    iconEnabledColor:
                        day == false ? Colors.white : Colors.black,
                    iconDisabledColor:
                        day == false ? Colors.white54 : Colors.black54,
                    isExpanded: true,
                    style: TextStyle(
                        color: day == false ? Colors.white : Colors.black),
                    hint: Text(
                      "Choose Category",
                      style: TextStyle(
                          fontSize: 14.0,
                          color:
                              day == false ? Colors.white54 : Colors.black45),
                    ),
                    // iconEnabledColor:  day==false?Colors.white:Colors.black,
                    // style: TextStyle(color:Colors.black),
                    // dropdownColor:day==false?Color(0xff17394f):Colors.white,
                    value: categoryValue,
                    decoration: InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    items: Categoryies.map((Category value) {
                      return DropdownMenuItem<Category>(
                        value: value,
                        child: Text(
                          value.name,
                          style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,
                            fontFamily: "IBM Plex Sans",
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      category_Id = newVal.id;
                      print(category_Id.toString());
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                new TextFormField(
                  cursorWidth: 0,
                  cursorHeight: 0,
                  controller: _nameController,
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please Enter Your Name';
                    }

                    return null;
                  },
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),
                    hintText: 'Enter Your Name',
                    labelText: 'Name',
                    hintStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                    labelStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                new TextFormField(
                  cursorHeight: 0,
                  cursorWidth: 0,
                  controller: _emailController,
                  style: TextStyle(
                    
                      color: day == false ? Colors.white : Colors.black),
                  validator: (value) => EmailValidator.validate(value)
                      ? null
                      : "Please enter a valid email",
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),
                    hintText: 'Enter Your Email',
                    labelText: 'Email',
                    hintStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                    labelStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  cursorWidth: 0,
                  cursorHeight: 0,
                  maxLines: 5,
                  style: TextStyle(
                      color: day == false ? Colors.white : Colors.black),
                  controller: _queryController,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please Enter Your Query';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff212529),
                        )),
                    border: const OutlineInputBorder(),
                    hintText: 'Leave a comment here',
                    labelText: 'Query',
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    hintStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                    labelStyle: TextStyle(
                        color: day == false ? Colors.white54 : Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    if (_formKeys.currentState.validate()) {
                      setState(() {
                        submitdata = true;
                        createticket();
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffc79509),
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: submitdata == true
                        ? CircularProgressIndicator()
                        : Text('Submit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createticket() async {
    final paramDic = {
      "author_email": _emailController.text.toString(),
      "author_name": _nameController.text.toString(),
      "category_id": category_Id.toString(),
      "content": _queryController.text.toString(),
      "title": _titleController.text.toString(),
    };
    print(paramDic.toString());
    final uri = Uri.https(APIClasses.LBM_BaseURL, APIClasses.ticket_create);
    print(uri.toString());

    HttpClient httpClient = HttpClient();

    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization',
        'Bearer ' + await SharedPreferenceClass.GetSharedData('token'));

    request.add(utf8.encode(json.encode(paramDic)));
    HttpClientResponse response = await request.close();
    // var response = await LBMAPIMainClass(APIClasses.LBM_register, paramDic, "Post");
    String reply = await response.transform(utf8.decoder).join();
    var data = jsonDecode(reply);
    print(data);

    if (data["status_code"] == '1') {
      submitdata = false;
      ToastShowClass.toastShow(context, data["message"], Colors.blue);
      // SharedPreferenceClass.SetSharedData("isLogin", "true");
      Navigator.of(context).pop();
    } else {
      setState(() {
        submitdata = false;
      });
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }
}

class Category {
  String id;
  String name;
  Category({this.id, this.name});
}
