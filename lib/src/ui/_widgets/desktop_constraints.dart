import 'package:flutter/material.dart';

class DesktopConstraints extends StatelessWidget {
  const DesktopConstraints({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      );
}
