import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';

class AuthOutlineGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuthOutlineGoogleButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(loc.continueWithGoogle),
      ),
    );
  }
}