// ignore_for_file: camel_case_types, non_constant_identifier_names, unnecessary_statements, unused_element

import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:exchange/component/style.dart';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/library/intro_views_flutter-2.4.0/lib/Models/wallet_response.dart';
import 'package:exchange/screen/history/Transactions.dart';
import 'package:exchange/screen/wallet/tabs/deposit_history.dart';
import 'package:exchange/screen/wallet/tabs/wallet_history.dart';
import 'package:exchange/screen/wallet/walletDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


double currencybal = 0.0;
String selectedbal = '';
double sum = 0.0;
List savedothercryptodata = [];

bool isloaded = false;
String status;

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => new _WalletState();

  ///
  /// time for wave header wallet
  ///
  wallet() {
    timeDilation = 1.0;
  }
}

class _WalletState extends State<Wallet> {
  List crytodata = [];
  bool isSwitched = false;
  List allCurrenciesDatasearch = [];
  List <WalletResponse> datum = [];
  List <Datum> data = [];
  List  network = [];

  double Price = 0.00;
  var item;
  bool switchVal = false;
  bool showDetail = false;
  String inrBalance;
  List nonEmptyList = [];
  List allCurrenciesData = [];

  @override
  void initState() {
    Wakelock.enable();
    // if(savedothercryptodata.length<0)
    //   getCryptoData();
    getdata();
    // checkstatus();

    super.initState();
  }

