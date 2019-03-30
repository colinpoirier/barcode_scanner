import 'package:barcode_scanner/scanner_bloc/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannedBarcodes extends StatelessWidget {
  final Widget child;

  ScannedBarcodes({Key key, this.child}) : super(key: key);

  Widget _listview(List data, BuildContext context){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index){
        return Text(data[index].toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scannerBloc = BlocProvider.of<ScannerBloc>(context);
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height/4,
      child: BlocBuilder(
        bloc: scannerBloc,
        builder: (context, state){
          if(state is AwaitingScan){
            return const Text('Scan A Barcode');
          } else if (state is Scanning){
            return const CircularProgressIndicator();
          } else if (state is Scanned){
            return _listview(state.barcodes, context);
          } else if (state is ScanError){
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}