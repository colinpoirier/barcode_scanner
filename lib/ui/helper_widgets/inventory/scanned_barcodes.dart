import 'package:barcode_scanner/blocs/scanner_bloc/scanner.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannedBarcodes extends StatelessWidget {
  
  ScannedBarcodes({Key key}) : super(key: key);

  Widget _listview(List<Barcode> data, BuildContext context){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index){
        return Center(child: Text(data[index].rawValue));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height/6,
      child: BlocBuilder(
        bloc: BlocProvider.of<ScannerBloc>(context),
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