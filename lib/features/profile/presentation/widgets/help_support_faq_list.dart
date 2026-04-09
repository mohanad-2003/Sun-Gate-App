import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_faq_title.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_item.dart';

class HelpSupportFaqList extends StatelessWidget {
  const HelpSupportFaqList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      HelpSupportItem(
        question: 'How can I update my profile information?',
        answer:
            'Go to your profile screen, open User Info, edit the fields you want, then press Save Changes.',
      ),
      HelpSupportItem(
        question: 'How do I change my password?',
        answer:
            'Open the Change Password screen from your profile menu, enter your current password and then your new password.',
      ),
      HelpSupportItem(
        question: 'I forgot my password. What should I do?',
        answer:
            'Use the Forgot Password option on the login screen. A reset code will be sent to your registered email address.',
      ),
      HelpSupportItem(
        question: 'How can I upload a new profile picture?',
        answer:
            'Go to User Info and tap on your current profile image. Then choose a new image and save your changes.',
      ),
      HelpSupportItem(
        question: 'Why can’t I log into my account?',
        answer:
            'Make sure your email and password are correct. If your email is not verified yet, complete email verification first.',
      ),
      HelpSupportItem(
        question: 'How can I contact support?',
        answer:
            'You can contact our support team through the contact information shown at the bottom of this page.',
      ),
    ];

    return Column(
      children: List.generate(
        items.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12),
          child: HelpSupportFaqTile(
            question: items[index].question,
            answer: items[index].answer,
          ),
        ),
      ),
    );
  }
}
