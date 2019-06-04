import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data_client.dart';

class CheckoutDataRepository{
  final CheckoutDataClient checkoutDataClient;

  CheckoutDataRepository({this.checkoutDataClient});
  
  Future<List<CheckoutData>> getDbData() async {
    return checkoutDataClient.getDbData();
  }
}