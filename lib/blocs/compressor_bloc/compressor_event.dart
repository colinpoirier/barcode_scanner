import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CompressorEvent extends Equatable {
  CompressorEvent([List props = const []]) : super(props);
}

class CompressImage extends CompressorEvent{
  final String imagePath;

  CompressImage({this.imagePath}):super([imagePath]);
}