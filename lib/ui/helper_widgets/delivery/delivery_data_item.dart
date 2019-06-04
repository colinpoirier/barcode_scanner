import 'package:barcode_scanner/blocs/delivery_bloc/delivery.dart';
import 'package:barcode_scanner/models_and_repositories/delivery_data_repository/delivery_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryDataItem extends StatelessWidget {
  const DeliveryDataItem({Key key, this.deliveryData}) : super(key: key);

  final DeliveryData deliveryData;

  Future<void> _showCompleteDeleteAlert(
      DeliveryData deliveryData, BuildContext context, bool isComplete) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: isComplete
              ? const Text('Complete order?')
              : const Text('Delete from list?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: isComplete ? const Text('Complete') : const Text('Delete'),
              onPressed: () {
                BlocProvider.of<DeliveryBloc>(context).dispatch(isComplete
                    ? CompleteOrder(deliveryData: deliveryData)
                    : DeleteDeliveryData(deliveryData: deliveryData));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    int itemCount = 0;
    final productItems = deliveryData.products.map((product) {
      totalPrice += (product.checkoutCount * product.price);
      itemCount += product.checkoutCount;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(product.productName),
          Text('${product.checkoutCount} x ${product.price}'),
        ],
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(deliveryData.name),
          Text(deliveryData.phone),
          if (deliveryData.isDelivery)
            Text(deliveryData.address + ', ' + deliveryData.city),
          ...productItems,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Item count: $itemCount'),
              Text('Total price: \$$totalPrice'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: const Text('Delete'),
                onPressed: () =>
                    _showCompleteDeleteAlert(deliveryData, context, false),
              ),
              FlatButton(
                child: const Text('Complete'),
                onPressed: () =>
                    _showCompleteDeleteAlert(deliveryData, context, true),
              ),
            ],
          )
        ],
      ),
    );
  }
}
