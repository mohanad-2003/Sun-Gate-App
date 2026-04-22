import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/core/widgets/app_scaffold.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_contact_card.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_header_card.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_section_list.dart';

class LegalPoliciesScreen extends StatelessWidget {
  const LegalPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: const _LegalPoliciesBody(),
    );
  }
}

class _LegalPoliciesBody extends StatelessWidget {
  const _LegalPoliciesBody();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        const _LegalPoliciesAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LegalHeaderCard(
                  title: loc.legalCenterTitle,
                  subtitle: loc.legalCenterSubtitle,
                  lastUpdated: loc.lastUpdated,
                ),
                const SizedBox(height: 16),
                const LegalPolicySectionList(),
                const SizedBox(height: 20),
                LegalContactCard(
                  title: loc.needHelp,
                  note: loc.legalSupportNote,
                  email: 'support@sungate.com',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LegalPoliciesAppBar extends StatelessWidget {
  const _LegalPoliciesAppBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              loc.legal_and_policies,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}