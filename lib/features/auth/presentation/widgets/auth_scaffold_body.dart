import 'package:flutter/material.dart';

class AuthScaffoldBody extends StatelessWidget {
  final Widget child;

  const AuthScaffoldBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}