import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryDataClient {
  Future<List<DeliveryData>> getDbData() async {
    final docs = await Firestore.instance.collection('delivery').getDocuments();
    return docs.documents
        .map((document) => DeliveryData.fromDb(document))
        .toList();
  }

  Stream<QuerySnapshot> get getDbStream =>
      Firestore.instance.collection('delivery').snapshots();
}
