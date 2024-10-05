import 'dart:typed_data';

import 'package:flutter/material.dart';

extension RelativeOffsetExt on Offset {
  Float64x2 toRelative(Size size) => Float64x2(
        dx / size.width,
        dy / size.height,
      );
}
