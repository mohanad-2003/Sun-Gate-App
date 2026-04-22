import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_faq_title.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/help_support_item.dart';

class HelpSupportFaqList extends StatelessWidget {
  const HelpSupportFaqList({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final items = [
      HelpSupportItem(
        question: loc.faqUpdateProfileQuestion,
        answer: loc.faqUpdateProfileAnswer,
      ),
      HelpSupportItem(
        question: loc.faqChangePasswordQuestion,
        answer: loc.faqChangePasswordAnswer,
      ),
      HelpSupportItem(
        question: loc.faqForgotPasswordQuestion,
        answer: loc.faqForgotPasswordAnswer,
      ),
      HelpSupportItem(
        question: loc.faqUploadProfileImageQuestion,
        answer: loc.faqUploadProfileImageAnswer,
      ),
      HelpSupportItem(
        question: loc.faqCantLoginQuestion,
        answer: loc.faqCantLoginAnswer,
      ),
      HelpSupportItem(
        question: loc.faqContactSupportQuestion,
        answer: loc.faqContactSupportAnswer,
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