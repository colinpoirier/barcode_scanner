import 'dart:async';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data_repository.dart';
import 'package:barcode_scanner/blocs/scanner_bloc/scanner.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import './get_barcode_data.dart';

class GetBarcodeDataBloc
    extends Bloc<GetBarcodeDataEvent, GetBarcodeDataState> {
  final ScannerBloc scannerBloc;
  StreamSubscription scannerBlocSubscription;
  final BarcodeDataRepository barcodeDataRepository;

  GetBarcodeDataBloc({this.scannerBloc, this.barcodeDataRepository}) {
    scannerBlocSubscription = scannerBloc.state.listen((state) {
      if (state is Scanned) {
        dispatch(GetData(data: state.barcodes));
      }
    });
  }

  @override
  GetBarcodeDataState get initialState => AwaitingData();

  @override
  Stream<GetBarcodeDataState> mapEventToState(
    GetBarcodeDataEvent event,
  ) async* {
    if (event is GetData) {
      yield* _mapGetDataToState(event, currentState);
    } else if (event is UpdateData) {
      yield* _mapUpdateDataToState(event, currentState);
    } else if (event is DeleteData) {
      yield* _mapDeleteDataToState(event, currentState);
    } else if (event is AddToDb) {
      yield* _mapAddToDbToState(event);
    } else if (event is AddBlankData) {
      yield* _mapAddBlankDataToState(event, currentState);
    } else if (event is ResetData) {
      yield* _mapResetDataToState();
    }
  }

  Stream<GetBarcodeDataState> _mapGetDataToState(
      GetData event, GetBarcodeDataState state) async* {
    yield GettingData();
    try {
      List<BarcodeData> barcodeList = state is HasData ? state.data : [];
      final BarcodeData barcodeData =
          // await barcodeDataRepository.getData(event.data[0].rawValue);
          await barcodeDataRepository.getSiteData(event.data[0].rawValue);
      barcodeList.insert(0, barcodeData);
      yield HasData(data: barcodeList);
    } catch (_) {
      yield ErrorGettingData();
    }
  }

  Stream<GetBarcodeDataState> _mapUpdateDataToState(
      UpdateData event, GetBarcodeDataState state) async* {
    if (state is HasData) {
      final List<BarcodeData> updatedBarcodes = state.data.map((barcode) {
        return barcode.barcodeNumber == event.updatedBarcode.barcodeNumber
            ? event.updatedBarcode
            : barcode;
      }).toList();
      yield HasData(data: updatedBarcodes);
    }
  }

  Stream<GetBarcodeDataState> _mapDeleteDataToState(
      DeleteData event, GetBarcodeDataState state) async* {
    if (state is HasData) {
      final List<BarcodeData> updatedBarcodes = state.data
          .where((data) =>
              data.barcodeNumber != event.deletedBarcode.barcodeNumber)
          .toList();
      yield HasData(data: updatedBarcodes);
    }
  }

  Stream<GetBarcodeDataState> _mapAddToDbToState(AddToDb event) async* {
    try {
      yield GettingData();
      CollectionReference colRef = Firestore.instance.collection('products');
      FirebaseStorage storage = FirebaseStorage(
          storageBucket: 'gs://barcodescanner-a1682.appspot.com');
      WriteBatch batch = Firestore.instance.batch();
      final docRefs = <DocumentReference>[];
      for (BarcodeData i in event.data){
        final docRef = colRef.document();
        batch.setData(docRef, BarcodeData.toMap(i));
        docRefs.add(docRef);
      }
      await batch.commit();

      for(BarcodeData i in event.data){
        final sRef = storage.ref().child('${docRefs[event.data.indexOf(i)].documentID}.jpg');
        await sRef.putData(i.imageBytes, StorageMetadata(contentType: 'image/jpg')).onComplete;
        // docRefs.removeAt(0);
      }
      // for (BarcodeData i in event.data) {
      //   final docref = await colRef.add(BarcodeData.toMap(i));
      //   final sref = storage.ref().child('${docref.documentID}.jpg');
      //   await sref.putData(i.imageBytes, StorageMetadata(contentType: 'image/jpg',)).onComplete;
      // }
      yield AwaitingData();
    } catch (e) {
      print(e);
      yield HasData(data: event.data);
    }
  }

  Stream<GetBarcodeDataState> _mapAddBlankDataToState(
      AddBlankData event, GetBarcodeDataState state) async* {
    List<BarcodeData> barcodeList = state is HasData ? state.data : [];
    barcodeList.insert(0, event.blankBarcodeData);
    yield HasData(data: barcodeList);
  }

  Stream<GetBarcodeDataState> _mapResetDataToState() async* {
    yield AwaitingData();
  }

  @override
  void dispose() {
    scannerBlocSubscription.cancel();
    super.dispose();
  }
}
