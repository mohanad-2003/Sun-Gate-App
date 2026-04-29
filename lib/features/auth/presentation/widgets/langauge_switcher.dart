import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/app/localization/local_provider.dart';

class LanguageSwitcherButton extends ConsumerWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);

    final isArabic = locale?.languageCode == 'ar';

    return InkWell(
      onTap: () async {
        if (isArabic) {
          await ref.read(appLocaleProvider.notifier).setEnglish();
        } else {
          await ref.read(appLocaleProvider.notifier).setArabic();
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16),
            const SizedBox(width: 4),
            Text(
              isArabic ? 'AR' : 'EN',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
