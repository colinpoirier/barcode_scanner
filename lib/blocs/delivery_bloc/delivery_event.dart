import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DeliveryEvent extends Equatable {
  DeliveryEvent([List props = const []]) : super(props);
}

class AddToState extends DeliveryEvent{
  final QuerySnapshot snapshot;

  AddToState({this.snapshot}):super([snapshot]);
}

class DeleteDeliveryData extends DeliveryEvent{
  final DeliveryData deliveryData;

  DeleteDeliveryData({this.deliveryData}):super([deliveryData]);
}

class CompleteOrder extends DeliveryEvent{
  final DeliveryData deliveryData;

  CompleteOrder({this.deliveryData}):super([deliveryData]);
}