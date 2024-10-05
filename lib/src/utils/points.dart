import 'dart:typed_data';

extension Float64x2ListExtension on Float64x2List {
  List<double> toListDouble() => buffer.asFloat64List().toList();
}

extension ListDoubleExtension on List<Object?> {
  Float64x2List toFloat64x2List() =>
      Float64List.fromList(whereType<double>().toList())
          .buffer
          .asFloat64x2List();
}
