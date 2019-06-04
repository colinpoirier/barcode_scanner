import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryData {
  final String address;
  final String city;
  final String name;
  final String phone;
  final String docId;
  final bool isDelivery;
  final List<CheckoutData> products;

  DeliveryData({this.address, this.city, this.name, this.phone, this.docId, this.isDelivery, this.products});

  static DeliveryData fromDb(DocumentSnapshot snapshot) {
    return DeliveryData(
      address: snapshot['address'],
      city: snapshot['city'],
      name: snapshot['name'],
      phone: snapshot['phone'],
      docId: snapshot.documentID,
      isDelivery: snapshot['isDelivery'],
      products: snapshot['products']
          .map((p) => CheckoutData.fromMap(p.cast<String, dynamic>()))
          .toList().cast<CheckoutData>(),
    );
  }
}
