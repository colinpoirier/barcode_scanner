import 'package:barcode_scanner/blocs/scanner_bloc/scanner.dart';
import 'package:barcode_scanner/providers/camera_list_provider.dart';
import 'package:barcode_scanner/blocs/checkout_bloc/checkout.dart';
import 'package:barcode_scanner/blocs/checkout_scanner_bloc/checkout_scanner.dart';
import 'package:barcode_scanner/blocs/delivery_bloc/delivery.dart';
import 'package:barcode_scanner/blocs/get_barcode_data_bloc/get_barcode_data.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data_client.dart';
import 'package:barcode_scanner/models_and_repositories/barcode_data_repository/barcode_data_repository.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data_client.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data_repository.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class BlocProviderStateful extends StatefulWidget {
  final Widget child;
  final List<CameraDescription> cameras;

  BlocProviderStateful({Key key, this.child, this.cameras}) : super(key: key);

  _BlocProviderStatefulState createState() => _BlocProviderStatefulState();
}

class _BlocProviderStatefulState extends State<BlocProviderStateful> {
  ScannerBloc scannerBloc;
  GetBarcodeDataBloc getBarcodeDataBloc;
  BarcodeDataClient barcodeDataClient;
  BarcodeDataRepository barcodeDataRepository;

  CheckoutScannerBloc checkoutScannerBloc;
  CheckoutBloc checkoutBloc;
  CheckoutDataClient checkoutDataClient;
  CheckoutDataRepository checkoutDataRepository;

  DeliveryBloc deliveryBloc;

  @override
  void initState() {
    super.initState();
    scannerBloc = ScannerBloc();
    barcodeDataClient = BarcodeDataClient(httpClient: http.Client());
    barcodeDataRepository =
        BarcodeDataRepository(barcodeDataClient: barcodeDataClient);
    getBarcodeDataBloc = GetBarcodeDataBloc(
        scannerBloc: scannerBloc, barcodeDataRepository: barcodeDataRepository);

    checkoutScannerBloc = CheckoutScannerBloc();
    checkoutDataClient = CheckoutDataClient();
    checkoutDataRepository =
        CheckoutDataRepository(checkoutDataClient: checkoutDataClient);
    checkoutBloc = CheckoutBloc(
        checkoutScannerBloc: checkoutScannerBloc,
        checkoutDataRepository: checkoutDataRepository);
    checkoutBloc.dispatch(UpdateDb());

    deliveryBloc = DeliveryBloc();
  }

  @override
  void dispose() {
    super.dispose();
    scannerBloc.dispose();
    getBarcodeDataBloc.dispose();
    checkoutBloc.dispose();
    checkoutScannerBloc.dispose();
    deliveryBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<ScannerBloc>(
          bloc: scannerBloc,
        ),
        BlocProvider<GetBarcodeDataBloc>(
          bloc: getBarcodeDataBloc,
        ),
        BlocProvider<CheckoutScannerBloc>(
          bloc: checkoutScannerBloc,
        ),
        BlocProvider<CheckoutBloc>(
          bloc: checkoutBloc,
        ),
        BlocProvider<DeliveryBloc>(
          bloc: deliveryBloc,
        )
      ],
      child: CameraList(
        cameras: widget.cameras,
        child: widget.child,
      ),
    );
  }
}
