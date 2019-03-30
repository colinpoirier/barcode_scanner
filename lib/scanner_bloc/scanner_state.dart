import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScannerState extends Equatable {
  ScannerState([List props = const []]) : super(props);
}

class AwaitingScan extends ScannerState {}

class Scanning extends ScannerState{}

class Scanned extends ScannerState{
  final  List<Barcode> barcodes;

  Scanned({this.barcodes}):super([barcodes]);

}

class ScanError extends ScannerState{}
