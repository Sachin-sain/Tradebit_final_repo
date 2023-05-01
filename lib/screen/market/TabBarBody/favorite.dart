// ignore_for_file: camel_case_types, non_constant_identifier_names, missing_return

import 'dart:async';
import 'dart:convert';
import 'package:exchange/config/APIClasses.dart';
import 'package:exchange/config/APIMainClass.dart';
import 'package:exchange/config/SharedPreferenceClass.dart';
import 'package:exchange/config/ToastClass.dart';
import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/intro/login.dart';
import 'package:exchange/screen/market/detailCrypto/btcDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
Map<String, dynamic> btcMarketList;

class favorite extends StatefulWidget {
  final Widget child;

  favorite({Key key, this.child}) : super(key: key);

  _favoriteState createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  bool isblink = false;
  var subRequest_FAV1 ;
  String Status = 'E';
  List ticker_data1=[];

  String CurrencyName = 'BTC';
  var item;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/a.jpg?alt=media&token=e36bbee2-4bfb-4a94-bd53-4055d29358e2");
  static NumberFormat Cr = new NumberFormat("#,##0.00", "en_US");
  bool loadImage = false;
  List FavList = [];
  String Fav;
  List favdata = [];
  List<FavData> favdatalist = [];
  List currency = [];
  List Favdata=[];
  Map<String,Map<String,List<Map<String,dynamic>>>> Currency_datafetch;
  Map<String,List<Map<String,dynamic>>> Currency_datafetchlist;
  List<Map<String,List<Map<String,dynamic>>>> Currency_data=[];
  String fsyms='';
  String status;
  bool cancel= false;
  @override
  void initState() {
    checkstatus();

    super.initState();
  }
  checkstatus() async{
    status= await SharedPreferenceClass.GetSharedData("isLogin");
    if(status=="true"){
      // addtofav();
      BTCAPI();

    }else{
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new login()));
    }
  }


  Future<void> addtofav() async {
    final paramDic = {
      "": '',

    };
    var response = await APIMainClassbinance(
        APIClasses.getaddtofav, paramDic, "Get");
    var data = json.decode(response.body);
    favdata.clear();
    favdatalist.clear();
    fsyms='';
    Currency_data.clear();


    if (response.statusCode == 200) {
      favdata.addAll(data['data']);
      print("FAV dATA "+favdata.toString());
      for (int i = 0; i < favdata.length; i++) {
        favdatalist.add(new FavData(
          id: favdata[i]['id'].toString(),
          pair: favdata[i]['currency'].toString().toUpperCase()+favdata[i]['pair_with'].toString().toUpperCase(),
          currency: favdata[i]['currency'].toString().toUpperCase(),
        ));


        if(fsyms==''){
          fsyms=favdata[i]['currency'].toString().toUpperCase();
        }else{
          fsyms=fsyms +","+favdata[i]['currency'].toString().toUpperCase();
        }
        currency.add(favdatalist[i].currency);

        FavList.add("${favdatalist[i].pair.toLowerCase()}@ticker");

        Currency_data.add(
            {favdatalist[i].pair.toUpperCase().toString():[{'currency_name': ''},{'pair': ''}, {'icon': ''}, {'currentprice': 0.0},{'lastprice': 0.0}, {'24chg': 0.0},{'listed':''}]});


      }
      BTCAPI(CurrencyName: 'BTC',fsyms: fsyms);

      // connectToServer();

    }
    else {
      ToastClass.ToastShow(data["message"]);
    }

  }

  var data;

  WebSocketChannel channel_fav = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );


  Future<void> BTCAPI({String CurrencyName,String fsyms}) async {
    final paramDic = {
      "":''

    };
    var response =
    await APIMainClassbinance(APIClasses.favGet, paramDic, "Get");
    data = json.decode(response.body);
    Favdata=data['data'];
    if (data['status_code'] == '1') {


      print("favdata"+Favdata.toString());


      Currency_data.clear();
      // btcMarketList_raw=data['RAW'];
      // btcMarketList_display=data['DISPLAY'];
      //
      //ticker_data.clear();
      for(int i = 0;i<Favdata.length;i++){
        //
        favdatalist.add(new FavData(
            id: Favdata[i]['id'].toString(),
            pair: Favdata[i]['currency'].toString().toUpperCase()+Favdata[i]['pair_with'].toString().toUpperCase(),
            currency: Favdata[i]['price'].toString().toUpperCase(),
            paircurrency: Favdata[i]['pair_with'].toString().toUpperCase()
        ));
        ticker_data1.add(Favdata[i]['currency'].toString().toLowerCase()+Favdata[i]['pair_with'].toString().toLowerCase()+"@ticker");


        Currency_data.add(
            {Favdata[i]['pair_with'].toString().toUpperCase().toString():[{'currency_name': ''},{'pair': ''}, {'icon': ''}, {'currentprice': 0.0},{'lastprice': 0.0}, {'24chg': 0.0},{'vol':0.0}]});
        print("tyuiop");
        print(Currency_data[i][Favdata[i]['pair_with'].toString()][3]['currentprice'].toString());
        Currency_data[i][Favdata[i]['pair_with'].toString()][0]['currency_name']=Favdata[i]['currency'].toString();
        Currency_data[i][Favdata[i]['pair_with'].toString()][1]['pair']=Favdata[i]['pair_with'].toString();
        Currency_data[i][Favdata[i]['pair_with'].toString()][2]['icon']=Favdata[i]['image'].toString();
        Currency_data[i][Favdata[i]['pair_with'].toString()][3]['currentprice']=Favdata[i]['price'].toString();
        Currency_data[i][Favdata[i]['pair_with'].toString()][4]['lastprice']=Favdata[i]['low'].toString();
        Currency_data[i][Favdata[i]['pair_with'].toString()][5]['24chg']=Favdata[i]['change'].toString();
        Currency_data[i][Favdata[i]['pair_with'].toString()][6]['listed']=Favdata[i]['listed'].toString();
      }
      subRequest_FAV1= {
        'method': "SUBSCRIBE",
        'params':ticker_data1,
        'id': 1,
      };
      connectToServer();
      print("servber"+favdatalist.toString());
    } else {

    }


  }


  Future<void> connectToServer() {
    print(": 98 v "+subRequest_FAV1.toString());
    var jsonString =  json.encode(subRequest_FAV1);
    print("check dfata"+jsonString.toString());

    channel_fav.sink.add(jsonString);
  }

  @override
  void dispose() {
    channel_fav.sink.close();
    favdatalist.clear();
    favdata.clear();

    super.dispose();
  }

  Future<void> Deletetofav(String id) async {
    print("IDIDI "+id.toString());
    final paramDic = {
      "": '',
    };
    var response = await LBMAPIMainClass(APIClasses.deladdtofav+id, paramDic, "Delete");
    var data = json.decode(response.body);
    if(data["status_code"]=="1"){
      ToastShowClass.toastShow(context, data['message'].toString(),Colors.blue);
      BTCAPI();
    }
    else{
      ToastShowClass.toastShow(context, data["message"], Colors.red);
    }
  }



  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right:5.0, bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width *0.15),
                    child: Text(
                      "Pair",
                      style: TextStyle(
                          fontSize: 12,
                          color: day==false?Colors.white:Colors.black,
                          fontFamily: "IBM Plex Sans"),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(right: screenSize.width *0.04),
                        child: Container(
                            width: 75.0,
                            child: Text(
                              "Last Price",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: day==false?Colors.white:Colors.black,
                                  fontFamily: "IBM Plex Sans"),
                            )),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(right: screenSize.width *0.00),
                        child: Text(
                          "24h Chg%",
                          style: TextStyle(
                              fontSize: 12,
                              color:day==false?Colors.white:Colors.black,
                              fontFamily: "IBM Plex Sans"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0.0,
            ),
            _dataLoaded(context),
          ],
        ));
  }


  Widget _dataLoaded(BuildContext context) {
    return StreamBuilder(
        stream: channel_fav.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingData(context);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.active) {
            //place your code here. It will prevent double data call.
            item = json.decode(snapshot.hasData ? snapshot.data : '');
            return Container(
              child:Currency_data.length<0?  Center(
                child: Container(
                  child: Text("No Favourite Crypto! \n Let's Select Some Crypto !",style: TextStyle(color: day==false?Colors.white:Colors.black,fontFamily: 'IBM Plex Sans'),),),
              ):
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: Currency_data.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return card(ctx, i);
                },
              ),
            );

          }
          return Center(
            child: Container(
              child: Text("No Favourite Crypto! \n Let's Select Some Crypto !",style: TextStyle(color: day==false?Colors.white:Colors.black,fontFamily: 'IBM Plex Sans'),),),
          );
        });
  }

  Widget card(BuildContext ctx, int i) {
    final screenSize = MediaQuery.of(context).size;

    Status = 'E';

    if (favdatalist[i].pair == item['s']) {
      Favdata[i]['price']= item['c'];
      Currency_data[i][favdatalist[i].paircurrency][3]['currentprice'] = item['c'];
      if (double.parse(Currency_data[i][favdatalist[i].paircurrency][3]['currentprice'].toString()) ==
          double.parse(Currency_data[i][favdatalist[i].paircurrency][4]['lastprice'].toString())) {
        Status = 'E';
        print(Status);

      } else   if (double.parse(Currency_data[i][favdatalist[i].paircurrency][3]['currentprice'].toString()) >
          double.parse(Currency_data[i][favdatalist[i].paircurrency][4]['lastprice'].toString())) {
        Status = 'G';
        print(Status);
      } else {
        Status = 'S';
        print(Status);
      }
      //
      Currency_data[i][favdatalist[i].paircurrency][4]['lastprice'] = item['c'];
      Favdata[i]['change'] =item['P'];


    }
    return Padding(
      padding: const EdgeInsets.only(
          right: 3.0, left: 3.0, top: 8.0, bottom: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                listed=Favdata[i]['listed'].toString();
                selectedPair=Favdata[i]['currency']
                    .toString().toUpperCase() +Favdata[i]['pair_with'].toUpperCase();
                open_order(Favdata[i]['listed']
                    .toString(),Favdata[i]['currency']
                    .toString().toUpperCase() ,Favdata[i]['pair_with'].toUpperCase());
                OrdersHistory(Favdata[i]['listed']
                    .toString(),Favdata[i]['currency']
                    .toString().toUpperCase() ,Favdata[i]['pair_with'].toUpperCase());


                Navigator.of(ctx).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new btcDetail(

                      currency_data:
                      {"currency_name":Favdata[i]['currency'].toString() , "PRICE": Favdata[i]['price'].toString(), "HIGHDAY":"0.0", "LOWDAY": "0.0", "vol":"0.0", "24chg": "0.0","listed":Favdata[i]['listed']
                          .toString()},
                      pair: Favdata[i]['currency'].toString(),
                      familycoin: Favdata[i]['pair_with'],
                    )));
              },
              child: Padding(
                padding:  EdgeInsets.only(top: 8,bottom: 8,right: screenSize.width *0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(left: screenSize.width *0.02, right: screenSize.width *0.02),
                          child: Container(

                            child: Image.network(
                              Favdata[i]['image']==null?"":Favdata[i]['image']
                                  .toString(),
                              height: 25.0,
                              fit: BoxFit.contain,
                              width: 30.0,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset("assets/image/usdt.png", height: 25.0,
                                    fit: BoxFit.contain,
                                    width: 30.0,),

                            ),
                          ),
                        ),
                        Container(
                          width: 95.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    Favdata[i]['symbol']==null?"":Favdata[i]['symbol']
                                        .toString(),
                                    style: TextStyle(
                                        color: day==false?Colors.white:Colors.black,
                                        fontFamily: "IBM Plex Sans", fontSize: 12.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    double.parse(Favdata[i]['change']==null?"":Favdata[i]['change'].toString()
                        .toString()) <
                        0
                        ? Icon(
                      Icons.trending_down,
                      size: 30,
                      color: Colors.redAccent,
                    )
                        : Icon(
                      Icons.trending_up,
                      size: 30,
                      color: Color(0xFF00C087),
                    ),
                    Spacer(),
                    Padding(
                      padding:  EdgeInsets.only(right: screenSize.width *0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                      num.parse(Favdata[i]['price']==null?"":Favdata[i]['price'].toString()).toString(),
                            style: TextStyle(
                                color: Status == 'E'
                                    ? day==false?Colors.white:Colors.black
                                    : Status == "G"
                                    ? Color(0xFF00C087)
                                    : Colors.redAccent,
                                fontFamily: "IBM Plex Sans",
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: screenSize.width *0.03),
                      child: SizedBox(width:3,height: 20,child: VerticalDivider(color: day==false?Colors.white60:Colors.black45,)),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: screenSize.width *0.01),
                      child: Row(
                        children: [

                          SizedBox(
                            width: 5,
                          ),
                          Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Text(
                                  Cr.format(double.parse(
                                      Favdata[i]['change']==null?"":Favdata[i]['change']
                                          .toString())) +
                                      "%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: day==false?Colors.white:Colors.black,),
                                ),
                              )),
                          // SizedBox(
                          //   width: 5,
                          // ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );


  }

  ///
  ///
  /// Calling imageLoading animation for set a grid layout
  ///
  ///
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
                          backgroundColor: Theme
                              .of(ctx)
                              .hintColor,
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
                                    color: Theme
                                        .of(ctx)
                                        .hintColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(
                              height: 12.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(ctx)
                                      .hintColor,
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
                              color: Theme
                                  .of(ctx)
                                  .hintColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 12.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                                color: Theme
                                    .of(ctx)
                                    .hintColor,
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
                        color: Theme
                            .of(ctx)
                            .hintColor,
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

class FSYMS {
  String pair_with;
  FSYMS(this.pair_with);
}
class FavData{
  String pair;
  String id;
  String currency;
  String icon;
  String paircurrency;

  FavData({this.pair,this.id,this.currency,this.icon,this.paircurrency});
}
///
///
/// Calling ImageLoaded animation for set a grid layout
///
///

