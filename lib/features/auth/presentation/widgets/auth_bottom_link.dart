import 'package:flutter/material.dart';

class AuthBottomLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF274777),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}