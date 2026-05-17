import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sun_gate_app/app/localization/local_provider.dart';

import 'package:sun_gate_app/app/router/app_router.dart';
import 'package:sun_gate_app/core/theme/app_theme.dart';
import 'package:sun_gate_app/core/theme/theme_mode_provider.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/core/notifications/notification_bootstrap.dart';

class SunGateApp extends ConsumerWidget {
  const SunGateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);

    return NotificationBootstrap(
      child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      ),
    );
  }
}
