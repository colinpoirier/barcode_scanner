import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScannerEvent extends Equatable {
  ScannerEvent([List props = const []]) : super(props);
}

class Scanner extends ScannerEvent{
  final String imagePath;

  Scanner({this.imagePath}):super([imagePath]);
}

class Reset extends ScannerEvent{}