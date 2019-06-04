import 'dart:io';

import 'package:barcode_scanner/blocs/compressor_bloc/compressor.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class TakeImage extends StatefulWidget {
  TakeImage({Key key, this.cameras, this.oldImage, this.oldImageString}) : super(key: key);

  final List<CameraDescription> cameras;
  final List<int> oldImage;
  final String oldImageString;

  @override
  _InventoryManagerState createState() => _InventoryManagerState();
}

class _InventoryManagerState extends State<TakeImage> {
  CameraController cameraController;

  CompressorBloc compressorBloc;

  @override
  void initState() {
    super.initState();
    // CameraController(widget.cameras[0], ResolutionPreset.medium).dispose();
    cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    compressorBloc = CompressorBloc();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    compressorBloc.dispose();
    super.dispose();
  }

  Future<void> _takeAndScanImage() async {
    takePicture().then((String imagePath) async {
      if (mounted && imagePath != null) {
        compressorBloc.dispatch(CompressImage(imagePath: imagePath));
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
        title: const Text('Take Image'),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 2.2,
                child: cameraController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: _takeAndScanImage,
                  tooltip: 'Pick Image',
                  child: const Icon(Icons.add_a_photo),
                ),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                widget.oldImage != null
                ? ImagePreview(
                  image: widget.oldImage,
                  caption: 'Old',
                )
                : ImagePreview(
                  imageString: widget.oldImageString,
                  caption: 'Old',
                ),
                BlocBuilder(
                  bloc: compressorBloc,
                  builder: (context, state) {
                    if(state is HasImage){
                      return ImagePreview(
                        image: state.image,
                        caption: 'New',
                      );
                    } else if (state is Compressing){
                      return const Center(child: CircularProgressIndicator(),);
                    } else if (state is CompressorError){
                      return const Text('Error');
                    } else {
                      return Container();
                    }
                  }
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: BlocBuilder(
        bloc: compressorBloc,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed:  state is HasImage ? () => Navigator.of(context).pop(state.image) : null,
            tooltip: 'Save Image',
            child: const Icon(Icons.check),
          );
        }
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final List<int> image;
  final String imageString;
  final String caption;

  ImagePreview({Key key, this.image, this.imageString, this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image != null || imageString != null
        ? Column(
            children: <Widget>[
              Text(
                caption,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Image(
                  image: image != null ? MemoryImage(image) : NetworkImage(imageString),
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width/2.1,
                ),
              ),
            ],
          )
        : Container();
  }
}
