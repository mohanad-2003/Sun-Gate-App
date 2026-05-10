import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/localization/local_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';

class CalculatorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CalculatorAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      actions: const [_CalculatorLanguageAction(), SizedBox(width: 6)],
      leading: IconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.main);
          }
        },
        icon: const BackButtonIcon(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalculatorLanguageAction extends ConsumerWidget {
  const _CalculatorLanguageAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final isArabic = locale?.languageCode == 'ar';
    final loc = AppLocalizations.of(context)!;

    return IconButton(
      tooltip: loc.language,
      onPressed: () {
        final notifier = ref.read(appLocaleProvider.notifier);
        if (isArabic) {
          notifier.setEnglish();
        } else {
          notifier.setArabic();
        }
      },
      icon: const Icon(Icons.language_rounded),
    );
  }
}
