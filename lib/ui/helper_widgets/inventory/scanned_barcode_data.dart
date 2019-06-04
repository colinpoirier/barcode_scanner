import 'package:barcode_scanner/ui/helper_widgets/inventory/barcode_data_list_tile.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/ui/edit_pages/edit_data.dart';
import 'package:barcode_scanner/blocs/get_barcode_data_bloc/get_barcode_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannedBarcodeData extends StatelessWidget {
  final VoidCallback reInitCamera;
  ScannedBarcodeData({Key key, this.reInitCamera}) : super(key: key);

  Widget _dataBuilder(BarcodeData data, BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Data for ${data.barcodeNumber}'),
        BarcodeDataListTile(
          data: data,
          onLongPress: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditData(barcodeData: data),
                ),
              );
            reInitCamera();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final getBarcodeDataBloc = BlocProvider.of<GetBarcodeDataBloc>(context);
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 6,
      child: BlocBuilder(
        bloc: getBarcodeDataBloc,
        builder: (context, state) {
          if (state is AwaitingData) {
            return const Text('Awaiting Scan');
          } else if (state is GettingData) {
            return const CircularProgressIndicator();
          } else if (state is HasData) {
            return state.data.isNotEmpty ? _dataBuilder(state.data.first, context) : Center(child: Text('No Data'),);
          } else if (state is ErrorGettingData) {
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}
