import 'package:barcode_scanner/get_barcode_data/get_barcode_data.dart';
import 'package:barcode_scanner/scanner_bloc/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviderStateful extends StatefulWidget {
  final Widget child;

  BlocProviderStateful({Key key, this.child}) : super(key: key);

  _BlocProviderStatefulState createState() => _BlocProviderStatefulState();
}

class _BlocProviderStatefulState extends State<BlocProviderStateful> {
  ScannerBloc scannerBloc;
  GetBarcodeDataBloc getBarcodeDataBloc;

  @override
  void initState() { 
    super.initState();
    scannerBloc = ScannerBloc();
    getBarcodeDataBloc = GetBarcodeDataBloc(scannerBloc: scannerBloc);
  }

  @override
  void dispose() {
    super.dispose();
    scannerBloc.dispose();
    getBarcodeDataBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<ScannerBloc>(bloc: scannerBloc,),
        BlocProvider<GetBarcodeDataBloc>(bloc: getBarcodeDataBloc,)
      ],
      child: widget.child,
    );
  }
}