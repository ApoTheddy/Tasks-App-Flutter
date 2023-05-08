import 'package:flutter/material.dart';

void showSnackbar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 1)));
}
