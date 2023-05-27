import '../../../../config/APIClasses.dart';
import '../../../../config/APIMainClass.dart';
import 'asks_bids_response.dart';

class AskAndBids{
  fetchData() async {
    final Symbol = "BTCUSDT";
    final Map<String, String> paramDic = {
      "limit": "20",
    };
    try {
      final response = await APIMainClassbinance(APIClasses.openorder + Symbol, paramDic, "Get");
      if (response?.statusCode == 200) {
        var data= newDataFromJson(response.body);
        return Data(asks: data.data.asks, bids: data.data.bids, lastUpdateId: data.data.lastUpdateId);
      } else {
        throw Exception('Unable to fetch data ');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}