

// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../share_preference.dart';


// class ThemeNotifier with ChangeNotifier {
//   final darkTheme = ThemeData(
//       brightness: Brightness.dark,
//       iconTheme: IconThemeData(color: Colors.white),
//       backgroundColor: Color(0xff011021),
//       textTheme: TextTheme(
//           bodyText1: TextStyle(color: Colors.white),
//           bodyText2: TextStyle(color: Colors.black)
//       )
//   );

//   final lightTheme = ThemeData(
//       brightness: Brightness.light,
//       backgroundColor: Color(0xffFCFCFC),
//       iconTheme: IconThemeData(color: Colors.black),
//       textTheme: TextTheme(
//         bodyText1: TextStyle(color: Colors.black),
//         bodyText2: TextStyle(color: Colors.white),
//       )
//   );

//   ThemeData _themeData = ThemeData.light();
//   ThemeData getTheme() =>_themeData;

//   ThemeNotifier(){
//     StorageManag.readData("themeMode").then((value){
//       var themeMode = value ??"dark";
//       if(themeMode == "light"){
//         _themeData = lightTheme;
//       }else{
//         _themeData = darkTheme;
//       }
//       notifyListeners();
//     });
//   }
//   void setDarkMode(){
//     _themeData =darkTheme;
//     StorageManag.SaveData('themeMode',"dark");
//     notifyListeners();
//   }

//   void setLightMode(){
//     _themeData = lightTheme;
//     StorageManag.SaveData("themeMode","light");
//     notifyListeners();
//   }
// }