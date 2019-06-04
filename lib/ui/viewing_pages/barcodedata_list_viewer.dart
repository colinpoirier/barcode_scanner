import 'package:barcode_scanner/ui/edit_pages/blank_edit.dart';
import 'package:barcode_scanner/ui/edit_pages/edit_data.dart';
import 'package:barcode_scanner/blocs/get_barcode_data_bloc/get_barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/blocs/scanner_bloc/scanner.dart';
import 'package:barcode_scanner/ui/viewing_pages/db_list_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarcodeDataListViewer extends StatelessWidget {
  BarcodeDataListViewer({Key key}) : super(key: key);

  Widget _dataBuilder(BarcodeData data, BuildContext context) {
    return Column(
      children: <Widget>[
        Text(data.barcodeNumber),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: MemoryImage(data.imageBytes),
          ),
          title: Text(data.productName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(data.brand),
              Text(data.price.toString()),
              Text(data.count.toString()),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _showRemoveAlert(data, context);
            },
          ),
          onLongPress: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditData(
                        barcodeData: data,
                      ),
                ),
              ),
        ),
      ],
    );
  }

  Future<void> _showRemoveAlert(BarcodeData data, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove from list?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: const Text('Remove'),
              onPressed: () {
                BlocProvider.of<GetBarcodeDataBloc>(context)
                    .dispatch(DeleteData(deletedBarcode: data));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addToDataBase(List<BarcodeData> data,
      GetBarcodeDataBloc getBarcodeDataBloc, ScannerBloc scannerBloc) async {
    getBarcodeDataBloc.dispatch(AddToDb(data: data));
    scannerBloc.dispatch(Reset());
  }

  @override
  Widget build(BuildContext context) {
    final getBarcodeDataBloc = BlocProvider.of<GetBarcodeDataBloc>(context);
    final scannerBloc = BlocProvider.of<ScannerBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditBlank(),
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.cloud),
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DbListViewer(),
                  ),
                ),
          )
        ],
      ),
      body: BlocBuilder(
        bloc: getBarcodeDataBloc,
        builder: (context, state) {
          if (state is HasData) {
            if (state.data.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(10),
                      height: 1,
                      color: Colors.grey,
                    ),
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return _dataBuilder(state.data[index], context);
                },
              );
            } else {
              scannerBloc.dispatch(Reset());
              getBarcodeDataBloc.dispatch(ResetData());
              return Container();
            }
          } else if (state is GettingData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AwaitingData) {
            return const Center(
              child: Text('Awaiting Scan'),
            );
          } else if (state is Error) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
      floatingActionButton: BlocBuilder(
        bloc: getBarcodeDataBloc,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () => state is HasData
                ? _addToDataBase(state.data, getBarcodeDataBloc, scannerBloc)
                : null,
            tooltip: 'Upload to Cloud',
            child: const Icon(Icons.cloud_upload),
          );
        },
      ),
    );
  }
}
