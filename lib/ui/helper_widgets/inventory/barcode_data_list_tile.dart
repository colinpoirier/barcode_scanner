import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:flutter/material.dart';

class BarcodeDataListTile extends StatelessWidget {
  final BarcodeData data;
  final VoidCallback onLongPress;

  BarcodeDataListTile({Key key, this.data, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: MemoryImage(data.imageBytes),
      ),
      title: Text(data.productName),
      subtitle: Text(data.brand),
      onLongPress: onLongPress,
    );
  }
}
