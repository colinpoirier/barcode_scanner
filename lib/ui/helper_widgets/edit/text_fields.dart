import 'package:flutter/material.dart';

class EditTextField extends TextFormField {
  final TextEditingController controller;
  final String labelText;

  EditTextField({
    this.controller,
    this.labelText,
  }) : super(
          controller: controller,
          decoration: InputDecoration(labelText: labelText),
        );
}

class ValidateIntField extends TextFormField {
  final TextEditingController controller;
  final String labelText;

  ValidateIntField({
    this.controller,
    this.labelText,
  }) : super(
          controller: controller,
          autovalidate: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: labelText),
          validator: (value) {
            try {
              if (value.isNotEmpty) int.parse(value);
            } catch (_) {
              return 'Please enter another value';
            }
          },
        );
}

class ValidateDoubleField extends TextFormField {
  final TextEditingController controller;
  final String labelText;

  ValidateDoubleField({
    this.controller,
    this.labelText,
  }) : super(
          controller: controller,
          autovalidate: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: labelText),
          validator: (value) {
            try {
              if (value.isNotEmpty) double.parse(value);
            } catch (_) {
              return 'Please enter another value';
            }
          },
        );
}
