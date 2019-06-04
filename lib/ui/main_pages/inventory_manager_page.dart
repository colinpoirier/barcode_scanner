import 'dart:io';

import 'package:barcode_scanner/ui/helper_widgets/inventory/inventory_helper_widgets.dart';
import 'package:barcode_scanner/ui/viewing_pages/barcodedata_list_viewer.dart';
import 'package:barcode_scanner/blocs/scanner_bloc/scanner.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryManager extends StatefulWidget {
  InventoryManager({Key key, this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  _InventoryManagerState createState() => _InventoryManagerState();
}

class _InventoryManagerState extends State<InventoryManager> {
  CameraController cameraController;
  // bool initHandler = false;

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    initializeCamera();
  }

  void initializeCamera() {
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

  @override
  void didChangeDependencies(){
    // initHandler ? initializeCamera() : initHandler = true;
    // initializeCamera();
    super.didChangeDependencies();
  }

  Future<void> _takeAndScanImage() async {
    takePicture().then((String imagePath) {
      if (mounted && imagePath != null) {
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
    } on CameraException catch (_) {
      return null;
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Scanner'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BarcodeDataListViewer(),
                ),
              );
              initializeCamera();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: cameraController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  )
                : null,
          ),
          ScannedBarcodes(),
          ScannedBarcodeData(
            reInitCamera: initializeCamera,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeAndScanImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
