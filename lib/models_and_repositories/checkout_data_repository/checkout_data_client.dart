import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutDataClient{
  Future<List<CheckoutData>> getDbData() async{
    final docs = await Firestore.instance.collection('products').getDocuments();
    return docs.documents.map((document)=>CheckoutData.fromDb(document)).toList();
  }
}