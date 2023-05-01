// ignore_for_file: non_constant_identifier_names

class StakingApi {
  //  https://app.nodeadscoin.com/staking/portfolio-transfer
  //
  static const String baseUrl = 'node.bitqix.io';
  static String LBM_BaseURL = "bitqix.io";
  //api
  static String My_Holding = "/staking/myplans";
  static String My_transcation = "/staking/wallet-transactions";
  static String Transfer_to_account = "/staking/portfolio-transfer";
  static String Wallet = "/staking/stake-wallet";
  static const String staking = '/staking/get';
  static const String subscribe = '/staking/subscribe';
  static const String Unsubscribe = "/staking/unsubscribe";
  static String Crypto_Data1 = '/user-crypto/get';
}
