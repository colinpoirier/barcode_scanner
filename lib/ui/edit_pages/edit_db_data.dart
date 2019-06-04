import 'package:barcode_scanner/providers/camera_list_provider.dart';
import 'package:barcode_scanner/ui/helper_widgets/edit/edit_helper_widgets.dart';
import 'package:barcode_scanner/ui/take_image/take_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDbData extends StatefulWidget {
  final DocumentSnapshot dbData;

  EditDbData({Key key, this.dbData}) : super(key: key);

  @override
  _EditDbDataState createState() => _EditDbDataState();
}

class _EditDbDataState extends State<EditDbData> {
  TextEditingController countController;
  TextEditingController priceController;
  TextEditingController nameController;
  TextEditingController brandController;
  TextEditingController categoryController;
  TextEditingController barcodeController;

  List<int> image = [];

  DocumentSnapshot get dbData => widget.dbData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    countController = TextEditingController(text: dbData['count'].toString());
    priceController = TextEditingController(text: dbData['price'].toString());
    nameController = TextEditingController(text: dbData['name']);
    brandController = TextEditingController(text: dbData['brand']);
    categoryController = TextEditingController(text: dbData['category']);
    barcodeController = TextEditingController(text: dbData['barcode']);
    super.initState();
  }

  bool isNotNull() =>
      barcodeController.text != null &&
      int.tryParse(countController.text) != null &&
      double.tryParse(priceController.text) != null &&
      brandController.text != null &&
      nameController.text != null &&
      categoryController.text != null;

  Future _uploadToCloud() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Updating'),
      duration: Duration(seconds: 10),
    ));
    await Firestore.instance
        .collection('products')
        .document(dbData.documentID)
        .updateData({
      'barcode': barcodeController.text,
      'count': int.parse(countController.text),
      'price': double.parse(priceController.text),
      'brand': brandController.text,
      'name': nameController.text,
      'category': categoryController.text,
    });
    if (image.isNotEmpty) {
      FirebaseStorage storage = FirebaseStorage(
          storageBucket: 'gs://barcodescanner-a1682.appspot.com');
      final sref = storage.ref().child('${dbData.documentID}.jpg');
      await sref
          .putData(
              image,
              StorageMetadata(
                contentType: 'image/jpg',
              ))
          .onComplete;
    }
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Updated!')));
  }

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width / 2.2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Edit Database Product'),
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
                        oldImageString: dbData['image'],
                      ),
                ),
              );
              if (_image != null) {
                setState(() {
                  image = _image;
                });
              }
            },
            child: Image(
              image: image.isEmpty
                  ? NetworkImage(dbData['image'])
                  : MemoryImage(image),
              height: 250,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async => isNotNull() ? await _uploadToCloud() : null,
      ),
    );
  }
}
