import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CheckoutData extends Equatable {
  final double price;
  final int count;
  final int checkoutCount;
  final String barcodeNumber;
  final String productName;
  final String brand;
  final String category;
  final String docId;

  CheckoutData(
      {this.count,
      this.checkoutCount,
      this.price,
      this.barcodeNumber,
      this.productName,
      this.category,
      this.brand,
      this.docId
      })
      : super([
          count,
          checkoutCount,
          price,
          barcodeNumber,
          productName,
          category,
          brand,
          docId,
        ]);

  static CheckoutData fromDb(DocumentSnapshot product) {
    return CheckoutData(
      docId: product.documentID,
      count: product.data['count'],
      checkoutCount: 1,
      price: product.data['price'],
      barcodeNumber: product.data['barcode'],
      brand: product.data['brand'],
      category: product.data['category'],
      productName: product.data['name'],
    );
  }
  static CheckoutData fromMap(Map product) {
    return CheckoutData(
      docId: product['docId'],
      count: product['count'],
      checkoutCount: product['checkoutCount'],
      price: product['price'],
      barcodeNumber: product['barcode'],
      brand: product['brand'],
      category: product['category'],
      productName: product['name'],
    );
  }

  static Map toMap(CheckoutData checkoutData) => {
        'barcode': checkoutData.barcodeNumber,
        'count': checkoutData.count,
        'price': checkoutData.price,
        'brand': checkoutData.brand,
        'name': checkoutData.productName,
        'category': checkoutData.category,
      };

  CheckoutData copyWith({
    double price, 
    int count,
    int checkoutCount,
    String barcodeNumber,
    String productName,
    String brand,
    String category,
    String docId,
    })=> CheckoutData(
      price: price ?? this.price,
      category: category ?? this.category,
      checkoutCount: checkoutCount ?? this.checkoutCount,
      count: count ?? this.count,
      barcodeNumber: barcodeNumber ?? this.barcodeNumber,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      docId: docId ?? this.docId
    );
}
