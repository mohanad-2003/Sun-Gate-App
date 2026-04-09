import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_policy_item.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/legal_section_card.dart';

class LegalPolicySectionList extends StatelessWidget {
  const LegalPolicySectionList({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      LegalPolicyItem(
        title: '1. Terms of Use',
        content:
            'By using SunGate, you agree to comply with the application terms, applicable laws, and responsible usage of all available features. Users are expected to provide accurate account information and avoid misuse of the platform.',
      ),
      LegalPolicyItem(
        title: '2. Privacy Policy',
        content:
            'We collect only the information necessary to provide and improve our services. This may include account details, profile information, and usage-related data. We do not sell your personal information to third parties.',
      ),
      LegalPolicyItem(
        title: '3. Account and Security',
        content:
            'You are responsible for maintaining the confidentiality of your login credentials. Any activity performed through your account is considered your responsibility unless reported otherwise.',
      ),
      LegalPolicyItem(
        title: '4. User Content and Data',
        content:
            'Any data, profile information, images, or content uploaded by the user must be lawful, accurate, and appropriate. We reserve the right to remove content that violates our service guidelines.',
      ),
      LegalPolicyItem(
        title: '5. Changes to the Service',
        content:
            'SunGate may update, improve, suspend, or modify parts of the service at any time to enhance the user experience, maintain security, or comply with technical and legal requirements.',
      ),
      LegalPolicyItem(
        title: '6. Policy Updates',
        content:
            'We may revise these legal policies from time to time. Updated versions will be reflected inside the application with a new last-updated date. Continued use of the service means acceptance of the revised policies.',
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
