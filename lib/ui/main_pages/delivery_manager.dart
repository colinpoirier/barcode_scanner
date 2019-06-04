import 'package:barcode_scanner/blocs/delivery_bloc/delivery.dart';
import 'package:barcode_scanner/ui/helper_widgets/delivery/delivery_data_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryManager extends StatelessWidget {
  const DeliveryManager({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
      ),
      body: BlocBuilder(
        bloc: BlocProvider.of<DeliveryBloc>(context),
        builder: (context, state) {
          if (state is HasDeliveryData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(10),
                    height: 1,
                    color: Colors.grey,
                  ),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final deliveryData = state.data[index];
                return DeliveryDataItem(deliveryData: deliveryData);
              },
            );
          } else if (state is DeliveryError) {
            return const Text('Error');
          } else if (state is InitialDeliveryState) {
            return const Center(child: Text('Awaiting Delivery Data'));
          }
        },
      ),
    );
  }
}
