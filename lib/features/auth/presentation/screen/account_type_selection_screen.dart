import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

class AccountTypeSelectionScreen extends ConsumerWidget {
  const AccountTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return AuthScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AuthBackButton(onTap: () => context.go(RouteNames.login)),
          ),
          const SizedBox(height: 70),
          Text(
            loc.selectAccountTypeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            loc.selectAccountTypeSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 48),
          _AccountTypeButton(
            title: loc.userAccount,
            isPrimary: true,
            onTap: () => context.push(RouteNames.signUp),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Or create as',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 24),
          _AccountTypeButton(
            title: loc.companyAccount,
            isPrimary: false,
            onTap: () => context.push(RouteNames.companySignUp),
          ),
          const SizedBox(height: 80),
          Text(
            loc.selectAccountTypeSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeButton extends StatelessWidget {
  final String title;
  final bool isPrimary;
  final VoidCallback onTap;

  const _AccountTypeButton({
    required this.title,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF274777) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF274777)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isPrimary ? Colors.white : const Color(0xFF274777),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
