import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GetBarcodeDataEvent extends Equatable {
  GetBarcodeDataEvent([List props = const []]) : super(props);
}

class GetData extends GetBarcodeDataEvent{
  final List<Barcode> data;

  GetData({this.data}):super([data]);
}