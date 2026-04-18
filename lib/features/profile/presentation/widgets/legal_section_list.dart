import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_policy_item.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_section_card.dart';

class LegalPolicySectionList extends StatelessWidget {
  const LegalPolicySectionList({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final sections = [
      LegalPolicyItem(
        title: loc.termsOfUseTitle,
        content: loc.termsOfUseContent,
      ),
      LegalPolicyItem(
        title: loc.privacyPolicyTitle,
        content: loc.privacyPolicyContent,
      ),
      LegalPolicyItem(
        title: loc.accountSecurityTitle,
        content: loc.accountSecurityContent,
      ),
      LegalPolicyItem(
        title: loc.userContentDataTitle,
        content: loc.userContentDataContent,
      ),
      LegalPolicyItem(
        title: loc.serviceChangesTitle,
        content: loc.serviceChangesContent,
      ),
      LegalPolicyItem(
        title: loc.policyUpdatesTitle,
        content: loc.policyUpdatesContent,
      ),
    ];

    return Column(
      children: List.generate(
        sections.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index == sections.length - 1 ? 0 : 12,
          ),
          child: LegalSectionCard(
            title: sections[index].title,
            content: sections[index].content,
          ),
        ),
      ),
    );
  }
}