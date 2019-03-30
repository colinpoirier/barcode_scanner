import 'dart:async';
import 'package:barcode_scanner/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/barcode_data_repository/barcode_data_repository.dart';
import 'package:barcode_scanner/scanner_bloc/scanner.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import './get_barcode_data.dart';

class GetBarcodeDataBloc extends Bloc<GetBarcodeDataEvent, GetBarcodeDataState> {
  final ScannerBloc scannerBloc;
  StreamSubscription scannerBlocSubscription;
  final BarcodeDataRepository barcodeDataRepository;

  GetBarcodeDataBloc({this.scannerBloc, this.barcodeDataRepository}){
    scannerBlocSubscription = scannerBloc.state.listen((state){
      if (state is Scanned){
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
    if(event is GetData){
      yield* _mapGetDataToState(event.data);
    }
  }

  Stream<GetBarcodeDataState> _mapGetDataToState(List<Barcode> data) async*{
    yield GettingData();
    try{
      final BarcodeData barcodeData = await barcodeDataRepository.getData(data[0].rawValue);
      yield HasData(data: barcodeData);
    } catch (_){
      yield ErrorGettingData();
    }
  }

  @override
  void dispose() { 
    scannerBlocSubscription.cancel();
    super.dispose();
  }
}
