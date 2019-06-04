import 'package:flutter/material.dart';

class SelectionContainer extends StatelessWidget {
  final Widget onTapChild;
  final Widget onLongPressChild;
  final Color color;
  final String label;

  SelectionContainer({
    Key key,
    this.onTapChild,
    this.onLongPressChild,
    this.color,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => onTapChild,
            ),
          ),
      onLongPress: onLongPressChild != null
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => onLongPressChild,
                ),
              )
          : null,
      child: Container(
        padding: const EdgeInsets.all(80.0),
        // color: color,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(label),
      ),
    );
  }
}
