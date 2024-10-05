import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../entities/command.dart';
import '../../models/client_model.dart';
import '../_widgets/client_canvas.dart';

class ClientCanvasScreen extends StatefulWidget {
  const ClientCanvasScreen({
    required this.clientModel,
    required this.canvasId,
    super.key,
  });

  final int canvasId;
  final ClientModel clientModel;

  @override
  State<ClientCanvasScreen> createState() => _ClientCanvasScreenState();
}

class _ClientCanvasScreenState extends State<ClientCanvasScreen> {
  static const List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.purple,
    Colors.black,
    Colors.white,
  ];

  final _canvasRepaintBoundaryKey = GlobalKey();

  late final _localDrawCommand = LocalDrawCommand(
    canvasId: widget.canvasId,
    color: Colors.black,
    tool: DrawTool.pen,
    strokeWidth: 2,
  );

  @override
  void dispose() {
    _localDrawCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: widget.clientModel,
        child: Scaffold(
          appBar: AppBar(title: const Text('Client Canvas')),
          endDrawerEnableOpenDragGesture: true,
          endDrawer: Drawer(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  //
                  Text(
                    'Menu',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Tools',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      //
                      _MenuTool(
                        isActive: _localDrawCommand.tool == DrawTool.pen,
                        onTap: () {
                          setState(() {
                            _localDrawCommand.tool = DrawTool.pen;
                          });
                        },
                        child: const Icon(
                          FontAwesomeIcons.pen,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 5),

                      _MenuTool(
                        isActive: _localDrawCommand.tool == DrawTool.eraser,
                        onTap: () {
                          setState(() {
                            _localDrawCommand.tool = DrawTool.eraser;
                          });
                        },
                        child: const Icon(
                          FontAwesomeIcons.eraser,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  Text(
                    'Colors',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Wrap(
                    children: _colors
                        .map(
                          (color) => Padding(
                            padding: const EdgeInsets.only(top: 5, right: 5),
                            child: _MenuColorTool(
                              isActive: _localDrawCommand.color == color,
                              onTap: () {
                                setState(() {
                                  _localDrawCommand.color = color;
                                });
                              },
                              color: color,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const Divider(height: 20),

                  Text(
                    'Stroke Width',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Slider(
                    value: _localDrawCommand.strokeWidth,
                    min: 1,
                    max: 40,
                    onChanged: (strokeWidth) {
                      setState(() {
                        _localDrawCommand.strokeWidth = strokeWidth;
                      });
                    },
                  ),

                  const Divider(height: 20),

                  Text(
                    'Actions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      //
                      IconButton(
                        onPressed: () => widget.clientModel.addCommand(
                          UndoCommand(canvasId: widget.canvasId),
                        ),
                        icon: const Icon(Icons.undo_rounded),
                      ),

                      IconButton(
                        onPressed: () => widget.clientModel.addCommand(
                          RedoCommand(canvasId: widget.canvasId),
                        ),
                        icon: const Icon(Icons.redo_rounded),
                      ),

                      IconButton(
                        onPressed: () => widget.clientModel.addCommand(
                          ClearCanvasCommand(canvasId: widget.canvasId),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                      ),

                      IconButton(
                        onPressed: () async {
                          final rpb = _canvasRepaintBoundaryKey.currentContext!
                              .findRenderObject() as RenderRepaintBoundary;

                          final image = await rpb.toImage();

                          final byteData = await image.toByteData(
                              format: ImageByteFormat.png);

                          final bytes = byteData!.buffer.asUint8List();

                          final path = await FilePicker.platform.saveFile(
                            dialogTitle: 'Save canvas',
                            fileName: 'canvas.png',
                            bytes: bytes,
                          );

                          if (Platform.isIOS || path == null) return;

                          await File(path).writeAsBytes(bytes);
                        },
                        icon: const Icon(Icons.image_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: RepaintBoundary(
              key: _canvasRepaintBoundaryKey,
              child: ClientCanvas(
                localDrawCommand: _localDrawCommand,
                canvasId: widget.canvasId,
              ),
            ),
          ),
        ),
      );
}

class _MenuTool extends StatelessWidget {
  const _MenuTool({
    required this.isActive,
    required this.child,
    required this.onTap,
  });

  final bool isActive;
  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 38,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey,
              width: isActive ? 2.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        ),
      );
}

class _MenuColorTool extends StatelessWidget {
  const _MenuColorTool({
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  final bool isActive;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => _MenuTool(
        isActive: isActive,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
}
