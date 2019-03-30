import 'package:barcode_scanner/barcode_data_repository/barcode_data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GetBarcodeDataState extends Equatable {
  GetBarcodeDataState([List props = const []]) : super(props);
}

class AwaitingData extends GetBarcodeDataState {}

class GettingData extends GetBarcodeDataState{}

class HasData extends GetBarcodeDataState{
  final BarcodeData data;

  HasData({this.data}):super([data]);
}

class ErrorGettingData extends GetBarcodeDataState{}
