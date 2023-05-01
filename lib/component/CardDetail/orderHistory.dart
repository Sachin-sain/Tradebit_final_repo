// ignore_for_file: camel_case_types

class orderHistoryModel {
  String date,type,price,amount;
  orderHistoryModel({
    this.type,
    this.price,
    this.amount,
    this.date
  });
}

List<orderHistoryModel> listorderHistoryModel=[];