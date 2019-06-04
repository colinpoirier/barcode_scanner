import 'package:flutter/material.dart';

class SplitRow extends StatelessWidget {
  final Widget childLeft;
  final Widget childRight;
  final double halfWidth;

  SplitRow({Key key, this.childRight, this.childLeft, this.halfWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: halfWidth,
          child: childLeft,
        ),
        Spacer(),
        Container(
          width: halfWidth,
          child: childRight,
        ),
      ],
    );
  }
}
