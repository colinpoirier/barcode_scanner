import 'package:barcode_scanner/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/get_barcode_data/get_barcode_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannedBarcodeData extends StatelessWidget {

  ScannedBarcodeData({Key key}) : super(key: key);

  Widget _dataBuilder(BarcodeData data){
    return Column(
      children: <Widget>[
        const Text('Data for first barcode'),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.images[0]),
          ),
          title: Text(data.productName),
          subtitle: Text(data.brand),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final getBarcodeDataBloc = BlocProvider.of<GetBarcodeDataBloc>(context);
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height/4,
      child: BlocBuilder(
        bloc: getBarcodeDataBloc,
        builder: (context, state){
          if(state is AwaitingData){
            return const Text('Awaiting Scan');
          } else if (state is GettingData){
            return const CircularProgressIndicator();
          } else if (state is HasData){
            return _dataBuilder(state.data);
          } else if (state is ErrorGettingData){
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}