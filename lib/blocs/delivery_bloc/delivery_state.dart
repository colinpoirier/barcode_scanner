import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DeliveryState extends Equatable {
  DeliveryState([List props = const []]) : super(props);
}

class InitialDeliveryState extends DeliveryState {}

class HasDeliveryData extends DeliveryState{
  final List<DeliveryData> data;

  HasDeliveryData({this.data}):super([data]);
}

class DeliveryError extends DeliveryState{
  final String error;

  DeliveryError({this.error}):super([error]);
}

class ProcessingDeliveryData extends DeliveryState{}