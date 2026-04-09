import 'package:flutter/material.dart';

class AuthBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const AuthBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      ),
    );
  }
}