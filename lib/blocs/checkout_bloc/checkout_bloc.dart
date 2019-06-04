import 'dart:async';
import 'package:barcode_scanner/blocs/checkout_scanner_bloc/checkout_scanner.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './checkout.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  List<CheckoutData> _dbData;
  final CheckoutScannerBloc checkoutScannerBloc;
  final CheckoutDataRepository checkoutDataRepository;
  StreamSubscription _scannerBlocSubscription;

  CheckoutBloc({
    this.checkoutScannerBloc,
    this.checkoutDataRepository,
  }) {
    _scannerBlocSubscription = checkoutScannerBloc.state.listen((state) {
      if (state is Scanned) {
        dispatch(GetPrices(barcodes: state.barcodes));
      }
    });
  }

  @override
  CheckoutState get initialState => AwaitingBarcodes();

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    if (event is GetPrices) {
      yield* _mapGetPricesToState(event, currentState);
    } else if (event is CompleteCheckout) {
      yield* _mapCompleteCheckoutToState(event, currentState);
    } else if (event is UpdateDb) {
      yield* _mapUpdateDbToState();
    } else if (event is IncreaseCheckoutCount) {
      yield* _mapIncreaseCheckoutCountToState(event, currentState);
    } else if (event is DecreaseCheckoutCount) {
      yield* _mapDecreaseCheckoutCountToState(event, currentState);
    } else if (event is Delete) {
      yield* _mapDeleteToState(event, currentState);
    } else if (event is ResetCheckoutState){
      yield* _mapResetCheckoutStateToState();
    }
  }

  Stream<CheckoutState> _mapGetPricesToState(
      GetPrices event, CheckoutState state) async* {
    yield Processing();
    List<CheckoutData> products = state is HasPrices ? state.productData : [];
    double totalPrice = 0.0;
    String eventBarcode = event.barcodes[0].rawValue;
    try {
      if (products.every((product) => product.barcodeNumber != eventBarcode)) {
        final productFromDb = _dbData.firstWhere((product) => product.barcodeNumber == eventBarcode);
        products.add(productFromDb);
      } else {
        products = products
            .map((product) => product.barcodeNumber == eventBarcode
                ? product.copyWith(checkoutCount: product.checkoutCount + 1)
                : product)
            .toList();
      }
      products.forEach((p) {
        totalPrice += (p.price * p.checkoutCount);
      });
      yield HasPrices(productData: products, totalPrice: totalPrice);
    } catch (e) {
      print(e.toString());
      if(state is HasPrices){
        yield HasPrices(productData: state.productData, totalPrice: state.totalPrice);
      } else {
        yield Error();
      }
    }
  }

  Stream<CheckoutState> _mapCompleteCheckoutToState(
      CompleteCheckout event, CheckoutState state) async* {
    yield Processing();
    CollectionReference refCol = Firestore.instance.collection('products');
    await _getDbData();
    WriteBatch batch = Firestore.instance.batch();
    for (CheckoutData i in event.products) {
      final refCount =
          _dbData.where((temp) => temp.barcodeNumber == i.barcodeNumber);
      batch.updateData(refCol.document(i.docId),
          <String, dynamic>{'count': refCount.first.count - i.checkoutCount});
    }
    batch.commit();
    await _getDbData();
    yield AwaitingBarcodes();
  }

  Future _getDbData() async {
    _dbData = await checkoutDataRepository.getDbData();
  }

  Stream<CheckoutState> _mapUpdateDbToState() async* {
    yield Processing();
    await _getDbData();
    yield AwaitingBarcodes();
  }

  Stream<CheckoutState> _mapIncreaseCheckoutCountToState(
      IncreaseCheckoutCount event, CheckoutState state) async* {
    if (state is HasPrices) {
      final updatedProducts = state.productData
          .map((product) => product.barcodeNumber == event.product.barcodeNumber
              ? product.copyWith(checkoutCount: product.checkoutCount + 1)
              : product)
          .toList();
      yield HasPrices(
        productData: updatedProducts,
        totalPrice: state.totalPrice + event.product.price,
      );
    }
  }

  Stream<CheckoutState> _mapDecreaseCheckoutCountToState(
      DecreaseCheckoutCount event, CheckoutState state) async* {
    if (state is HasPrices) {
      final updatedProducts = state.productData
          .map((product) => product.barcodeNumber == event.product.barcodeNumber
              ? product.copyWith(checkoutCount: product.checkoutCount - 1)
              : product)
          .toList();
      yield HasPrices(
        productData: updatedProducts,
        totalPrice: state.totalPrice - event.product.price,
      );
    }
  }

  Stream<CheckoutState> _mapDeleteToState(
      Delete event, CheckoutState state) async* {
    if (state is HasPrices) {
      final updatedProducts = state.productData
          .where(
              (product) => product.barcodeNumber != event.product.barcodeNumber)
          .toList();
      yield updatedProducts.isNotEmpty
          ? HasPrices(
              productData: updatedProducts,
              totalPrice: state.totalPrice -
                  (event.product.price * event.product.checkoutCount),
            )
          : AwaitingBarcodes();
    }
  }

  Stream<CheckoutState> _mapResetCheckoutStateToState() async* {
    yield AwaitingBarcodes();
  }

  @override
  void dispose() {
    _scannerBlocSubscription.cancel();
    super.dispose();
  }
}
