import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/points.dart';

sealed class Command {
  const Command({
    required this.type,
    required this.canvasId,
  });

  factory Command.fromJson(Map<String, Object?> json) {
    final type = json['type'] as int?;

    return switch (type) {
      1 => RemoteDrawCommand.fromJson(json),
      2 => UndoCommand.fromJson(json),
      3 => RedoCommand.fromJson(json),
      4 => ClearCanvasCommand.fromJson(json),
      5 => RemoveCanvasCommand.fromJson(json),
      _ => throw ArgumentError.value(
          type,
          'Command.fromType',
          'Invalid Command type',
        ),
    };
  }

  final int type;
  final int canvasId;

  Map<String, Object?> toJson() => {
        'type': type,
        'canvasId': canvasId,
      };
}

enum DrawTool { pen, eraser }

abstract base class DrawCommand extends Command {
  DrawCommand({
    required super.canvasId,
    required this.color,
    required this.tool,
    required this.strokeWidth,
  }) : super(type: 1);

  Color color;
  DrawTool tool;
  double strokeWidth;
  Iterable<Float64x2> get points;
}

final class RemoteDrawCommand extends DrawCommand {
  RemoteDrawCommand({
    required super.canvasId,
    required this.points,
    required super.color,
    required super.tool,
    required super.strokeWidth,
  });

  factory RemoteDrawCommand.fromJson(Map<String, Object?> json) {
    final points = json['points'] as List<Object?>;

    return RemoteDrawCommand(
      canvasId: json['canvasId'] as int,
      points: points.toFloat64x2List(),
      color: Color(json['color'] as int),
      tool: DrawTool.values[json['tool'] as int],
      strokeWidth: json['strokeWidth'] as double,
    );
  }

  @override
  Float64x2List points;

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'canvasId': canvasId,
        'points': points.toListDouble(),
        'color': color.value,
        'tool': tool.index,
        'strokeWidth': strokeWidth,
      };
}

final class LocalDrawCommand extends DrawCommand with ChangeNotifier {
  LocalDrawCommand({
    required super.canvasId,
    required super.color,
    required super.tool,
    required super.strokeWidth,
  }) : points = [];

  @override
  List<Float64x2> points;

  void addPoint(Float64x2 point) {
    points.add(point);
    notifyListeners();
  }

  RemoteDrawCommand toRemote() => RemoteDrawCommand(
        canvasId: canvasId,
        points: Float64x2List.fromList(points),
        color: color,
        tool: tool,
        strokeWidth: strokeWidth,
      );
}

final class UndoCommand extends Command {
  const UndoCommand({required super.canvasId}) : super(type: 2);

  factory UndoCommand.fromJson(Map<String, Object?> json) => UndoCommand(
        canvasId: json['canvasId'] as int,
      );
}

final class RedoCommand extends Command {
  const RedoCommand({required super.canvasId}) : super(type: 3);

  factory RedoCommand.fromJson(Map<String, Object?> json) => RedoCommand(
        canvasId: json['canvasId'] as int,
      );
}

final class ClearCanvasCommand extends Command {
  const ClearCanvasCommand({required super.canvasId}) : super(type: 4);

  factory ClearCanvasCommand.fromJson(Map<String, Object?> json) =>
      ClearCanvasCommand(
        canvasId: json['canvasId'] as int,
      );
}

final class RemoveCanvasCommand extends Command {
  const RemoveCanvasCommand({required super.canvasId}) : super(type: 5);

  factory RemoveCanvasCommand.fromJson(Map<String, Object?> json) =>
      RemoveCanvasCommand(
        canvasId: json['canvasId'] as int,
      );
}
