import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/coin_model.dart';

const List<String> currenciesList = [
  'AUD', 'BRL', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'IDR', 'ILS',
  'INR', 'JPY', 'MXN', 'NOK', 'NZD', 'PLN', 'RON', 'RUB', 'SEK', 'SGD', 'USD', 'ZAR'
];

const List<String> cryptoList = [
  'BTC/Bitcoin', 'ETH/Ethereum', 'LTC/Litecoin',
];

class CoinData {
  Future<List<CoinModel>> getCoinData(String currency) async {
    List<CoinModel> cryptoPrices = [];
    try {
      for (String crypto in cryptoList) {
        final String cryptoSymbol = crypto.split('/')[0];
        final String url = '$kBaseURL/$cryptoSymbol/$currency';

        final response = await http.get(
          Uri.parse(url),
          headers: {'X-CoinAPI-Key': kAPIKey},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          double price = data['rate'];

          cryptoPrices.add(CoinModel(
            icon: cryptoSymbol.toLowerCase(),
            name: crypto.split('/')[1],
            price: price,
          ));
        } else {
          print('Failed to fetch data for $cryptoSymbol: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return cryptoPrices;
  }
}
