import 'package:flutter/material.dart';

class ProfileSectionLabel extends StatelessWidget {
  final String title;

  const ProfileSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
