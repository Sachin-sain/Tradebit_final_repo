// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:exchange/config/APIClasses.dart';
// import 'package:exchange/config/APIMainClass.dart';
// import 'package:flutter/material.dart';
//
// import '../../../config/constantClass.dart';
// import 'package:http/http.dart' as https;
// class price extends StatefulWidget {
//   @override
//   State<price> createState() => _priceState();
//
// }
//
// class _priceState extends State<price> {
//   Future<List<Model>> futureData;
//
//
//   Widget build(BuildContext context) {
//     return FutureBuilder<Model>(
//       future: futureData,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Column(
//               children: snaphot.map((e)=>Text(e.name)).toList()
//           );
//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }
// Future<List<Model>> fetchData() async {
//   final response = await APIMainClassbinance(APIClasses.openorder ,"market-data/BTCUSDT");
//   if (response.statusCode == 200) {
//     return Model.getList(response.body);
//   } else {
//     throw Exception('Unable to fetch products from the REST API');
//   }
// }
//
// class Model {
//   final String name;
//   final String location;
//   final String action_value;
//   final String item;
//
//   Model(this.name, this.location, this.action_value, this.item);
//
//   List<Model> getList(json) {
//     List<Model> tempList = [];
//     json['records'].forEach((model)=> tempList.add(
//         Model(
//             model["name"],
//             model["location"],
//             model["action_value"],
//             model["item"]
//         )
//     )
//     );
//     return tempList;
//   }
// }