import 'package:flutter/material.dart';

class SectionTitleRow extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const SectionTitleRow({
    super.key,
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF252525),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionText.isNotEmpty)
          InkWell(
            onTap: onTap,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}