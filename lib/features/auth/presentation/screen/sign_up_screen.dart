import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/services/location_helper_service.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
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
    final locationText = locationController.text;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.registrationSuccess)));
        context.push(
          RouteNames.newPassword,
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
                  AuthBackButton(onTap: () => context.go('/login')),
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
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                initialDate: DateTime(2000),
              );

              if (date != null) {
                final month = date.month.toString().padLeft(2, '0');
                final day = date.day.toString().padLeft(2, '0');

                birthDateController.text = "${date.year}-$month-$day";
              }
            },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: locationController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: loc.location,
              suffixIcon: const Icon(Icons.location_on),
            ),
            onTap: () async {
              try {
                final location = await LocationHelper.getCurrentLocationName();
                locationController.text = location;
              } catch (e) {
                print(e);

                final message = e.toString();

                if (message.contains('disabled')) {
                  await Geolocator.openLocationSettings();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء تفعيل الموقع (GPS)')),
                  );
                } else if (message.contains('permission')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إعطاء إذن الموقع')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('فشل في جلب الموقع')),
                  );
                }
              }
            },
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
                state.errorMessage!,
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
                    ref
                        .read(authControllerProvider.notifier)
                        .register(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: emailController.text.trim(),
                          birthDate: birthDateController.text.trim(),

                          location: (locationText.isNotEmpty)
                              ? locationText.trim()
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
