
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data_client.dart';

class BarcodeDataRepository{
  final BarcodeDataClient barcodeDataClient;

  BarcodeDataRepository({this.barcodeDataClient});
  
  // Future<BarcodeData> getData(String data) async {
  //   return barcodeDataClient.getBarcodeData(data);
  // }

  Future<BarcodeData> getSiteData(String data) async{
    return barcodeDataClient.getBarcodeDataFromSite(data);
  }
}