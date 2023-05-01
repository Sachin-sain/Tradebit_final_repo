// ignore_for_file: non_constant_identifier_names, must_call_super, camel_case_types

import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'DepositDetail.dart';

class Deposit extends StatefulWidget {
  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  List DepositCrypto = [];
  List<crypto> DepositCryptos = [];
  bool datafetched = false;
  bool save = false;

  final scaffoldState = GlobalKey<ScaffoldState>();
  List allCurrenciesData = [];
  List allCurrenciesDatasearch = [];

  @override
  initState() {
    getData();
  }

  getData() {
    print(savedothercryptodata.toString());

    allCurrenciesDatasearch.addAll(savedothercryptodata);
    allCurrenciesData.addAll(savedothercryptodata);
    // print('inr Data=>' + allCurrenciesData['currency_network']['address'].toString());
    print('inr Balance=>' + allCurrenciesData.toString());
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: day == false ? Colors.black : Colors.white,
        title: Text("Deposit",
            style: TextStyle(
              fontFamily: "IBM Plex Sans",
              color: day == false ? Colors.white : Colors.black,
            )),
      ),
      backgroundColor: day == false ? Colors.black : Colors.white,
      key: scaffoldState,
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            color: day == false ? Colors.white12 : Colors.white,
            child: TextField(
              cursorHeight: 0,
              cursorWidth: 0,
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
          SizedBox(
            height: 10,
          ),
          Expanded(
            // height: 50,
            // width: MediaQuery.of(context).size.width,
            // color: Colors.red,
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: allCurrenciesData.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => new DepositDetail(
                                      network: allCurrenciesData[i]
                                          ['currency_networks'],
                                      name: allCurrenciesData[i]['name'],
                                    )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 12,
                                        child: allCurrenciesData[i]['image'] ==
                                                ""
                                            ? Image.asset(
                                                'assets/image/usdt.png',
                                                height: 25.0,
                                                fit: BoxFit.contain,
                                                width: 25.0,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  "assets/image/usdt.png",
                                                  height: 22.0,
                                                  fit: BoxFit.contain,
                                                  width: 22.0,
                                                ),
                                              )
                                            : Image.network(
                                                allCurrenciesData[i]['image'],
                                                height: 25.0,
                                                fit: BoxFit.contain,
                                                width: 25.0,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  "assets/image/usdt.png",
                                                  height: 22.0,
                                                  fit: BoxFit.contain,
                                                  width: 22.0,
                                                ),
                                              ),
                                      ),
                                    ),
                                    Text(
                                      allCurrenciesData[i]['name'] == null
                                          ? '-'
                                          : allCurrenciesData[i]['name'],
                                      style: TextStyle(
                                          color: day == false
                                              ? Colors.white
                                              : Color(0xff17394f),
                                          fontFamily: "IBM Plex Sans",
                                          fontSize: 14.5),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 19.0,
                                  color: day == false
                                      ? Colors.white
                                      : Color(0xff17394f),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 20.0, top: 6.0),
                          child: Container(
                            width: double.infinity,
                            height: 0.5,
                            decoration: BoxDecoration(color: Colors.white54),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget loadingCard(BuildContext ctx, int i) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Shimmer.fromColors(
        baseColor: Color(0xFF3B4659),
        highlightColor: Color(0xff176980),
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

class crypto {
  String image;
  String currency;
  String rate;
  String balance;
  String address;
  crypto({this.image, this.currency, this.rate, this.balance, this.address});
}
