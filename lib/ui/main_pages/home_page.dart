import 'package:barcode_scanner/providers/camera_list_provider.dart';
import 'package:barcode_scanner/ui/helper_widgets/home_page/selection_container.dart';
import 'package:barcode_scanner/ui/main_pages/checkout_manager_page.dart';
import 'package:barcode_scanner/ui/main_pages/delivery_manager.dart';
import 'package:barcode_scanner/ui/main_pages/inventory_manager_page.dart';
import 'package:barcode_scanner/ui/viewing_pages/db_list_viewer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameras = CameraList.of(context).cameras;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SelectionContainer(
              color: Colors.blueAccent,
              label: 'Inventory',
              onLongPressChild: DbListViewer(),
              onTapChild: InventoryManager(
                cameras: cameras,
              ),
            ),
            SizedBox(height: 30,),
            SelectionContainer(
              color: Colors.greenAccent,
              label: 'Checkout',
              onTapChild: Checkout(
                cameras: cameras,
              ),
            ),
            SizedBox(height: 30,),
            SelectionContainer(
              color: Colors.redAccent,
              label: 'Delivery',
              onTapChild: DeliveryManager(),
            ),
          ],
        ),
      ),
    );
  }
}
