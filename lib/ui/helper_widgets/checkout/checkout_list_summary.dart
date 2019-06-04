import 'package:barcode_scanner/blocs/checkout_bloc/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutListSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder(
        bloc: BlocProvider.of<CheckoutBloc>(context),
        builder: (context, state) {
          if (state is HasPrices) {
            int totalCount = 0;
            state.productData.forEach((f) => totalCount += f.checkoutCount);
            return Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Totals: $totalCount',
                  ),
                ),
                FloatingActionButton.extended(
                  heroTag: null,
                  label: const Text('Checkout'),
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => BlocProvider.of<CheckoutBloc>(context)
                      .dispatch(CompleteCheckout(products: state.productData)),
                ),
                Expanded(
                  child: Text(
                    '\$' + state.totalPrice.toStringAsFixed(2),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
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
