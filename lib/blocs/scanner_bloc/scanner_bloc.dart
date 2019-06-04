import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:barcode_scanner/blocs/scanner_bloc/scanner.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  @override
  ScannerState get initialState => AwaitingScan();

  @override
  Stream<ScannerState> mapEventToState(
    ScannerEvent event,
  ) async* {
    if (event is Scanner) {
      yield* _mapScannerToState(event);
    } else if (event is Reset){
      yield* _mapResetToState();
    }
  }

  Stream<ScannerState> _mapScannerToState(Scanner event) async* {
    yield Scanning();
    try {
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFilePath(event.imagePath);
      final BarcodeDetector detector =
          FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await detector
          .detectInImage(visionImage)
          .timeout(Duration(seconds: 3));
      if(barcodes.isEmpty) throw '';
      yield Scanned(barcodes: barcodes);
      await File(event.imagePath).delete();
    } catch (_) {
      yield ScanError();
    }
  }

  Stream<ScannerState> _mapResetToState() async* {
    yield AwaitingScan();
  }
}
