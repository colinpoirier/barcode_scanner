import 'dart:async';
import 'dart:io';

import 'package:barcode_scanner/bloc_provider_stateful.dart';
import 'package:barcode_scanner/database_viewer.dart';
import 'package:barcode_scanner/get_barcode_data/get_barcode_data.dart';
import 'package:barcode_scanner/scanned_barcode_data.dart';
import 'package:barcode_scanner/scanned_barcodes.dart';
import 'package:barcode_scanner/scanner_bloc/scanner.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future main() async {
  List<CameraDescription> cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({Key key, this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProviderStateful(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: 'Flutter Demo Home Page',
          cameras: cameras,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.cameras}) : super(key: key);

  final String title;
  final List<CameraDescription> cameras;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController cameraController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takeAndScanImage() async {
    takePicture().then((String imagePath) {
      if (mounted && imagePath != null) {
        showInSnackBar('Picture saved to $imagePath');
        BlocProvider.of<ScannerBloc>(context)
            .dispatch(Scanner(imagePath: imagePath));
      }
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/temp';
    await Directory(dirPath).create(recursive: true);
    final String imagePath = '$dirPath/${timestamp()}.jpg';
    if (cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await cameraController.takePicture(imagePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return imagePath;
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _addToDataBase(GetBarcodeDataState gbds) {
    if (gbds is HasData) {
      Firestore.instance.collection('products').add({
        'barcode': gbds.data.barcodeNumber,
        'name': gbds.data.productName,
        'brand': gbds.data.brand,
        'image': gbds.data.images[0]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final getBarcodeData = BlocProvider.of<GetBarcodeDataBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Vision Example'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DatabaseViewer();
              }));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            ),
          ),
          ScannedBarcodes(),
          ScannedBarcodeData()
        ],
      ),
      floatingActionButton: Row(
        children: <Widget>[
          FloatingActionButton(
            onPressed: _takeAndScanImage,
            tooltip: 'Pick Image',
            child: const Icon(Icons.add_a_photo),
          ),
          SizedBox(
            width: 150,
          ),
          FloatingActionButton(
            onPressed: getBarcodeData.state is HasData
                ? () => _addToDataBase(getBarcodeData.currentState)
                : null,
            tooltip: 'Upload to Cloud',
            child: const Icon(Icons.cloud_upload),
          )
        ],
      ),
    );
  }
}
