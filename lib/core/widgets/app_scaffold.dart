import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool useSafeArea;

  const AppScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = useSafeArea ? SafeArea(child: child) : child;

    return Scaffold(backgroundColor: backgroundColor, body: body);
  }
}
