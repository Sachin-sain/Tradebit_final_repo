

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:exchange/screen/setting/Notificationpage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:exchange/component/modelGridHome.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/home/Blogs/blogs_screen.dart';
import 'package:exchange/screen/home/ComingSoon.dart';
import 'package:exchange/screen/home/Deposit.dart';
import 'package:exchange/screen/home/Gainer.dart';
import 'package:exchange/screen/home/LaunchPad/launchapad.dart';
import 'package:exchange/screen/home/Loser.dart';
import 'package:exchange/screen/home/Staking/Pages/stakingScreen.dart';
import 'package:exchange/screen/home/hotDeals.dart';
import 'package:exchange/screen/intro/login.dart';
import 'package:exchange/screen/market/Search.dart';
import 'package:exchange/screen/setting/Support.dart';
import 'package:exchange/screen/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../config/constantClass.dart';
import '../../config/constantClass.dart';
import '../intro/Confirm_login.dart';
import '../setting/ReferralLink.dart';

class listType {
  String image;
  var token;
  listType({this.image,this.token});
}

class home extends StatefulWidget {
  _homeState createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {

  String _scanBarcode = '';
  int Selctedindex=0;

  @override
  //QR Code
  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      print("$barcodeScanRes");
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      var qrurl = barcodeScanRes;
      var token = qrurl.split('?qrcode=');
      _scanBarcode = token[1];

    });
  }

  AppUpdateInfo _updateInfo;
  Future<void> checkForUpdates() async {
    try {
      await InAppUpdate.checkForUpdate().then((info) {
        setState(() {
          _updateInfo = info;
        });
      });
      if (_updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: day == false ? Colors.white : Colors.black)),
            backgroundColor: day == false ? Colors.black : Colors.white,
            title: Text(
              'Tradebit Update ? ',
              style: TextStyle(
                color: day == false ? Colors.white : Colors.black,
              ),
            ),
            content: Text(
              'New Update is Available ! We recommends you that you update to the latest version.',
              style: TextStyle(color: day == false ? Colors.white : Colors.black,),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No,Thanks',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    launch("market://details?id=com.Bitqix.exchange")
                        .whenComplete(() => Navigator.pop(context));
                  } on PlatformException catch (e) {
                    print('Error == > ' + e.toString());
                    launch("https://play.google.com/store/apps/details?id=com.Bitqix.exchange")
                        .whenComplete(() => Navigator.pop(context));
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  ///
  /// Get image data dummy from firebase server
  ///
  bool bannerfetch = false;
  List banners = [];
  String status;
  String user_image;
  String ref_link;

  var imageNetwork = NetworkImage(
    "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Screenshot_20181005-213938.png?alt=media&token=8c1abb09-4acf-45cf-9383-2f94d93f4ec9",
  );

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  static NumberFormat Cr = new NumberFormat("#,##0.00", "en_US");
  TabController _tabController;
  List<listType> SliderImage = [
    listType(image: 'assets/image/banner/banner1.png',),
    listType(image: 'assets/image/banner/banner2.png'),
    listType(image: 'assets/image/banner/banner3.jpg'),
    listType(image: 'assets/image/banner/banner4.png')
  ];
  List<listType> SliderImages = [];
  var item;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      checkForUpdates();
    });
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    getBanners();
    BTCAPI(CurrencyName: 'USDT');
    check();
    connectToServer();
  }

  check() async {
    SharedPreferenceClass.SetSharedData("first_time", "true");
    status = await SharedPreferenceClass.GetSharedData('isLogin');
    user_image = await SharedPreferenceClass.GetSharedData('profile_image');
    ref_link = await SharedPreferenceClass.GetSharedData('ref_link');

    setState(() {
      status = status;
      ref_link = ref_link;
    });
    print("1ST " + firstTime.toString());
  }

  WebSocketChannel channel_home = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );

  Future<void> connectToServer() async {
    var jsonString = json.encode(subRequest_usdthome);
    channel_home.sink.add(jsonString);
  }

  @override
  void dispose() {
    channel_home.sink.close();
    super.dispose();
  }

  Future<void> getBanners() async {
    final paramDic = {
      "": '',
    };
    var response = await APIMainClassbanner(APIClasses.banners, paramDic, "Get");
    var data = json.decode(response.body);
    print(response.toString());

    if (response.statusCode == 200) {
      banners.addAll(data['data']);
      print(banners.toString());
      for (int i = 0; i < banners.length; i++) {
        SliderImages.add(new listType(
          image: banners[i]['image'],
        ));
      }
      setState(() {
        bannerfetch = true;
      });
      print("SLID " + SliderImages.length.toString());
    } else {
      //ToastClass.ToastShow(data["message"]);
    }
  }

  Widget ImageSlider(Size size) {
    return Container(
        child: SliderImage == null
            ? _loadingCardAnimationfirst(context)
            : CarouselSlider.builder(
                itemCount: SliderImages.length > 0
                    ? SliderImages.length
                    : SliderImage.length,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.5,
                  viewportFraction: 0.95,
                  enlargeCenterPage: true,
                ),
                itemBuilder: (context, index, reldx) {
                  return Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: SliderImages.length > 0
                            ? Image.network(SliderImages[index].image,
                                fit: BoxFit.fill, width: 1000.0)
                            : Image.asset(SliderImage[index].image.toString(),
                                fit: BoxFit.fill, width: 1000.0)),
                  );
                },
              ));
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: day == false ? Colors.black : Color(0xfff6f6f6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: 20, top: screenSize.height * 0.05, right: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new setting()));
                  },
                  child: CircleAvatar(
                      backgroundColor: day == false ? Color(0xff919191) : Colors.white,
                      child: Icon(Icons.person,
                        color: day == false ? Colors.white : Color(0xff919191),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    width: 200,
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 14,
                        color: day == false ? Colors.white : Color(0xff919191),
                      ),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        firsttimesearch = 0;
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new Search()));
                      },
                      cursorHeight: 0,
                      cursorWidth: 0,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color:
                                day == false ? Colors.white : Color(0xff919191),
                          ),
                          contentPadding: EdgeInsets.only(top: 10),
                          hintText: "Search Coin..."),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Support()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.support_agent_outlined,
                        color: day == false ? Colors.white : Color(0xff919191),
                      ),
                    )),
                InkWell(
                    onTap: () async {
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      scanQR();
                      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                      var ipAddress = IpAddress(type: RequestType.json);

                      /// Get the IpAddress based on requestType.
                      dynamic data = await ipAddress.getIpAddress();
                      print('Device Information ${androidInfo}');
                      print('Ip address ${data.toString()}');
                      // Navigator.of(context).push(PageRouteBuilder(
                      //     pageBuilder: (_, __, ___) => login_confirm(Token: _scanBarcode)));

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.qr_code,
                        color: day == false ? Colors.white : Color(0xff919191),
                      ),
                    )),
                Stack(alignment: Alignment.topCenter, children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => Notificationpage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Icon(
                          Icons.notifications_active,
                          color: day == false ? Colors.white : Color(0xff919191),
                        ),
                      )),
                  Visibility(
                    visible: notification_count == 0 ? false : true,
                    child: CircleAvatar(
                      radius: 6.5,
                      backgroundColor: Colors.red,
                      child: Text(
                        notification_count.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          /// B A N N E R

          Container(
            width: MediaQuery.of(context).size.width,
            child: bannerfetch == true || SliderImage.length != 0
                ? ImageSlider(size)
                : Container(
                    height: 100,
                    color: Colors.transparent,
                  ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 0, top: 5),
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: day == false ? Color(0xff181818) : Color(0xffffffff),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      height: 70,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: false,
                        padding:
                            const EdgeInsets.only(left: 0, right: 145, top: 5),
                        itemCount: menu.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (menu[index].name == "Deposit") {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        status == "true"
                                            ? new Deposit()
                                            : login()));
                              } else if (menu[index].name == "Referral") {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        status == "true"
                                            ? new ReferralLink(
                                                link: ref_link.toString(),
                                              )
                                            : login()));
                              } else if (menu[index].name == "Launchpad") {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        status == "true"
                                            ? new LaunchPadScreen()
                                            : login()));
                              } else if (menu[index].name == "Airdrop") {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        new Comingsoon()));
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  menu[index].image,
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      menu[index].name,
                                      style: TextStyle(
                                          fontFamily: "IBM Plex Sans",
                                          color: day == false
                                              ? Colors.white
                                              : Color(0xffa6a6a6),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 70,
                      child: Center(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              left: 0, right: 145, top: 5),
                          itemCount: menu1.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (menu1[index].name1 == "Staking") {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          status == "true"
                                              ? new StakingScreen()
                                              : login()));
                                } else if (menu1[index].name1 == "Blogs") {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new BlogsScreen()));
                                } else if (menu1[index].name1 ==
                                    "Transaction") {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new Comingsoon()));
                                } else if (menu1[index].name1 == "P2P") {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new Comingsoon()));
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    menu1[index].image1,
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        menu1[index].name1,
                                        style: TextStyle(
                                            fontFamily: "IBM Plex Sans",
                                            color: day == false
                                                ? Colors.white
                                                : Color(0xffa6a6a6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Container(
            height: 90.0,
            child: StreamBuilder(
                stream: channel_home.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      firsttimehome == 0) {
                    return _loadingCardAnimation(context);
                  } else if (snapshot.connectionState ==
                          ConnectionState.waiting &&
                      firsttimehome == 1) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listGridHome.length,
                      itemBuilder: (BuildContext context, int index) {
                        return card(context, index);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    //place your code here. It will prevent double data call.
                    item = json.decode(snapshot.hasData ? snapshot.data : '');
                    firsttimehome = 1;
                    if (item['s'] == 'ETHUSDT') {
                      listGridHome[0].name =
                          item['s'].toString().split('USDT')[0] + " / USDT";
                      listGridHome[0].valuePercent =
                          Cr.format(double.parse(item['P'].toString())) + "%";
                      listGridHome[0].chartColor =
                          double.parse(item['P'].toString()) > 0
                              ? Color(0xFF00C087)
                              : Colors.redAccent;
                      listGridHome[0].chartColorGradient =
                          double.parse(item['P'].toString()) > 0
                              ? [
                                  Colors.greenAccent.withOpacity(0.2),
                                  Colors.greenAccent.withOpacity(0.01)
                                ]
                              : [
                                  Colors.redAccent.withOpacity(0.2),
                                  Colors.redAccent.withOpacity(0.01)
                                ];
                      listGridHome[0].valueMarket =
                          num.parse(item['c'].toString()).toString();
                    }
                    if (item['s'] == 'BTCUSDT') {
                      listGridHome[1].name =
                          item['s'].toString().split('USDT')[0] + " / USDT";
                      listGridHome[1].valuePercent =
                          Cr.format(double.parse(item['P'].toString())) + "%";
                      listGridHome[1].chartColor =
                          double.parse(item['P'].toString()) > 0
                              ? Color(0xFF00C087)
                              : Colors.redAccent;
                      listGridHome[1].chartColorGradient =
                          double.parse(item['P'].toString()) > 0
                              ? [
                                  Colors.greenAccent.withOpacity(0.2),
                                  Colors.greenAccent.withOpacity(0.01)
                                ]
                              : [
                                  Colors.redAccent.withOpacity(0.2),
                                  Colors.redAccent.withOpacity(0.01)
                                ];
                      listGridHome[1].valueMarket =
                          num.parse(item['c'].toString()).toString();
                    }
                    if (item['s'] == 'XRPUSDT') {
                      listGridHome[2].name =
                          item['s'].toString().split('USDT')[0] + " / USDT";
                      listGridHome[2].valuePercent =
                          Cr.format(double.parse(item['P'].toString())) + "%";
                      listGridHome[2].chartColor =
                          double.parse(item['P'].toString()) > 0
                              ? Color(0xFF00C087)
                              : Colors.redAccent;
                      listGridHome[2].chartColorGradient =
                          double.parse(item['P'].toString()) > 0
                              ? [
                                  Colors.greenAccent.withOpacity(0.2),
                                  Colors.greenAccent.withOpacity(0.01)
                                ]
                              : [
                                  Colors.redAccent.withOpacity(0.2),
                                  Colors.redAccent.withOpacity(0.01)
                                ];

                      listGridHome[2].valueMarket =
                          num.parse(item['c'].toString()).toString();
                    }
                    if (item['s'] == 'ETCUSDT') {
                      listGridHome[3].name =
                          item['s'].toString().split('USDT')[0] + " / USDT";
                      listGridHome[3].valuePercent =
                          Cr.format(double.parse(item['P'].toString())) + "%";
                      listGridHome[3].chartColor =
                          double.parse(item['P'].toString()) > 0
                              ? Color(0xFF00C087)
                              : Colors.redAccent;
                      listGridHome[3].chartColorGradient =
                          double.parse(item['P'].toString()) > 0
                              ? [
                                  Colors.greenAccent.withOpacity(0.2),
                                  Colors.greenAccent.withOpacity(0.01)
                                ]
                              : [
                                  Colors.redAccent.withOpacity(0.2),
                                  Colors.redAccent.withOpacity(0.01)
                                ];

                      listGridHome[3].valueMarket =
                          num.parse(item['c'].toString()).toString();
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listGridHome.length,
                      itemBuilder: (BuildContext context, int index) {
                        return card(context, index);
                      },
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listGridHome.length,
                    itemBuilder: (BuildContext context, int index) {
                      return card(context, index);
                    },
                  );
                }),
          ),

          Expanded(
            child: Container(
              child: DefaultTabController(
                initialIndex:0,
                length: 3,
                child: Card(
                  color: day == false ? Color(0xff181818) : Color(0xffffffff),
                  child: new Scaffold(
                    backgroundColor: day == false ? Color(0xff181818) : Color(0xffffffff),
                    appBar: PreferredSize(
                      preferredSize:
                          Size.fromHeight(20.0), // here the desired height
                      child: Container(
                        color: day == false
                            ? Color(0xff181818)
                            : Color(0xffffffff),
                        child: new AppBar(
                          backgroundColor: day == false
                              ? Color(0xff181818)
                              : Color(0xffffffff),
                          elevation: 0.0,
                          centerTitle: true,
                          flexibleSpace: Container(
                            color: day == false
                                ? Color(0xff181818)
                                : Color(0xffffffff),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                child: new TabBar(
                                  isScrollable: true,

                                  labelPadding: EdgeInsets.all(10),

                                  controller: _tabController,
                                  indicatorColor: Color(0xfff9bf30),
                                  labelColor:
                                      day == false ? Colors.white : Colors.grey,

                                  // indicatorColor: Colors.blue,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decorationThickness: 2,
                                      decorationColor: Color(0xfff9bf30)),

                                  unselectedLabelStyle:
                                      TextStyle(fontWeight: FontWeight.w600),
                                  unselectedLabelColor: day == false ? Colors.white60 : Colors.black45,

                                  indicatorSize: TabBarIndicatorSize.tab,

                                  tabs: [
                                    new Tab(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.whatshot,
                                              size: 15.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 10.0),
                                            child: Text(
                                              "Hot",
                                              style: TextStyle(
                                                fontFamily: "IBM Plex Sans",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Tab(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.move_up,
                                              size: 15.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 10.0),
                                            child: Text(
                                              "Top Gainers",
                                              style: TextStyle(
                                                fontFamily: "IBM Plex Sans",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Tab(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Icon(
                                              Icons.move_down,
                                              size: 15.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 10.0),
                                            child: Text(
                                              "Top Loser",
                                              style: TextStyle(
                                                fontFamily: "IBM Plex Sans",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          automaticallyImplyLeading: false,
                        ),
                      ),
                    ),
                    body: Container(
                      color:
                          day == false ? Color(0xff181818) : Color(0xffffffff),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: new TabBarView(
                          controller: _tabController,
                          children: [
                            Connection == "nointernet"
                                ? interneterror()
                                : HotDeals(),
                            Connection == "nointernet"
                                ? interneterror()
                                : gainer(),
                            Connection == "nointernet"
                                ? interneterror()
                                : loser(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget card(BuildContext context, int i) {
    double _width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        margin: EdgeInsets.only(bottom: 0),
        child: InkWell(
          onTap: () {},
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: day == false ? Color(0xff181818) : Color(0xffffffff),
            child: Container(
              height: 50.0,
              width: _width / 3.2,
              decoration: BoxDecoration(
                  color: day == false ? Color(0xff181818) : Color(0xffffffff),
                  borderRadius: BorderRadius.circular(5)),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              listGridHome[i].name,
                              style: TextStyle(
                                  color: day == false
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: "IBM Plex Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.0),
                            ),
                            Text(
                              listGridHome[i].valuePercent,
                              style: TextStyle(
                                  color: listGridHome[i].chartColor,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            listGridHome[i].valueMarket,
                            style: TextStyle(
                                color: listGridHome[i].chartColor,
                                fontFamily: "IBM Plex Sans",
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50.0,
                      child: new Sparkline(
                        data: listGridHome[i].data,
                        lineWidth: 0.3,
                        fillMode: FillMode.below,
                        lineColor: listGridHome[i].chartColor,
                        fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: listGridHome[i].chartColorGradient,
                        ),
                      ),
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
}

class cardLoading extends StatelessWidget {
  gridHome item;

  cardLoading(this.item);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: ((BuildContext context, int index) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 3.0, bottom: 3.0, right: 5, left: 5),
          child: Container(
            color: Colors.white60,
            height: 180.0,
            width: 100,
            child: Shimmer.fromColors(
              baseColor: Colors.blueGrey,
              highlightColor: Colors.white54,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).hintColor,
                          height: 20.0,
                          width: 70.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 17.0,
                                  width: 70.0,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Theme.of(context).hintColor,
                                  height: 17.0,
                                  width: 70.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Widget _loadingCardAnimation(BuildContext context) {
  return cardLoading(listGridHome[1]);
}

Widget _loadingCardAnimationfirst(BuildContext context) {
  return cardLoadingfirst();
}

class cardLoadingfirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          const EdgeInsets.only(top: 3.0, bottom: 3.0, right: 25, left: 25),
      child: Container(
        // color: Colors.white,
        height: 80.0,
        width: 100,
        child: Shimmer.fromColors(
            baseColor: Colors.blueGrey,
            highlightColor: Colors.white54,
            child: Card(
              color: Color(0xfff9bf30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white38)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white54,
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.white38,
                            offset: Offset(5, 5),
                            blurRadius: 10)
                      ]),
                  child: Container(
                    alignment: Alignment.center,
                    height: 150,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
