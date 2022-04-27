import 'package:flutter/material.dart';

enum SnackBarType { info, error, success }

Color _getSnackBarColor(SnackBarType type) {
  switch (type) {
    case SnackBarType.error:
      return Colors.red;
    case SnackBarType.success:
      return Colors.green;
    default:
      return Colors.white;
  }
}

void showCustomSnackBar(BuildContext context, String text,
    {SnackBarType type = SnackBarType.info}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: TextStyle(
          color: type == SnackBarType.info ? Colors.black : Colors.white),
    ),
    backgroundColor: _getSnackBarColor(type),
  ));
}
