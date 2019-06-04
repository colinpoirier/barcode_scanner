import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckoutScannerState extends Equatable {
  CheckoutScannerState([List props = const []]) : super(props);
}

class AwaitingScan extends CheckoutScannerState {}

class Scanning extends CheckoutScannerState{}

class Scanned extends CheckoutScannerState{
  final  List<Barcode> barcodes;

  Scanned({this.barcodes}):super([barcodes]);
}

class ScanError extends CheckoutScannerState{}
