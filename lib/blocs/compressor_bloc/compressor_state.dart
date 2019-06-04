import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CompressorState extends Equatable {
  CompressorState([List props = const []]) : super(props);
}

class InitialCompressorState extends CompressorState {}

class HasImage extends CompressorState{
  final List<int> image;

  HasImage({this.image}):super([image]);
}

class Compressing extends CompressorState{}

class CompressorError extends CompressorState{}
