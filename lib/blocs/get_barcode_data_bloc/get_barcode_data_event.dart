import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
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

class UpdateData extends GetBarcodeDataEvent{
  final BarcodeData updatedBarcode;

  UpdateData({this.updatedBarcode}):super([updatedBarcode]);
}

class DeleteData extends GetBarcodeDataEvent{
  final BarcodeData deletedBarcode;

  DeleteData({this.deletedBarcode}):super([deletedBarcode]);
}

class AddToDb extends GetBarcodeDataEvent{
  final List<BarcodeData> data;

  AddToDb({this.data}):super([data]);
}

class AddBlankData extends GetBarcodeDataEvent{
  final BarcodeData blankBarcodeData;

  AddBlankData({this.blankBarcodeData}):super([blankBarcodeData]);
}

class ResetData extends GetBarcodeDataEvent{}