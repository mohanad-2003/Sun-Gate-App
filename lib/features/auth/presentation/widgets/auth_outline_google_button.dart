import 'package:flutter/material.dart';

class AuthOutlineGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuthOutlineGoogleButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,

      borderRadius: BorderRadius.circular(12),

      child: Container(
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: const Text('Continue with Google'),
      ),
    );
  }
}