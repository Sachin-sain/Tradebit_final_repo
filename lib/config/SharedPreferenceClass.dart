// ignore_for_file: non_constant_identifier_names, missing_return, deprecated_member_use

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceClass{

  //Save the data in Shared preference
  static Future<String> SetSharedData(String SPKey ,String SPData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SPKey, SPData);
  }
//Get the data that save in Shared preference
  static Future<String> GetSharedData(String SPKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(SPKey);
  }

  //Remove the data that save in Shared preference
  static RemoveSharedData(String SPKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(SPKey);
  } static RemoveAllSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.commit();
  }
}