  WebSocketChannel channel_btc = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );
  static NumberFormat Crone = new NumberFormat("###0.0", "en_US");

  checkstatus() async {
    status = await SharedPreferenceClass.GetSharedData("isLogin");
    setState(() {
      status = status;
      print("BTC API HIT" + status.toString());
    });
  }

  getData() {
    print(savedothercryptodata.toString());
    //inrBalance = inrData['c_bal'];
    setState(() {
      nonEmptyList.addAll(
          savedothercryptodata.where((element) => element['c_bal'] != '0'));
      allCurrenciesDatasearch.addAll(savedothercryptodata);
      allCurrenciesData.addAll(savedothercryptodata);
    });

    // print('inr Data=>' + allCurrenciesData['currency_network']['address'].toString());
  }

  @override
  void dispose() {
    currencybal;
    channel_btc.sink.close();
    super.dispose();
  }

  void onSearchTextChanged(String text) {
    allCurrenciesData.clear();
    if (text.isEmpty) {
      setState(() {
        allCurrenciesData.addAll(allCurrenciesDatasearch);
      });
      return;
    }
    setState(() {
      allCurrenciesData.clear();

      for (int j = 0; j < allCurrenciesDatasearch.length; j++) {
        if (allCurrenciesDatasearch[j]['name'].contains(text.toUpperCase())) {
          setState(() {
            allCurrenciesData.add(allCurrenciesDatasearch[j]);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: day == false ? Colors.black : Colors.white,
        body: Column(
          children: [
            new Stack(
              children: <Widget>[
                ///
                /// Create wave header
                ///
                new waveBody(
                    size: size, xOffset: 0, yOffset: 0, color: Colors.red),
                new Opacity(
                  opacity: 0.9,
                  child: new waveBody(
                    size: size,
                    xOffset: 60,
                    yOffset: 10,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new deposit_history()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffc79509),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Text(
                        'Deposit History',
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: day == false ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new wallet_history()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:Color(0xffc79509),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Withdrawl History',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: day == false ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5),
              child: Card(
                color: day == false ? Colors.white12 : Colors.white,
                child: TextField(
        cursorWidth: 0,
                  cursorHeight: 0,
                  style: TextStyle(
                    color: day == false ? Colors.white : Colors.black,
                  ),
                  onChanged: onSearchTextChanged,
                  decoration: InputDecoration(
                      hintText: 'Search Coin...',

                      hintStyle: TextStyle(
                        color: day == false ? Colors.white60 : Colors.black54,
                      ),
                      filled: true,
                      fillColor: Colors.grey,
                      suffixIcon: Icon(
                        Icons.search,
                        color: day == false ? Colors.white : Colors.black,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                  itemBuilder: (c,i) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> walletDetail(
                          currency: data[i].cPrice,
                          currencySymbol: data[i].symbol,
                          network: network,
                          qty: data[i].quantity,
                        )));
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Container(
                            height: 30,
                              width: 30,
                              child: Image.network(data[i].image)),
                          SizedBox(width: 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[i].name,style: TextStyle(
                                fontWeight: FontWeight.bold,color: day == false ? Colors.white : Color(0xff0a0909)
                              ),),
                              SizedBox(height: 4,),
                              Text(data[i].symbol,style: TextStyle(
                                fontSize: 10,color: day == false ? Colors.white : Color(0xff0a0909)
                              ),),
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[i].quantity,style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909)),),
                              Text("\$ " + double.parse(data[i].cPrice).toStringAsFixed(4),style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909)),),
                            ],
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_forward_ios,color: day == false ? Colors.white : Color(0xff0a0909),size: 18,),
                          SizedBox(width: 20,),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 8,right: 8),
                      height: 0.5,
                        color: day == false ? Colors.white : Color(0xff0a0909)
                    ),
                    SizedBox(height: 15),
                  ],
                );
              })
            ),
          ],
        ));
  }
    getdata() async {
    try {
      final Map<String, String> paramDic = {
        "" : "",
      };
      var response =
      await APIMainClassbinance(APIClasses.Crypto_Data, paramDic, "Get");
      if(response.statusCode == 200) {
        setState(() {
          var n = json.decode(response.body);
       var d =  walletResponseFromJson(response.body);
       datum.add(d);
       data.addAll(d.data);
       network.addAll(n['data'][0]['currency_networks']);
        });
      }
    }catch (e) {
   print(e);
    }
}
  Widget _loadingData(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 20,
        itemBuilder: (ctx, i) {
          return loadingCard(ctx, i);
        },
      ),
    );
  }

  Widget loadingCard(BuildContext ctx, int i) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Shimmer.fromColors(
        baseColor: Color(0xFF3B4659),
        highlightColor: Color(0xFF606B78),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(ctx).hintColor,
                          radius: 13.0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 15.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                    color: Theme.of(ctx).hintColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(
                              height: 12.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(ctx).hintColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 15.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              color: Theme.of(ctx).hintColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 12.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                                color: Theme.of(ctx).hintColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    height: 25.0,
                    width: 55.0,
                    decoration: BoxDecoration(
                        color: Theme.of(ctx).hintColor,
                        borderRadius: BorderRadius.all(Radius.circular(2.0))),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
              child: Container(
                width: double.infinity,
                height: 0.5,
                decoration: BoxDecoration(color: Colors.black12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class waveBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  waveBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _waveBodyState();
  }
}

class _waveBodyState extends State<waveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 185.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated,
                  colors: [Color(0xff17394f), Color(0xff283745)])),
          child: new Container(
            margin: EdgeInsets.only(top: 75.0),
            height: 20.0,
            child: new AnimatedBuilder(
              animation: new CurvedAnimation(
                parent: animationController,
                curve: Curves.easeInOut,
              ),
              builder: (context, child) => new ClipPath(
                child: widget.color == null
                    ? new Container(
                        width: widget.size.width,
                        height: widget.size.height,
                        color: Colors.white.withOpacity(0.25),
                      )
                    : new Container(
                        width: widget.size.width,
                        height: widget.size.height,
                        color: Colors.white.withOpacity(0.9),
                      ),
                clipper: new WaveClipper(animationController.value, animList1),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 180.0),
          height: 5.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                  Theme.of(context).scaffoldBackgroundColor
                ],
                stops: [
                  0.0,
                  1.0
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 70.0),
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            Text(
              totalBalance == null
                  ? "0.00 USDT "
                  : ((double.parse(totalBalance) +
                              double.parse(freezedtotalBalance ?? '0.0'))
                          .toString() +
                      " USDT"),
              //  totalBalance+" USDT" ?? '0'+"USDT",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "IBM Plex Sans",
                  fontSize: 30.0,
                  color: Colors.white),
            ),
            Text(
              freezedtotalBalance == null
                  ? "0 Freezed Balance "
                  : freezedtotalBalance.toString() + " Freezed Balance",
              //  totalBalance+" USDT" ?? '0'+"USDT",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "IBM Plex Sans",
                  fontSize: 16.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              currencybal == null ? "" : "TOTAL PORTFOLIO VALUE",
              style: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  color: colorStyle.grayBackground,
                  fontWeight: FontWeight.w900),
            ),
          ]),
        ),

      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TransactionOrders(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;

  EnterExitRoute({this.enterPage})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                enterPage,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(10.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: enterPage,
                ));
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(5.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}

class currencylist {
  String image;
  String currency;
  String rate;
  String balance;

  currencylist({this.image, this.currency, this.rate, this.balance});
}

class savedcurrencylist {
  String image;
  String currency;
  String rate;
  String balance;
  String address;

  savedcurrencylist(
      {this.image, this.currency, this.rate, this.balance, this.address});
}

class currencylistSingle {
  String image;
  String currency;
  String rate;
  String balance;

  currencylistSingle({this.image, this.currency, this.rate, this.balance});
}

class savedcurrencylistSingle {
  String image;
  String currency;
  String rate;
  String balance;
  String address;

  savedcurrencylistSingle(
      {this.image, this.currency, this.rate, this.balance, this.address});
}
