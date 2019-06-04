import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import './compressor.dart';

class CompressorBloc extends Bloc<CompressorEvent, CompressorState> {
  @override
  CompressorState get initialState => InitialCompressorState();

  @override
  Stream<CompressorState> mapEventToState(
    CompressorEvent event,
  ) async* {
    if (event is CompressImage) {
      yield* _mapCompressImageToState(event);
    }
  }

  Stream<CompressorState> _mapCompressImageToState(CompressImage event) async* {
    yield Compressing();
    try {
      final _image = await FlutterImageCompress.compressWithFile(
        event.imagePath,
        minHeight: 600,
        minWidth: 600,
        quality: 20,
        rotate: 0
      );
      print(_image.length);
      
      yield HasImage(image: Uint8List.fromList(_image));
      await File(event.imagePath).delete();
    } catch (_) {
      yield CompressorError();
    }
  }
}
