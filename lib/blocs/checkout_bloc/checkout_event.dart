import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckoutEvent extends Equatable {
  CheckoutEvent([List props = const []]) : super(props);
}

class GetPrices extends CheckoutEvent{
  final List<Barcode> barcodes;

  GetPrices({this.barcodes}):super([barcodes]);
}

class CompleteCheckout extends CheckoutEvent{
  final List<CheckoutData> products;

  CompleteCheckout({this.products}):super([products]);
}

class IncreaseCheckoutCount extends CheckoutEvent{
  final CheckoutData product;

  IncreaseCheckoutCount({this.product}):super([product]);
}

class DecreaseCheckoutCount extends CheckoutEvent{
  final CheckoutData product;

  DecreaseCheckoutCount({this.product}):super([product]);
}

class UpdateDb extends CheckoutEvent{}

class Delete extends CheckoutEvent{
  final CheckoutData product;

  Delete({this.product}):super([product]);
}

class ResetCheckoutState extends CheckoutEvent{}