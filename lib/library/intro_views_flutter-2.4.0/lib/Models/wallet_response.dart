// To parse this JSON data, do
//
//     final walletResponse = walletResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WalletResponse walletResponseFromJson(String str) => WalletResponse.fromJson(json.decode(str));


class WalletResponse {
  final String statusCode;
  final String statusText;
  final String message;
  final List<Datum> data;
  final String mainTotal;
  final String freezedTotal;

  WalletResponse({
    @required this.statusCode,
    @required this.statusText,
    @required this.message,
    @required this.data,
    @required this.mainTotal,
    @required this.freezedTotal,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"]== null? []: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    mainTotal: json["mainTotal"],
    freezedTotal: json["freezedTotal"],
  );

}

class Datum {
  final String image;
  final int id;
  final String name;
  final String symbol;
  final bool isMultiple;
  final String currencyType;
  final String defaultCNetworkId;
  final bool activeStatusEnable;
  final bool depositEnable;
  final String depositDesc;
  final bool withdrawEnable;
  final String withdrawDesc;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CurrencyNetwork> currencyNetworks;
  final String quantity;
  final String fundQuantity;
  final String stakeQuantity;
  final String freezedBalance;
  final String cPrice;
  final String portfolioShare;
  final String cBal;
  final String fundBal;
  final String stakeBal;
  final String fcBal;

  Datum({
    @required this.image,
    @required this.id,
    @required this.name,
    @required this.symbol,
    @required this.isMultiple,
    @required this.currencyType,
    @required this.defaultCNetworkId,
    @required this.activeStatusEnable,
    @required this.depositEnable,
    @required this.depositDesc,
    @required this.withdrawEnable,
    @required this.withdrawDesc,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.currencyNetworks,
    @required this.quantity,
    @required this.fundQuantity,
    @required this.stakeQuantity,
    @required this.freezedBalance,
    @required this.cPrice,
    @required this.portfolioShare,
    @required this.cBal,
    @required this.fundBal,
    @required this.stakeBal,
    @required this.fcBal,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    isMultiple: json["is_multiple"],
    currencyType: json["currency_type"],
    defaultCNetworkId: json["default_c_network_id"],
    activeStatusEnable: json["active_status_enable"],
    depositEnable: json["deposit_enable"],
    depositDesc: json["deposit_desc"],
    withdrawEnable: json["withdraw_enable"],
    withdrawDesc: json["withdraw_desc"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    currencyNetworks: List<CurrencyNetwork>.from(json["currency_networks"].map((x) => CurrencyNetwork.fromJson(x))),
    quantity: json["quantity"],
    fundQuantity: json["fund_quantity"],
    stakeQuantity: json["stake_quantity"],
    freezedBalance: json["freezed_balance"],
    cPrice: json["c_price"],
    portfolioShare: json["portfolio_share"],
    cBal: json["c_bal"],
    fundBal: json["fund_bal"],
    stakeBal: json["stake_bal"],
    fcBal: json["fc_bal"],
  );

}

class CurrencyNetwork {
  final int id;
  final String currencyNetworkCurrencyId;
  final String networkId;
  final String address;
  final String tokenType;
  final String depositMin;
  final bool depositEnable;
  final String depositDesc;
  final bool withdrawEnable;
  final String withdrawDesc;
  final String withdrawMin;
  final String withdrawMax;
  final String withdrawCommission;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String currencyId;
  final String walletAddress;

  CurrencyNetwork({
    @required this.id,
    @required this.currencyNetworkCurrencyId,
    @required this.networkId,
    @required this.address,
    @required this.tokenType,
    @required this.depositMin,
    @required this.depositEnable,
    @required this.depositDesc,
    @required this.withdrawEnable,
    @required this.withdrawDesc,
    @required this.withdrawMin,
    @required this.withdrawMax,
    @required this.withdrawCommission,
    @required this.type,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.currencyId,
    @required this.walletAddress,
  });

  factory CurrencyNetwork.fromJson(Map<String, dynamic> json) => CurrencyNetwork(
    id: json["id"],
    currencyNetworkCurrencyId: json["currency_id"],
    networkId: json["network_id"],
    address: json["address"],
    tokenType: json["token_type"],
    depositMin: json["deposit_min"],
    depositEnable: json["deposit_enable"],
    depositDesc: json["deposit_desc"],
    withdrawEnable: json["withdraw_enable"],
    withdrawDesc: json["withdraw_desc"],
    withdrawMin: json["withdraw_min"],
    withdrawMax: json["withdraw_max"],
    withdrawCommission: json["withdraw_commission"],
    type: json["type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    currencyId: json["currencyId"],
    walletAddress: json["wallet_address"],
  );

}

