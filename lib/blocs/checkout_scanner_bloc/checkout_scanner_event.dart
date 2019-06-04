import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CheckoutScannerEvent extends Equatable {
  CheckoutScannerEvent([List props = const []]) : super(props);
}

class CheckoutScanner extends CheckoutScannerEvent{
  final String imagePath;

  CheckoutScanner({this.imagePath}):super([imagePath]);
}