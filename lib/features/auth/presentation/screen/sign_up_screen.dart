import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/services/location_helper_service.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/langauge_switcher.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final genderController = TextEditingController();

  bool acceptPolicy = false;
  bool obscurePassword = true;

  String _localizedAuthError(String? message, AppLocalizations loc) {
    if (message == null || message.trim().isEmpty) return '';

    final normalized = message.toLowerCase();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (normalized.contains('cannot create a user account and a company account with the same email')) {
      return isArabic
          ? 'هذا البريد الإلكتروني مستخدم بالفعل في حساب شركة. لا يمكنك إنشاء حساب مستخدم عادي وحساب شركة بنفس البريد.'
          : message;
    }

    if (normalized.contains('email is already used by another account') ||
        normalized.contains('email already exists') ||
        normalized.contains('already linked to another account')) {
      return isArabic
          ? 'هذا البريد الإلكتروني مستخدم بالفعل في حساب آخر.'
          : message;
    }

    return message;
  }

  Future<void> _pickBirthDate() async {
    final currentDate =
        DateTime.tryParse(birthDateController.text) ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: currentDate,
    );

    if (date == null || !mounted) return;

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    setState(() {
      birthDateController.text = "${date.year}-$month-$day";
    });
  }

  Future<void> _pickLocation() async {
    final loc = AppLocalizations.of(context)!;

    try {
      final location = await LocationHelper.getCurrentLocationName();
      if (!mounted) return;

      setState(() {
        locationController.text = location;
      });
    } catch (e) {
      final message = e.toString();

      if (message.contains('disabled')) {
        await Geolocator.openLocationSettings();
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.enableGpsMessage)));
      } else if (message.contains('permission')) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.locationPermissionMessage)),
        );
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    locationController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loc = AppLocalizations.of(context)!;

    ref.listen(authControllerProvider, (previous, next) {
      if (!context.mounted) return;

      if (next.action == AuthAction.register && next.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.registrationSuccess)));

        context.push(
          RouteNames.otp,
          extra: {
            'email': emailController.text.trim(),
            'flowType': OtpFlowType.verifyEmail,
          },
        );
      }
    });
    return AuthScaffoldBody(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AuthBackButton(onTap: () => context.go('/account-type')),
                  const LanguageSwitcherButton(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            loc.signUpTitle,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 26),
          AuthHeader(
            title: loc.completeAccountTitle,
            subtitle: loc.createNewAccount,
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: AuthTextField(
                  controller: firstNameController,
                  label: loc.firstName,
                  hintText: loc.enterFirstName,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AuthTextField(
                  controller: lastNameController,
                  label: loc.lastName,
                  hintText: loc.enterLastName,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: emailController,
            label: loc.emailAddress,
            hintText: loc.enterEmail,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: birthDateController,
            label: loc.birthDate,
            hintText: loc.enterBirthDate,
            readOnly: true,
            onTap: _pickBirthDate,
            suffixIcon: IconButton(
              onPressed: _pickBirthDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: locationController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: loc.location,
              hintText: loc.enterLocation,
              suffixIcon: const Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
              ),
            ),
            onTap: _pickLocation,
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: acceptPolicy,
            onChanged: (value) {
              setState(() {
                acceptPolicy = value ?? false;
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(loc.acceptPolicy, style: const TextStyle(fontSize: 12)),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.20)),
              ),
              child: Text(
                _localizedAuthError(state.errorMessage, loc),
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 12),
          AuthPrimaryButton(
            text: loc.signUpTitle,
            isLoading: state.isLoading,
            onPressed: acceptPolicy
                ? () {
                    final email = emailController.text.trim();

                    if (firstNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterFirstName)),
                      );
                      return;
                    }

                    if (lastNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterLastName)),
                      );
                      return;
                    }

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterEmail)),
                      );
                      return;
                    }
                    ref.read(authControllerProvider.notifier).register(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                      birthDate: birthDateController.text.trim(),
                      location: locationController.text.trim().isNotEmpty
                          ? locationController.text.trim()
                          : null,
                    );
                  }
                : null,
          ),
          const SizedBox(height: 20),
          AuthBottomLink(
            text: loc.alreadyHaveAccount,
            actionText: loc.login,
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
