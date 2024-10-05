import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String data) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
}
