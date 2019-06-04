import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:barcode_scanner/blocs/checkout_scanner_bloc/checkout_scanner.dart';

class CheckoutScannerBloc extends Bloc<CheckoutScannerEvent, CheckoutScannerState> {
  @override
  CheckoutScannerState get initialState => AwaitingScan();

  @override
  Stream<CheckoutScannerState> mapEventToState(
    CheckoutScannerEvent event,
  ) async* {
    if (event is CheckoutScanner) {
      yield* _mapScannerToState(event);
    }
  }

  Stream<CheckoutScannerState> _mapScannerToState(CheckoutScanner event) async* {
    yield Scanning();
    try {
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFilePath(event.imagePath);
      final BarcodeDetector detector =
          FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await detector
          .detectInImage(visionImage)
          .timeout(Duration(seconds: 3));
      if(barcodes.isEmpty) throw 'empty';
      yield Scanned(barcodes: barcodes);
      await File(event.imagePath).delete();
    } catch (e) {
      print(e);
      yield ScanError();
    }
  }
}
