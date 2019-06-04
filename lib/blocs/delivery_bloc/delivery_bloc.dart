import 'dart:async';
import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data.dart';
import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './delivery.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryDataRepository deliveryDataRepository;
  StreamSubscription _streamSubscription;

  DeliveryBloc({this.deliveryDataRepository}) {
    _streamSubscription = Firestore.instance
        .collection('delivery')
        .snapshots()
        .listen((data) => dispatch(AddToState(snapshot: data)));
    // deliveryDataRepository.getDbStream
    //     .listen((data) => AddToState(snapshot: data));
  }

  @override
  DeliveryState get initialState => InitialDeliveryState();

  @override
  Stream<DeliveryState> mapEventToState(
    DeliveryEvent event,
  ) async* {
    if (event is AddToState) {
      yield* _mapAddToStateToState(event);
    } else if (event is DeleteDeliveryData){
      yield* _mapDeleteDeliveryDataToState(event);
    } else if (event is CompleteOrder){
      yield* _mapCompleteOrderToState(event);
    }
  }

  Stream<DeliveryState> _mapAddToStateToState(AddToState event) async* {
    try {
      List<DeliveryData> data = event.snapshot.documents
          .map((doc) => DeliveryData.fromDb(doc))
          .toList();
      yield data.isEmpty ? InitialDeliveryState() : HasDeliveryData(data: data);
    } catch (e) {
      yield DeliveryError(error: e.toString());
    }
  }

  Stream<DeliveryState> _mapDeleteDeliveryDataToState(DeleteDeliveryData event) async* {
    yield ProcessingDeliveryData();
    await Firestore.instance.collection('delivery').document(event.deliveryData.docId).delete();
  }

  Stream<DeliveryState> _mapCompleteOrderToState(CompleteOrder event) async* {
    // yield ProcessingDeliveryData();
    CollectionReference refCol = Firestore.instance.collection('products');
    WriteBatch batch = Firestore.instance.batch();
    for (var i in event.deliveryData.products) {
      final refCount = (await refCol.where('barcode', isEqualTo: i.barcodeNumber ).getDocuments()).documents.first['count'];
      batch.updateData(refCol.document(i.docId),
          <String, dynamic>{'count': refCount - i.checkoutCount});
    }
    batch.commit();
    // await Firestore.instance.collection('delivery').document(event.deliveryData.docId).delete();
  }

  @override
  void dispose() { 
    _streamSubscription.cancel();
    super.dispose();
  }
}
