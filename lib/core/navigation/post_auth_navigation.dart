import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

Future<void> navigateAfterAuthentication(
  BuildContext context,
  WidgetRef ref,
) async {
  await ref.read(profileControllerProvider.notifier).getMyProfile();

  if (!context.mounted) return;

  final profile = ref.read(profileControllerProvider).profile;
  if (profile?.isAdmin ?? false) {
    context.go(RouteNames.adminMain);
    return;
  }

  await ref.read(marketPlaceControllerProvider.notifier).getMyCompany();

  if (!context.mounted) return;

  context.go(RouteNames.main);
}
