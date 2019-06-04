import 'dart:io';

import 'package:barcode_scanner/blocs/checkout_bloc/checkout.dart';
import 'package:barcode_scanner/blocs/checkout_scanner_bloc/checkout_scanner.dart';
import 'package:barcode_scanner/ui/helper_widgets/checkout/checkout_helper_widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class Checkout extends StatefulWidget {
  final Widget child;
  final List<CameraDescription> cameras;

  Checkout({Key key, this.child, this.cameras}) : super(key: key);

  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  CameraController cameraController;
  
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
        BlocProvider.of<CheckoutScannerBloc>(context)
            .dispatch(CheckoutScanner(imagePath: imagePath));
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
    final checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: <Widget>[
          BlocBuilder(
            bloc: checkoutBloc,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.cloud_download),
                onPressed: state is AwaitingBarcodes
                    ? () => checkoutBloc.dispatch(UpdateDb())
                    : null,
              );
            },
          ),
          InkWell(
            child: Icon(Icons.clear),
            onLongPress: () => checkoutBloc.dispatch(ResetCheckoutState()),
          ),
          SizedBox(width: 8,)
        ],
      ),
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: cameraController.value.isInitialized ? AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ): null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: _takeAndScanImage,
                    tooltip: 'Pick Image',
                    child: const Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: BlocBuilder(
                    bloc: BlocProvider.of<CheckoutScannerBloc>(context),
                    builder: (context, state) {
                      if (state is Scanning){
                        return Text('Scanning');
                      } else if (state is ScanError){
                        return Text('Something went\nwrong');
                      } else {
                        return Text('');
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: CheckoutList(),
          ),
          CheckoutListSummary(),
        ],
      ),
    );
  }
}
