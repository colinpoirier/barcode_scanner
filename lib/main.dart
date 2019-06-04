import 'dart:async';

import 'package:barcode_scanner/providers/bloc_provider_stateful.dart';
import 'package:barcode_scanner/ui/main_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future main() async {
  List<CameraDescription> cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({Key key, this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProviderStateful(
      cameras: cameras,
      child: MaterialApp(
        title: 'Scanner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}

