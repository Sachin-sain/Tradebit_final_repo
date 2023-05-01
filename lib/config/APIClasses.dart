// ignore_for_file: non_constant_identifier_names

class APIClasses {
  static String currencyget = "/list-crypto/get";
  static String LBM_BaseURL = 'tradehit.io'; //
  static String Local_NodeUrl = 'http://192.168.29.8:'; //
  static String NODELBM_BaseURL = 'api.tradehit.io'; //
  static String websocket_url = 'wss://node.tradehit.io/';

  ///REGISTERATION
  static String LBM_register = '/backend/public/api/register'; //
  static String LBM_emailotp = '/backend/public/api/validateotp';
  static String LBM_phoneotp = '/backend/public/api/validateotp/mobile/'; //later
  static String LBM_resendotp = '/backend/public/api/resendotp'; //
  static String LMB_qr        =  '/verify-qr-code';


  ///LOGIN
  static String LBM_login = '/backend/public/api/login'; //
  static String LBM_emailverify = '/backend/public/api/validateotp'; //
  static String LBM_phoneverify = '/backend/public/api/register/verify'; //later
  static String LBM_forgetpassword = '/backend/public/api/forgotpassword'; //
  static String termconditions = '/backend/public/api/get';

  ///Wallet
  static String Crypto_Data = '/user-crypto/get';
  static String Deposithistory = '/backend/public/api/deposit/get';
  static String Wallethistory = '/backend/public/api/wallet-trans/get';
  static String withdraw = '/backend/public/api/block/transfer';
  static String Validatewalletotp = "/backend/public/api/block/validateotpWith";

  ///buy/sell
  static String buy = '/orders/place-order';

  //orderHistory
  static String ordertradehistory = '/list-crypto/trade-history/';

  ///History
  static String OpenData = '/orders/get';
  static String completeOrderDetail = '/orders/getOrderDetail';
  static String WalletTranData = '/backend/public/api/wallet-trans/get';
  static String cancelorder = '/backend/public/orders/cancel-order/';
  static String addtofav = '/backend/public/api/favourite/create';
  static String getaddtofav = '/favpair/get';
  static String deladdtofav = '/backend/public/api/favourite/delete/';
  static String INRrate = '/get-currency-price';

  ///Own Currency
  static String order = '/orders/order-book';
  static String ownorderHistory = '/orders/trade-book';
  static String openorder = '/list-crypto/market-data/';

  ///SETTING
  static String authverify = '/api/2fa/update';
  static String authverifyget = '/api/2fa/get';
  static String kyc_verify = '/user-kyc/get'; //
  static String logGet = '/api/log/get';
  static String kycupdate = '/api/userkyc/create'; //
  static String notification = '/backend/public/api/notification/get';
  static String referrallink = '/backend/public/api/user/getReferrals'; //
  static String ticket_create = '/api/ticket/create';
  static String ticket_view = '/api/ticket/get';
  static String get_Category = '/api/ticket_type/get';
  static String get_Comments = '/api/ticket/get/';
  static String create_Comments = '/api/ticket_comment/create';

  ///Fav
  static String favGet = '/favpair/get';
  static String banners = '/backend/public/api/banner/get';

  /// LOG OUT
  static String logout = '/backend/public/api/logout'; //
  static String logoutall = '/backend/public/api/hardlogout'; //
  static String passwordvalid = '/backend/public/api/password/valid'; //
  static String change_pass = '/backend/public/api/user/change_password'; //
  static String pass_reset = '/backend/public/api/password/reset'; //

  /// Launchpad
  static String launchpad = '/launchpad/token_get';
  static String launchpadOrderPlace = '/launchpad/order_place';
}
