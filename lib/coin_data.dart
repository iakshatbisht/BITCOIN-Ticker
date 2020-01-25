import 'dart:convert';
import 'package:http/http.dart' as http;
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class CoinData {

  Future getLast(String selectName) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '${url}$crypto$selectName';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        double last = jsonData['last'];
        cryptoPrices[crypto] = last.toStringAsFixed(2);
      } else {
        print(response.statusCode.toString());
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
