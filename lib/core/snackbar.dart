import 'package:flutter/material.dart';

class CommonSnackbar {
  CommonSnackbar._();
  static buildSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
