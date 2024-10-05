import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/command.dart';
import '../../models/client_model.dart';
import '../../utils/relative_offset.dart';

const _canvasColor = Color(0xFFF5F5DC);

class ClientCanvas extends StatelessWidget {
  const ClientCanvas({
    required this.canvasId,
    this.localDrawCommand,
    super.key,
  });

  final LocalDrawCommand? localDrawCommand;
  final int canvasId;

  @override
  Widget build(BuildContext context) {
    final clientModel = context.watch<ClientModel>();

    return LayoutBuilder(
      builder: (_, constraints) {
        final size = constraints.biggest;
        final localDrawCommand = this.localDrawCommand;

        if (localDrawCommand == null) {
          return CustomPaint(
            painter: _CanvasPainter(
              clientModel: clientModel,
              canvasId: canvasId,
            ),
            size: size,
          );
        }

        return MouseRegion(
          cursor: SystemMouseCursors.precise,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              localDrawCommand.addPoint(event.localPosition.toRelative(size));
            },
            onPointerMove: (event) {
              localDrawCommand.addPoint(event.localPosition.toRelative(size));
            },
            onPointerUp: (event) {
              clientModel.addCommand(localDrawCommand.toRemote());
              localDrawCommand.points.clear();
            },
            child: CustomPaint(
              painter: _CanvasPainter(
                clientModel: clientModel,
                canvasId: canvasId,
                localDrawCommand: localDrawCommand,
              ),
              size: size,
            ),
          ),
        );
      },
    );
  }
}

class _CanvasPainter extends CustomPainter {
  _CanvasPainter({
    required this.clientModel,
    required this.canvasId,
    this.localDrawCommand,
  }) : super(repaint: Listenable.merge([clientModel, localDrawCommand]));

  final ClientModel clientModel;
  final LocalDrawCommand? localDrawCommand;
  final int canvasId;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();

    canvas
      ..clipRect(Offset.zero & size)
      ..drawRect(Offset.zero & size, paint..color = _canvasColor);

    for (final command in [
      ...?clientModel.drawCommandsOf(canvasId),
      if (localDrawCommand != null) localDrawCommand!,
    ]) {
      for (final (i, point) in command.points.indexed) {
        if (i == 0) path.moveTo(point.x * size.width, point.y * size.height);
        path.lineTo(point.x * size.width, point.y * size.height);
        path.moveTo(point.x * size.width, point.y * size.height);
      }

      paint
        ..color = command.tool == DrawTool.eraser ? _canvasColor : command.color
        ..strokeWidth = command.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paint);
      path.reset();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
