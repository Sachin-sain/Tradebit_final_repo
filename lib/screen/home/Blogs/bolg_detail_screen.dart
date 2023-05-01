// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/screen/home/Blogs/blogs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../config/constantClass.dart';

class BlogDetailScreen extends StatefulWidget {
  int id;
  BlogDetailScreen({Key key, this.id}) : super(key: key);

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  bool errorOccoured = false;
  bool blogsLoading = false;
  List categoriesList = [];
  List blogsList = [];
  String errormsg = 'Something Went Wrong !! \n Please try again Later.';
  var blogDetail;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  Future<void> getCategories() async {
    try {
      final params = {"per_page": "5"};

      final url = Uri.https('server.bitqixnode.co.in', '/category/get', params);

      final http.Response response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == '1') {
          log(data.toString());
          setState(() {
            categoriesList = data['data']['data'];

            print(categoriesList.length);
          });
        } else {}
      } else {
        print('errorOccoured');
      }
    } catch (e) {}
  }

  Future<void> getBlogs() async {
    try {
      final params = {"page": "1", "per_page": "5"};

      final url = Uri.https('server.bitqixnode.co.in', '/blog/get', params);
      print(url);

      final http.Response response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == '1') {
          log(data.toString());
          setState(() {
            blogsList = data['data']['data'];
            print(blogsList.length);
          });
        } else {}
      } else {
        print('errorOccoured');
      }
    } catch (e) {}
  }

  Future<void> getBlogDetails(String id) async {
    setState(() {
      blogsLoading = true;
    });
    try {
      final params = {'id': id};

      final url = Uri.https('server.bitqixnode.co.in', '/blog/get', params);
      print(url);

      final http.Response response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == '1') {
          log(data.toString());
          setState(() {
            blogDetail = data['data'];
            print(blogDetail.length);
            blogsLoading = false;
          });
        } else {
          setState(() {
            errorOccoured = true;
            errormsg = data['message'];
            blogsLoading = false;

            print(errormsg);
          });
        }
      } else {
        setState(() {
          errorOccoured = true;
          blogsLoading = false;
        });
        print('errorOccoured');
      }
    } catch (e) {
      setState(() {
        errorOccoured = true;
        blogsLoading = false;
        print('catch == > $e');
      });
    }
  }

  Future<void> getAllData(String id) async {
    Future.wait([
      getBlogs(),
      getCategories(),
      getBlogDetails(id),
    ]);
  }

  Future<void> subscribeApi() async {
    final url = Uri.parse('https://bitqix.io/backend/public/api/newsletter');
    final params = {
      "email": emailController.text,
      "name": nameController.text,
    };
    try {
      final http.Response response = await http.post(url, body: params);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status_code'] == '1') {
          ToastShowClass.toastShow(context, data['message'], Colors.green);
          setState(() {
            autovalidateMode = AutovalidateMode.disabled;
          });
          emailController.clear();
          nameController.clear();
        } else {
          ToastShowClass.toastShow(context, data['message'], Colors.red);
        }
      } else {
        ToastShowClass.toastShow(context, 'Something Went Wrong', Colors.red);
      }
    } catch (e) {
      ToastShowClass.toastShow(context, 'Something Went Wrong', Colors.red);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.wait([
        getBlogs(),
        getCategories(),
        getBlogDetails(widget.id.toString()),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Detail"),
        backgroundColor: Color(0xff17394f),
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        child: blogsLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: day ? Colors.black : Colors.white,
                              width: 0.4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            blogDetail['image'],
                            fit: BoxFit.fill,
                            height: height * 0.3,
                            width: width,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: height * 0.3,
                                width: width,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(
                              height: height * 0.3,
                              width: width,
                              child: Center(
                                child: Text('Image Not Available',style: TextStyle(fontFamily: "IBM Plex Sans"),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        DateFormat.yMMMMd().format(
                          DateTime.parse(blogDetail['updatedAt']),
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,fontFamily: "IBM Plex Sans",
                            color: day ? Colors.black87 : Colors.white70,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: height * 0.001,
                      ),
                      Text(
                        blogDetail['name'].toString().toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans",
                          fontSize: 16,
                          color: day ? Colors.black : Colors.white,
                        ),
                      ),
                      Html(
                        data: blogDetail['description'] ?? '',
                        defaultTextStyle:
                            TextStyle(color: day ? Colors.black : Colors.white,fontFamily: "IBM Plex Sans",fontSize: 12),
                      ),
                      Divider(
                        color: day ? Colors.black : Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Subscribe Bitqix Newsletter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,fontFamily: "IBM Plex Sans",
                              fontSize: 16,
                              color: day ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: autovalidateMode,
                        style: TextStyle(
                            color: day == false ? Colors.white : Colors.black,fontFamily: "IBM Plex Sans"),
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Enter Your Email';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color:
                                day == false ? Colors.white54 : Colors.black54,
                          )),
                          hintText: 'Email',
                          labelText: 'Email',
                          hintStyle: TextStyle(fontFamily: "IBM Plex Sans",
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54),
                          labelStyle: TextStyle(fontFamily: "IBM Plex Sans",
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      TextFormField(
                        controller: nameController,
                        autovalidateMode: autovalidateMode,
                        style: TextStyle(fontFamily: "IBM Plex Sans",
                            color: day == false ? Colors.white : Colors.black),
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Enter Your Name';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color:
                                day == false ? Colors.white54 : Colors.black54,
                          )),
                          hintText: 'Name',
                          labelText: 'Name',
                          hintStyle: TextStyle(fontFamily: "IBM Plex Sans",
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54),
                          labelStyle: TextStyle(fontFamily: "IBM Plex Sans",
                              color: day == false
                                  ? Colors.white54
                                  : Colors.black54),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                        height: height * 0.06,
                        width: width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff17394f))),
                          onPressed: () {
                            FocusManager.instance.primaryFocus.unfocus();
                            if (_formKey.currentState.validate()) {
                              FocusManager.instance.primaryFocus.unfocus();
                              _formKey.currentState.save();
                              subscribeApi();
                            } else {
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
                              });
                            }
                          },
                          child: Text(
                            'Subscribe',
                            style: TextStyle(fontFamily: "IBM Plex Sans",
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Divider(
                        color: day ? Colors.black : Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Blogs',
                            style: TextStyle(fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: day ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      for (var i = 0; i < blogsList.length; i++)
                        InkWell(
                          onTap: () {
                            if (widget.id.toString() !=
                                blogsList[i]['id'].toString()) {
                              getAllData(blogsList[i]['id'].toString());
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.01),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 15,
                                  color: day ? Colors.black : Colors.white,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  blogsList[i]['name'].toString().toUpperCase(),
                                  style: TextStyle(fontFamily: "IBM Plex Sans",
                                      color: day ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Divider(
                        color: day ? Colors.black : Colors.white,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: day ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      for (var i = 0; i < categoriesList.length; i++)
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlogsScreen(id: categoriesList[i]['id']),
                                ));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.01),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 15,
                                  color: day ? Colors.black : Colors.white,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  categoriesList[i]['name']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(fontFamily: "IBM Plex Sans",
                                      color: day ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                )
                              ],
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
