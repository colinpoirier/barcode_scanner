import 'dart:convert';

import 'package:barcode_scanner/barcode_data_repository/barcode_data.dart';
import 'package:http/http.dart' as http;

class BarcodeDataClient{
  final String baseUrl = 'https://api.barcodelookup.com/v2';
  final String apiKey = 'wt3mhzxr22lds4xnd81my2nskaq4aw';
  final http.Client httpClient;

  BarcodeDataClient({this.httpClient});

  Future<BarcodeData> getBarcodeData(String data) async{

    final String productUrl = '$baseUrl/products?barcode=$data&formatted=y&key=$apiKey';
    final response = await httpClient.get(productUrl);
    if(response.statusCode != 200){
      throw Exception('Request Failed');
    }
    final barcodeData = jsonDecode(response.body);
    return BarcodeData.fromJson(barcodeData);
  }
}