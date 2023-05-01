// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../config/SharedPreferenceClass.dart';
import '../../../../config/ToastClass.dart';
import '../Constants/Common.dart';
import 'base_url_&_api.dart';

Future<void> stakingHoilding(page) async {
  String token = await SharedPreferenceClass.GetSharedData("token");
  print("URIII" + "-------------------.toString()" + page.toString());
  final parameters = {
    "per_page": "100",
    "page": page.toString(),
    "plan_type": "",
    'search': "",
  };
  final url =
      Uri.https(StakingApi.baseUrl, StakingApi.My_Holding, parameters);
  final response =
      await http.get(url, headers: {"Authorization": "Bearer $token"});
  print(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status_code'] == '1') {
      print("data[data][data]" + data["data"]["data"].toString());
      StakingCommonClass.My_hlodings.addAll(
          data["data"]["data"]); // tab bar value
      StakingCommonClass.Holding_searchItem =
          data["data"]["data"]; // initial value
      StakingCommonClass.My_hlodings.toSet().toList();
      StakingCommonClass.My_hlodings_lastPage = data["data"]["last_page"];
    } else {
      print('failed$data');
    }
  } else {
    print('failed with statis code == > ${response.statusCode}');
  }
}

Future<void> stakingWallet() async {
  String token = await SharedPreferenceClass.GetSharedData("token");
  print("URIII" + token.toString());
  final parameters = {
    "per_page": "1000",
    "page": "1",
    "plan_type": "",
    'search': "",
  };
  final url = Uri.https(StakingApi.baseUrl, StakingApi.Wallet, parameters);
  final response =
      await http.get(url, headers: {"Authorization": "Bearer $token"});
  print(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status_code'] == '1') {
      StakingCommonClass.My_Wallet = data["data"];
    } else {
      print('failed$data');
    }
  } else {
    print('failed with statis code == > ${response.statusCode}');
  }
}

Future<void> stakingTransaction(page) async {
  String token = await SharedPreferenceClass.GetSharedData("token");
  print("URIII" + token.toString());
  final parameters = {
    "per_page": "1000",
    "page": page.toString(),
    "plan_type": "",
    'search': "",
  };
  final url =
      Uri.https(StakingApi.baseUrl, StakingApi.My_transcation, parameters);
  final response =
      await http.get(url, headers: {"Authorization": "Bearer $token"});
  print(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status_code'] == '1') {
      StakingCommonClass.My_transcation.addAll(data["data"]["data"]);
      StakingCommonClass.My_transcation_lastPage = data["data"]["last_page"];
    } else {
      print('failed$data');
    }
  } else {
    print('failed with statis code == > ${response.statusCode}');
  }
}

Future<void> transfer_to_account(context, amount, currency) async {
  String token = await SharedPreferenceClass.GetSharedData("token");
  print("URIII" + token.toString());
  final parameters = {
    "amount": amount.toString(),
    "currency": currency.toString(),
  };
  print("par " + parameters.toString());
  final url = Uri.https(StakingApi.baseUrl, StakingApi.Transfer_to_account);
  print(url);
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.postUrl(url);
  request.headers.set('content-type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');
  request.add(utf8.encode(json.encode(parameters)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  var data = jsonDecode(reply);
  if (data['status_code'].toString() == '1') {
    ToastShowClass.toastShow(context, data["message"], Colors.blue);
    await stakingWallet();
    Navigator.of(context).pop();
  } else {
    ToastShowClass.toastShow(context, data["message"], Colors.red);
    print("else");
    print(response.statusCode.toString());
  }
}

Future<void> subscribeApi(context, amount, id) async {
  String token = await SharedPreferenceClass.GetSharedData("token");
  print("URIII" + token.toString());
  final parameters = {
    "amount": amount.toString(),
    'staking_plan_id': int.parse(id),
  };
  print(parameters.toString());
  // final url = Uri.parse("https://app.nodeadscoin.com/staking/subscribe");
  final url = Uri.https(StakingApi.baseUrl, StakingApi.subscribe);

  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.postUrl(url);
  request.headers.set('content-type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');
  request.add(utf8.encode(json.encode(parameters)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  var data = jsonDecode(reply);
  if (data['status_code'].toString() == '1') {
    stakingWallet();
    ToastShowClass.toastShow(context, data["message"], Colors.blue);
    Navigator.of(context).pop();
  } else {
    ToastShowClass.toastShow(context, data["message"], Colors.red);
    print("else");
    print(response.statusCode.toString());
  }
}

Future<void> UnsubscribeApi(context, id) async {
  String token = await SharedPreferenceClass.GetSharedData("token");
  print("URIII" + int.parse(id).toString());
  final parameters = {
    "user_stake_id": int.parse(id),
  };
  print(parameters.toString());
  final url = Uri.https(StakingApi.baseUrl, StakingApi.Unsubscribe);
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.putUrl(url);
  request.headers.set('content-type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');
  request.add(utf8.encode(json.encode(parameters)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  print("res" + response.statusCode.toString());
  var data = jsonDecode(reply);
  if (data['status_code'].toString() == '1') {
    ToastShowClass.toastShow(context, data["message"], Colors.blue);
    await stakingHoilding(1);

    Navigator.of(context).pop();
  } else {
    ToastShowClass.toastShow(context, data["message"], Colors.red);
    print("else");
    print(response.statusCode.toString());
  }
}

Future<void> wallet() async {
  String token = await SharedPreferenceClass.GetSharedData("token");

  final paramDic = {"": ""};
  final url =
      Uri.https(StakingApi.baseUrl, StakingApi.Crypto_Data1, paramDic);
  final response =
      await http.get(url, headers: {"Authorization": "Bearer $token"});
  var data = json.decode(response.body);
  if (response.statusCode == 200) {
    StakingCommonClass.Portfilio_bal = data["data"];
  }
}
