import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';

class AuthOutlineGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuthOutlineGoogleButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: theme.cardColor,
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.splashColor,
          highlightColor: theme.highlightColor,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor, width: 1.2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    loc.continueWithGoogle,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge!.color,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                Align(
                  alignment: Directionality.of(context) == TextDirection.rtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Image.asset(
                      'assets/images/google.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
