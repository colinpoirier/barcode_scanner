import 'package:barcode_scanner/blocs/checkout_bloc/checkout.dart';
import 'package:barcode_scanner/models_and_repositories/checkout_data_repository/checkout_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder(
        bloc: checkoutBloc,
        builder: (context, state) {
          if (state is HasPrices) {
            return ListView.builder(
              itemCount: state.productData.length,
              itemBuilder: (context, index) {
                return CheckoutListItem(
                  checkoutBloc: checkoutBloc,
                  checkoutData: state.productData[index],
                );
              },
            );
          } else if (state is AwaitingBarcodes) {
            return const Text('Awaiting Scan');
          } else if (state is Processing) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Error) {
            return const Text('Error');
          }
        },
      ),
    );
  }
}

class CheckoutListItem extends StatelessWidget {
  const CheckoutListItem({
    Key key,
    this.checkoutBloc,
    this.checkoutData,
  }) : super(key: key);

  final CheckoutBloc checkoutBloc;
  final CheckoutData checkoutData;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => checkoutBloc.dispatch(Delete(product: checkoutData)),
      key: Key(checkoutData.barcodeNumber),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 150.0,
            child: Text(
              checkoutData.productName,
              softWrap: true,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: checkoutData.checkoutCount > 1
                ? () => checkoutBloc.dispatch(
                      DecreaseCheckoutCount(
                        product: checkoutData,
                      ),
                    )
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: checkoutData.checkoutCount < checkoutData.count
                ? () => checkoutBloc.dispatch(
                      IncreaseCheckoutCount(
                        product: checkoutData,
                      ),
                    )
                : null,
          ),
          Container(
            width: 100,
            child: Text(
              '${checkoutData.checkoutCount} x ${checkoutData.price}',
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
