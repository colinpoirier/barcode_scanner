import 'package:flutter/material.dart';

class PaddedColumn extends StatelessWidget {
  final List<Widget> children;

  PaddedColumn({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: children,
      ),
    );
  }
}