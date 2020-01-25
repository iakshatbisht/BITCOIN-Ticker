import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';
import 'package:http/http.dart' as http;


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String select = 'USD';
 /* double btcLast;
  double ethLast;
  double ltcLast;
  String btcText = '?';
  String ethText = '?';
  String ltcText = '?';*/

 //ANDROID PART
  DropdownButton<String> dropDownButton() {
    List<DropdownMenuItem<String>> d_items=[];
    for(int i=0;i<currenciesList.length; i++) {
      var ddi = DropdownMenuItem(child: Text(currenciesList[i]), value: currenciesList[i]);
      d_items.add(ddi);
    }
   return DropdownButton<String>(
      items: d_items,
      value: select,
      onChanged: (value) {
        setState(() {
          getData();
          select = value;
        });
      },
    );
  }
//IOS PART
  CupertinoPicker iosPicker(){
    List<Text> p_items =[];
    for(String currency in currenciesList) {
      p_items.add(Text(currency));
    }
    return CupertinoPicker(
      useMagnifier: true,
      diameterRatio: 100,
      itemExtent: 32.0,
      onSelectedItemChanged: (index){
        print(index);
        setState(() {
          getData();
          select = currenciesList[index];
        });
        },
      children: p_items,
      backgroundColor: Colors.lightBlue,
    );
  }

  Map<String, String> coinValues ={};
  bool isWaiting = false;

  void getData() async {
  isWaiting =true;
    try {
      var data = await CoinData().getLast(select);
     isWaiting = false;
      setState(() {
       coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: select,
          value: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
         makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS? iosPicker(): dropDownButton(),
          ),
        ],
       ),
    );
  }
}


class CryptoCard extends StatelessWidget {
const CryptoCard({
this.value,
this.selectedCurrency,
this.cryptoCurrency,
});

final String value;
final String selectedCurrency;
final String cryptoCurrency;

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
    child: Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
}