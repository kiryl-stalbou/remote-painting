import 'package:flutter/material.dart';

Page<void> asMaterialPage(
  Widget w,
  String name, [
  bool fullscreenDialog = false,
]) =>
    MaterialPage(
      name: name,
      fullscreenDialog: fullscreenDialog,
      key: ValueKey(name),
      child: Material(
        type: MaterialType.transparency,
        child: w,
      ),
    );
