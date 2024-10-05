import 'dart:collection';

import 'command.dart';

class DrawCanvas {
  const DrawCanvas({
    required this.id,
    required this.active,
    required this.inactive,
  });

  DrawCanvas.active({
    required this.id,
    required this.active,
  }) : inactive = Queue();

  factory DrawCanvas.fromJson(Map<String, Object?> json) => DrawCanvas(
        id: json['id'] as int,
        active: Queue.from(
          (json['active'] as Iterable<Object?>)
              .map((e) => Command.fromJson(e as Map<String, Object?>)),
        ),
        inactive: Queue.from(
          (json['inactive'] as Iterable<Object?>)
              .map((e) => Command.fromJson(e as Map<String, Object?>)),
        ),
      );

  final int id;
  final Queue<DrawCommand> active;
  final Queue<DrawCommand> inactive;

  Map<String, Object?> toJson() => {
        'id': id,
        'active': active.map((command) => command.toJson()).toList(),
        'inactive': inactive.map((command) => command.toJson()).toList(),
      };
}
