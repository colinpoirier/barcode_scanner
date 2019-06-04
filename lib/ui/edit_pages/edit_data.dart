import 'package:barcode_scanner/blocs/get_barcode_data_bloc/get_barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data.dart';
import 'package:barcode_scanner/providers/camera_list_provider.dart';
import 'package:barcode_scanner/ui/helper_widgets/edit/edit_helper_widgets.dart';
import 'package:barcode_scanner/ui/take_image/take_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditData extends StatefulWidget {
  final BarcodeData barcodeData;

  EditData({Key key, this.barcodeData}) : super(key: key);

  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController countController;
  TextEditingController priceController;
  TextEditingController nameController;
  TextEditingController brandController;
  TextEditingController categoryController;
  TextEditingController barcodeController;

  List<int> image;

  BarcodeData get barcodeData => widget.barcodeData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    countController = TextEditingController(text: barcodeData.count.toString());
    priceController = TextEditingController(text: barcodeData.price.toString());
    nameController = TextEditingController(text: barcodeData.productName);
    brandController = TextEditingController(text: barcodeData.brand);
    categoryController = TextEditingController(text: barcodeData.category);
    barcodeController = TextEditingController(text: barcodeData.barcodeNumber);
    image = barcodeData.imageBytes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width / 2.2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Edit Product'),
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
                    image,
                    height: 250,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          final _barcodeData = BarcodeData(
            barcodeNumber: barcodeController.text,
            brand: brandController.text,
            productName: nameController.text,
            count: int.tryParse(countController.text),
            price: double.tryParse(priceController.text),
            category: categoryController.text,
            imageBytes: image,
          );
          if (_barcodeData.hasNoNull) {
            BlocProvider.of<GetBarcodeDataBloc>(context).dispatch(
              UpdateData(
                updatedBarcode: _barcodeData,
              ),
            );
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Updated'),
            ));
          }
        },
      ),
    );
  }
}
