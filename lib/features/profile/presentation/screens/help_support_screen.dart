import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/core/widgets/app_scaffold.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_contact_card.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_faq_list.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_header.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_search_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: const _HelpSupportBody(),
    );
  }
}

class _HelpSupportBody extends StatelessWidget {
  const _HelpSupportBody();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        const _HelpSupportAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HelpSupportHeader(
                  title: loc.helpSupportCenterTitle,
                  subtitle: loc.helpSupportCenterSubtitle,
                ),
                const SizedBox(height: 16),
                const HelpSupportSearchBar(),
                const SizedBox(height: 16),
                const HelpSupportFaqList(),
                const SizedBox(height: 20),
                HelpSupportContactCard(
                  title: loc.stillNeedHelp,
                  email: 'support@sungate.com',
                  phone: '+970 59 000 0000',
                  note: loc.helpSupportContactNote,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpSupportAppBar extends StatelessWidget {
  const _HelpSupportAppBar();

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
              loc.helpSupportTitle,
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