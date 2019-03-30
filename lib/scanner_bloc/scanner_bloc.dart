import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:barcode_scanner/scanner_bloc/scanner.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  @override
  ScannerState get initialState => AwaitingScan();

  @override
  Stream<ScannerState> mapEventToState(
    ScannerEvent event,
  ) async* {
    if (event is Scanner) {
      yield* _mapScannerToState(event.imagePath);
    }
  }

  Stream<ScannerState> _mapScannerToState(String imagePath) async* {
    yield Scanning();
    try {
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFilePath(imagePath);
      await File(imagePath).delete();
      final BarcodeDetector detector =
          FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await detector
          .detectInImage(visionImage)
          .timeout(Duration(seconds: 10));
      yield Scanned(barcodes: barcodes);
    } catch (_) {
      yield ScanError();
    }
  }
}
