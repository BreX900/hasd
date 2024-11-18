import 'package:flutter/material.dart';

class FieldPadding extends StatelessWidget {
  final Widget child;

  const FieldPadding(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: child,
    );
  }
}
