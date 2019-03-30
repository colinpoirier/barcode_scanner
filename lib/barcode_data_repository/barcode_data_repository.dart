import 'package:barcode_scanner/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/barcode_data_repository/barcode_data_client.dart';

class BarcodeDataRepository{
  final BarcodeDataClient barcodeDataClient;

  BarcodeDataRepository({this.barcodeDataClient});
  
  Future<BarcodeData> getData(String data) async {
    return barcodeDataClient.getBarcodeData(data);
  }
}