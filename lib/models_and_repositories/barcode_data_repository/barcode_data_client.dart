// import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:html_unescape/html_unescape_small.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class BarcodeDataClient {
  // final String baseUrl = 'https://api.barcodelookup.com/v2';
  // final String apiKey = 'wt3mhzxr22lds4xnd81my2nskaq4aw';
  final http.Client httpClient;

  BarcodeDataClient({this.httpClient});

  // Future<BarcodeData> getBarcodeData(String data) async {
  //   final String productUrl =
  //       '$baseUrl/products?barcode=$data&formatted=y&key=$apiKey';
  //   final response = await httpClient.get(productUrl);

  //   if (response.statusCode != 200) throw Exception('Request Failed');

  //   final barcodeData = jsonDecode(response.body);
  //   return BarcodeData.fromJson(barcodeData);
  // }

  Future<BarcodeData> getBarcodeDataFromSite(String data) async {
    try {
      HtmlUnescape unescape = HtmlUnescape();
      final response =
          await httpClient.get('https://www.barcodelookup.com/$data');

      if (response.statusCode != 200) throw Exception('Failed');

      var htmlParse = parse.parse(response.body);

      String decodeToString(String id) {
        return unescape.convert(htmlParse.getElementById(id).parent.innerHtml);
      }

      String image = decodeToString('img_preview');
      String brand = decodeToString('brand');
      String name = decodeToString('productName');
      String category = decodeToString('category');
      // String manufacuturer = decodeToString('manufacturer');

      RegExp expImg = RegExp(r'img src="(.*?)"');
      RegExp expVal = RegExp(r'value="(.*?)"');

      final imgResponse =
          await httpClient.get(expImg.firstMatch(image).group(1));

      if (imgResponse.statusCode != 200) throw Exception('Failed');

      print(imgResponse.bodyBytes.length);

      final imgBytes = await FlutterImageCompress.compressWithList(
          imgResponse.bodyBytes,
          minHeight: 600,
          minWidth: 600,
          quality: 90
          );
      
      // final thumbnailBytes = await FlutterImageCompress.compressWithList(
      //     imgResponse.bodyBytes,
      //     minHeight: 600,
      //     minWidth: 600,
      //     quality: 90
      //     );

      print(Uint8List.fromList(imgBytes).length);

      final barcodeDatafromList = BarcodeData.fromList([
        expVal.firstMatch(name).group(1),
        expVal.firstMatch(brand).group(1),
        // expVal.firstMatch(manufacuturer).group(1),
        expVal.firstMatch(category).group(1),
        // expImg.firstMatch(image).group(1),
        Uint8List.fromList(imgBytes),
        // Uint8List.fromList(thumbnailBytes),
        data,
      ]);
      return barcodeDatafromList;
    } catch (_) {
      return BarcodeData.onlyBarcode(barcodeNumber: data);
    }
    // return BarcodeData.fromList([
    //   expVal.firstMatch(name).group(1),
    //   expVal.firstMatch(brand).group(1),
    //   expVal.firstMatch(manufacuturer).group(1),
    //   expVal.firstMatch(category).group(1),
    //   expImg.firstMatch(image).group(1),
    //   imgBytes,
    //   data,
    // ]);
  }
}
