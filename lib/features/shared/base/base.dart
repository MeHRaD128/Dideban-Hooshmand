import 'package:flutter/material.dart';

class Base extends StatelessWidget {
  final Widget child;
  final double minWidth;
  final EdgeInsets padding;

  const Base({
    super.key,
    required this.child,
    this.minWidth = 400,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
