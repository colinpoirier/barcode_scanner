import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data.dart';
import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryDataRepository{
  final DeliveryDataClient deliveryDataClient;

  DeliveryDataRepository({this.deliveryDataClient});
  
  Future<List<DeliveryData>> getDbData() async {
    return deliveryDataClient.getDbData();
  }

  Stream<QuerySnapshot> get getDbStream => deliveryDataClient.getDbStream;
}