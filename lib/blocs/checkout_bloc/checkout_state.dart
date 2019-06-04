// import 'package:barcode_scanner/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckoutState extends Equatable {
  CheckoutState([List props = const []]) : super(props);
}

class AwaitingBarcodes extends CheckoutState {}

class Processing extends CheckoutState{}

class HasPrices extends CheckoutState{
  final List<CheckoutData> productData;
  final double totalPrice;

  HasPrices({this.productData, this.totalPrice}):super([productData, totalPrice]);
}

class Error extends CheckoutState{}
