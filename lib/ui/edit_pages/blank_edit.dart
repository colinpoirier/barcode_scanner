import 'dart:typed_data';

import 'package:barcode_scanner/blocs/get_barcode_data_bloc/get_barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/providers/camera_list_provider.dart';
import 'package:barcode_scanner/ui/helper_widgets/edit/edit_helper_widgets.dart';
import 'package:barcode_scanner/ui/take_image/take_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBlank extends StatefulWidget {
  EditBlank({
    Key key,
  }) : super(key: key);

  @override
  _EditBlankState createState() => _EditBlankState();
}

class _EditBlankState extends State<EditBlank> {
  TextEditingController countController;
  TextEditingController priceController;
  TextEditingController nameController;
  TextEditingController brandController;
  TextEditingController categoryController;
  TextEditingController barcodeController;

  List<int> image;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    countController = TextEditingController();
    priceController = TextEditingController();
    nameController = TextEditingController();
    brandController = TextEditingController();
    categoryController = TextEditingController();
    barcodeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width / 2.2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Edit New Product'),
      ),
      body: PaddedColumn(
        children: <Widget>[
          SplitRow(
            halfWidth: halfWidth,
            childLeft: EditTextField(
              controller: brandController,
              labelText: 'Brand',
            ),
            childRight: EditTextField(
              controller: barcodeController,
              labelText: 'Barcode',
            ),
          ),
          EditTextField(
            controller: nameController,
            labelText: 'Name',
          ),
          EditTextField(
            controller: categoryController,
            labelText: 'Category',
          ),
          SplitRow(
            halfWidth: halfWidth,
            childLeft: ValidateIntField(
              controller: countController,
              labelText: 'Count',
            ),
            childRight: ValidateDoubleField(
              controller: priceController,
              labelText: 'Price',
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              var _image = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TakeImage(
                        cameras: CameraList.of(context).cameras,
                        oldImage: image,
                      ),
                ),
              );
              if (_image != null) {
                setState(() {
                  image = _image;
                });
              }
            },
            child: image == null
                ? Container(
                    color: Colors.grey.shade200,
                    width: 100,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.add),
                        const Text('Add Image'),
                      ],
                    ),
                  )
                : Image.memory(
                    Uint8List.fromList(image),
                    height: 250,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          final barcodeData = BarcodeData(
            barcodeNumber: barcodeController.text,
            brand: brandController.text,
            productName: nameController.text,
            count: int.tryParse(countController.text),
            price: double.tryParse(priceController.text),
            category: categoryController.text,
            imageBytes: image,
          );
          if (barcodeData.hasNoNull) {
            BlocProvider.of<GetBarcodeDataBloc>(context).dispatch(AddBlankData(
              blankBarcodeData: barcodeData,
            ));
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
