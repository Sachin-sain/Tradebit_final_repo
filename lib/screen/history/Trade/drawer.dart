import 'dart:convert';

import 'package:exchange/config/constantClass.dart';
import 'package:exchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {

  final List btcList;
  final List eth;
  final List usdt;
  final List trx;
  final List fav;


  const MyDrawer({Key key, this.btcList, this.eth, this.usdt, this.trx, this.fav}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
 TextEditingController filterController = TextEditingController();
 List <dynamic>filteredCharacterList = [];
 List currency = [];
 List <dynamic> filterList = [];
 bool visible = false;

 void filterText(String searchText) {
   setState(() {
     filteredCharacterList = currency
           .where((character) =>
           character['symbol'].toUpperCase()
               .toString()
               .contains(searchText.toUpperCase()))
           .toList();

   });
 }
 void toggleVisibility() {
   setState(() {
     visible = true;
   });
 }

 @override
  void initState() {
    currency = [...widget.btcList, ...widget.fav, ...widget.trx, ...widget.eth, ...widget.usdt];
   super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DefaultTabController(
        initialIndex: 1,
        length: 5,
        child: Scaffold(
          body: visible ? ListView.separated(
            shrinkWrap: true,
              itemBuilder: (c,i) {
                if(filteredCharacterList.isEmpty) {
                  return Center(
                    child: Text("No data", style: TextStyle(
                        color: day == false
                            ? Colors.white
                            : Color(0xff0a0909),fontSize: 12)),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => bottomNavBar(
                        index: 2,
                        symbol: filteredCharacterList[i]['symbol'],
                        firstTime: false,
                        name: "${filteredCharacterList[i]['currency']}/${filteredCharacterList[i]['pair_with']}",
                        currencyNeed: filteredCharacterList[i]['currency'],
                        currencyPair: filteredCharacterList[i]['pair_with'],
                        price: filteredCharacterList[i]['price'],
                        change: filteredCharacterList[i]['change'],
                      ),));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0,right: 5),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      style: ListTileStyle.drawer,
                      title: Text(filteredCharacterList[i]['symbol'].toString(), style: TextStyle(
                          color: day == false
                              ? Colors.white
                              : Color(0xff0a0909),fontSize: 12))
                    ),
                  ),
                );
              },
              separatorBuilder: (c,i) {
              return Divider(
                color: Colors.grey,
                thickness: 1,
              );
              },
              itemCount: filteredCharacterList.length)
              : TabBarView(
            children: [
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.grey[700],
                      height: 0.5,
                    );
                    },
                  itemCount: widget.fav.length,
                  itemBuilder: (c,i) {
                    if(widget.fav.isEmpty) {
                      return Center(
                        child: Text("No data"),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0,right: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => bottomNavBar(
                              index: 2,
                              symbol: widget.fav[i]['symbol'],
                              firstTime: false,
                              name: "${widget.fav[i]['currency']}/${widget.fav[i]['pair_with']}",
                              currencyNeed: widget.fav[i]['currency'],
                              currencyPair: widget.fav[i]['pair_with'],
                               price: widget.fav[i]['price'],
                              change: widget.fav[i]['change'],
                            ),));
                          });
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          style: ListTileStyle.drawer,
                          title: Row(
                            children: [
                              Text(double.parse(widget.fav[i]['currency'].toString()).toStringAsFixed(4)),
                              Text('/${widget.fav[i]['pair_with'].toString()}',style: TextStyle(fontSize: 11,color: Colors.grey))
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(widget.fav[i]['price'].toString(),style: TextStyle(
                                  color: widget.fav[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                              Text(widget.fav[i]['change'].toString(),style: TextStyle(
                                  color: widget.fav[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.grey[700],
                      height: 0.5,
                    );
                  },
                  itemCount: widget.usdt.length,
                  itemBuilder: (c,i) {
                    return Padding(
                      padding: const EdgeInsets.only(left:5.0,right: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> bottomNavBar(
                              index: 2,
                            symbol: widget.usdt[i]['symbol'],
                            firstTime: false,
                            name: "${widget.usdt[i]['currency']}/${widget.usdt[i]['pair_with']}",
                            currencyNeed: widget.usdt[i]['currency'],
                              currencyPair: widget.usdt[i]['pair_with'],
                              price: widget.usdt[i]['price'],
                              change: widget.usdt[i]['change'],
                            )));
                          });
                          },
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          style: ListTileStyle.drawer,
                          title: Row(
                            children: [
                              Text(widget.usdt[i]['currency'].toString()),
                              Text('/${widget.usdt[i]['pair_with'].toString()}', style: TextStyle(fontSize: 11,color: Colors.grey,))
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(double.parse(widget.usdt[i]['price'].toString()).toStringAsFixed(4),style: TextStyle(
                                  color: widget.usdt[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                              Text(widget.usdt[i]['change'].toString(),style: TextStyle(color: widget.usdt[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ListView.separated(
                itemCount: widget.btcList.length,
                  itemBuilder: (c,i) {
                return Padding(
                  padding: const EdgeInsets.only(left:5,right: 5),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> bottomNavBar(
                          index: 2,
                          symbol: widget.btcList[i]['symbol'],
                          firstTime: false,
                          name: "${widget.btcList[i]['currency']}/${widget.btcList[i]['pair_with']}",
                          currencyNeed: widget.btcList[i]['currency'],
                          currencyPair: widget.btcList[i]['pair_with'],
                          price: widget.btcList[i]['price'],
                          change: widget.btcList[i]['change'],
                        )));
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      style: ListTileStyle.drawer,
                      title: Row(
                        children: [
                          Text(widget.btcList[i]['currency'].toString()),
                          Text('/${widget.btcList[i]['pair_with'].toString()}',style: TextStyle(fontSize: 11,color: Colors.grey),)
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(double.parse(widget.btcList[i]['price'].toString()).toStringAsFixed(4),style: TextStyle(
                              color: widget.btcList[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                          ),),
                          Text(widget.btcList[i]['change'].toString(),style: TextStyle(
                              color: widget.btcList[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                          ),),
                        ],
                      ),
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.grey[700],
                    height: 0.5,
                  );
              },),
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.grey[700],
                      height: 0.5,
                    );
                  },
                  itemCount: widget.eth.length,
                  itemBuilder: (c,i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0,right: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> bottomNavBar(
                              index: 2,
                              symbol: widget.eth[i]['symbol'],
                              firstTime: false,
                              name: "${widget.eth[i]['currency']}/${widget.eth[i]['pair_with']}",
                              currencyNeed: widget.eth[i]['currency'],
                              currencyPair: widget.eth[i]['pair_with'],
                              price: widget.eth[i]['price'],
                              change: widget.eth[i]['change'],
                            )));
                          });
                          },
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          style: ListTileStyle.drawer,
                          title: Row(
                            children: [
                              Text(widget.eth[i]['currency'].toString()),
                              Text('/${widget.eth[i]['pair_with'].toString()}',style: TextStyle(fontSize: 11,color: Colors.grey))
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(double.parse(widget.eth[i]['price'].toString()).toStringAsFixed(4),style: TextStyle(
                                  color: widget.eth[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                              Text(widget.eth[i]['change'].toString(),style: TextStyle(
                                color: widget.eth[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.grey[700],
                      height: 0.5,
                    );
                  },
                  itemCount: widget.trx.length,
                  itemBuilder: (c,i) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0,right: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> bottomNavBar(
                              index: 2,
                              symbol: widget.trx[i]['symbol'],
                              firstTime: false,
                              name: "${widget.trx[i]['currency']}/${widget.trx[i]['pair_with']}",
                              currencyNeed: widget.trx[i]['currency'],
                              currencyPair: widget.trx[i]['pair_with'],
                              price: widget.trx[i]['price'],
                              change: widget.trx[i]['change'],
                            )));
                          });
                          },
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          style: ListTileStyle.drawer,
                          title: Row(
                            children: [
                              Text(widget.trx[i]['currency'].toString()),
                              Text('/${widget.trx[i]['pair_with'].toString()}',style: TextStyle(fontSize: 11,color: Colors.grey)),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(double.parse(widget.trx[i]['price'].toString()).toStringAsFixed(4),style: TextStyle(
                                  color: widget.trx[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                              Text(widget.trx[i]['change'].toString(),style: TextStyle(
                                  color: widget.trx[i]['change'].toString().startsWith('-') ? Colors.red : Colors.green
                              ),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ]
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               SizedBox(height: 50,),
                Text("    Trading",style: TextStyle(color: day == false ? Colors.white : Color(0xff0a0909),fontSize: 18,fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: TextFormField(
                      style: TextStyle(
                        color: day == false
                            ? Colors.white
                            : Color(0xff0a0909),fontSize: 12),
                      cursorColor: Colors.grey,
                      textDirection: TextDirection.ltr,
                      onChanged: (e) {
                          filterText(e);
                          toggleVisibility();
                          },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded,color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 10,left: 10),
                        hintText: 'Search',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 9),
                visible ? SizedBox() : TabBar(
                  labelColor: day == false ? Colors.white : Color(0xff0a0909),
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.only(left: 20, right: 20), tabs: [
                    Tab(text: 'FAV'),
                    Tab(text: 'USDT'),
                    Tab(text: 'BTC'),
                    Tab(text: 'ETH'),
                    Tab(text: 'TRX'),
                  ],
                  ),
              ],
            ),
          ),
          ),
      )
      );
  }
}
