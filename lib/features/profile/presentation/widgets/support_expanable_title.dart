import 'package:flutter/material.dart';

class SupportExpandableTile extends StatelessWidget {
  final String title;
  final String content;

  const SupportExpandableTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 10),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.7,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
