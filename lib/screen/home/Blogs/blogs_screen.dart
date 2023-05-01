// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:exchange/screen/home/Blogs/bolg_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../config/constantClass.dart';

class BlogsScreen extends StatefulWidget {
  int id;
  BlogsScreen({Key key, this.id}) : super(key: key);

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen>
    with SingleTickerProviderStateMixin {
  bool tabsLoading = false;
  bool blogsLoading = false;
  bool errorOccoured = false;
  int selectedIndex = 0;
  String errormsg = 'Something Went Wrong !! \n Please try again Later.';
  List categoriesList = [];
  List blogsList = [];

  Future<void> getCategories() async {
    setState(() {
      tabsLoading = true;
    });
    try {
      final params = {"per_page": "100"};

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
            if (widget.id != null) {
              selectedIndex = categoriesList
                  .indexWhere((element) => element['id'] == widget.id);
              if (selectedIndex == -1) {
                selectedIndex = 0;
              }
            }
            tabsLoading = false;
          });
          await getBlogs(widget.id == null
              ? data['data']['data'][0]['id'].toString()
              : widget.id.toString());
        } else {
          setState(() {
            errorOccoured = true;
            errormsg = data['message'];
            tabsLoading = false;
            print(errormsg);
          });
        }
      } else {
        setState(() {
          errorOccoured = true;
          tabsLoading = false;
        });
        print('errorOccoured');
      }
    } catch (e) {
      setState(() {
        errorOccoured = true;
        tabsLoading = false;
        print('catch == > $e');
      });
    }
  }

  Future<void> getBlogs(String cid) async {
    setState(() {
      blogsLoading = true;
    });
    try {
      final params = {"cid": cid, "page": "1", "per_page": "100"};

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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getCategories();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blogs",
          style: TextStyle(fontFamily: "IBM Plex Sans"),
        ),
        backgroundColor: Color(0xff17394f),
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      body: tabsLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : errorOccoured
              ? Expanded(
                  child: Text(
                  errormsg,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: day ? Colors.black : Colors.white),
                ))
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i = 0; i < categoriesList.length; i++)
                                InkWell(
                                  onTap: () {
                                    if (selectedIndex != i) {
                                      getBlogs(
                                          categoriesList[i]['id'].toString());
                                      setState(() {
                                        selectedIndex = i;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.01,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: selectedIndex == i
                                            ? LinearGradient(colors: [
                                                Color(0xff176980),
                                                Color(0xff143047)
                                              ])
                                            : null),
                                    child: Text(
                                      categoriesList[i]['name']
                                          .toString()
                                          .toUpperCase(),
                                      style: selectedIndex == i
                                          ? TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: "IBM Plex Sans")
                                          : TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: day == false
                                                  ? Colors.white54
                                                  : Colors.black54,
                                              fontFamily: "IBM Plex Sans"),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        blogsLoading
                            ? SizedBox(
                                height: height * 0.5,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : errorOccoured
                                ? SizedBox(
                                    height: height * 0.5,
                                    child: Center(
                                      child: Text(
                                        errormsg,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "IBM Plex Sans",
                                          color:
                                              day ? Colors.black : Colors.white,
                                        ),
                                      ),
                                    ))
                                : blogsList.isEmpty
                                    ? SizedBox(
                                        height: height * 0.5,
                                        child: Center(
                                          child: Text(
                                            'No Blogs Available !',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "IBM Plex Sans",
                                              color: day
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ))
                                    : SizedBox(),
                        if (!blogsLoading)
                          for (var i = 0; i < blogsList.length; i++)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color:
                                              day ? Colors.black : Colors.white,
                                          width: 0.4),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        blogsList[i]['image'],
                                        fit: BoxFit.fill,
                                        height: height * 0.3,
                                        width: width,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: height * 0.3,
                                            width: width,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SizedBox(
                                          height: height * 0.3,
                                          width: width,
                                          child: Center(
                                            child: Text(
                                              'Image Not Available',
                                              style: TextStyle(
                                                  fontFamily: "IBM Plex Sans"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    blogsList[i]['name']
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        fontFamily: "IBM Plex Sans",
                                        color:
                                            day ? Colors.black : Colors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xff17394f))),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlogDetailScreen(
                                                          id: blogsList[i]
                                                              ['id']),
                                                ));
                                          },
                                          child: Text(
                                            'Read More',
                                            style: TextStyle(
                                                fontFamily: "IBM Plex Sans"),
                                          )),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color:
                                            day ? Colors.black : Colors.white,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        DateFormat.yMMMMd().format(
                                            DateTime.parse(
                                                blogsList[i]['updatedAt'])),
                                        style: TextStyle(
                                            fontFamily: "IBM Plex Sans"),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: day ? Colors.black : Colors.white,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  )
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
