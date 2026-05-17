import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/services/location_helper_service.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

class CompanySignUpScreen extends ConsumerStatefulWidget {
  const CompanySignUpScreen({super.key});

  @override
  ConsumerState<CompanySignUpScreen> createState() =>
      _CompanySignUpScreenState();
}

class _CompanySignUpScreenState extends ConsumerState<CompanySignUpScreen> {
  final companyNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final establishmentDateController = TextEditingController();

  bool acceptPolicy = false;
  String documentName = '';
  String logoName = '';
  String? documentPath;
  String? logoPath;
  bool _isSendingCompanyOtp = false;
  final _imagePicker = ImagePicker();

  Future<String> _persistPickedFile(XFile file, String prefix) async {
    final originalFile = File(file.path);
    final appCacheDir = originalFile.parent;
    final appRootDir = appCacheDir.parent;
    final uploadDir = Directory('${appRootDir.path}/files/company_uploads');

    if (!await uploadDir.exists()) {
      await uploadDir.create(recursive: true);
    }

    final extensionIndex = file.name.lastIndexOf('.');
    final extension = extensionIndex >= 0
        ? file.name.substring(extensionIndex)
        : '';
    final targetPath =
        '${uploadDir.path}/${prefix}_${DateTime.now().millisecondsSinceEpoch}$extension';

    final savedFile = await File(file.path).copy(targetPath);
    return savedFile.path;
  }

  String _localizedAuthError(String? message, AppLocalizations loc) {
    if (message == null || message.trim().isEmpty) return '';

    final normalized = message.toLowerCase();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (normalized.contains(
      'cannot create a company account and a user account with the same email',
    )) {
      return isArabic
          ? 'هذا البريد الإلكتروني مستخدم بالفعل في حساب مستخدم عادي. لا يمكنك إنشاء حساب شركة وحساب مستخدم بنفس البريد.'
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

  @override
  void dispose() {
    companyNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    establishmentDateController.dispose();
    super.dispose();
  }

  bool _isPickingImage = false;

  Future<void> _pickDocument() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final persistedPath = await _persistPickedFile(image, 'document');
      if (!mounted) return;
      setState(() {
        documentPath = persistedPath;
        documentName = image.name;
      });
    } on PlatformException catch (e) {
      if (e.code != 'already_active') rethrow;
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _pickLogo() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final persistedPath = await _persistPickedFile(image, 'logo');
      if (!mounted) return;
      setState(() {
        logoPath = persistedPath;
        logoName = image.name;
      });
    } on PlatformException catch (e) {
      if (e.code != 'already_active') rethrow;
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _pickLocation() async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.enableGpsMessage),
          ),
        );
      } else if (message.contains('permission')) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.locationPermissionMessage,
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      setState(() {
        establishmentDateController.text = '${date.year}-$month-$day';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (!_isSendingCompanyOtp) return;

      if (next.action != AuthAction.companySendOtp) return;

      if (next.errorMessage != null) {
        _isSendingCompanyOtp = false;
        return;
      }

      if (!next.isSuccess) return;

      _isSendingCompanyOtp = false;

      context.push(
        RouteNames.otp,
        extra: {
          'email': emailController.text.trim(),
          'flowType': OtpFlowType.companyRegistration,
          'companyRegistrationData': {
            'documentPath': documentPath,
            'logoPath': logoPath,
            'companyName': companyNameController.text.trim(),
            'ownerName': ownerNameController.text.trim(),
            'location': locationController.text.trim(),
            'establishmentDate': establishmentDateController.text.trim(),
            'acceptPrivacyPolicy': acceptPolicy,
          },
        },
      );
    });

    return AuthScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthBackButton(onTap: () => context.go(RouteNames.accountType)),
          const SizedBox(height: 4),
          Text(
            loc.companySignUpTitle,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 28),
          Center(
            child: Column(
              children: [
                Text(
                  loc.companySignUpSubtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  loc.companySignUpSubtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AuthTextField(
            controller: companyNameController,
            label: loc.companyName,
            hintText: loc.enterCompanyName,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: ownerNameController,
            label: loc.ownerName,
            hintText: loc.enterOwnerName,
            onChanged: (_) => setState(() {}),
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
          const SizedBox(height: 14),
          AuthTextField(
            controller: establishmentDateController,
            label: loc.establishmentDate,
            hintText: loc.chooseDate,
            readOnly: true,
            onTap: _pickDate,
            suffixIcon: IconButton(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 14),
          _UploadField(
            label: loc.documentUploadLabel,
            value: documentName,
            emptyText: loc.chooseFile,
            onTap: _pickDocument,
          ),
          const SizedBox(height: 12),
          _UploadField(
            label: loc.logoUploadLabel,
            value: logoName,
            emptyText: loc.chooseFile,
            onTap: _pickLogo,
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
            activeColor: const Color(0xFF274777),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
              ),
              child: Text(
                _localizedAuthError(state.errorMessage, loc),
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 16),
          AuthPrimaryButton(
            text: loc.continues,
            isLoading: state.isLoading,
            onPressed:
                acceptPolicy &&
                    companyNameController.text.isNotEmpty &&
                    ownerNameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    locationController.text.isNotEmpty &&
                    establishmentDateController.text.isNotEmpty &&
                    documentPath != null &&
                    logoPath != null
                ? () {
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterEmail)),
                      );
                      return;
                    }
                    if (companyNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterCompanyName)),
                      );
                      return;
                    }
                    if (ownerNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterFirstName)),
                      );
                      return;
                    }
                    if (documentPath == null || logoPath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select document and logo'),
                        ),
                      );
                      return;
                    }
                    _isSendingCompanyOtp = true;
                    ref
                        .read(authControllerProvider.notifier)
                        .companySendOtp(email: emailController.text.trim());
                  }
                : null,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => context.go(RouteNames.signUp),
              child: Text(loc.signUpAsUser),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadField extends StatelessWidget {
  final String label;
  final String value;
  final String emptyText;
  final VoidCallback onTap;

  const _UploadField({
    required this.label,
    required this.value,
    required this.emptyText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 72,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE4E7EC),
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF274777).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Color(0xFF274777),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value.isEmpty ? emptyText : value,
                    style: TextStyle(
                      fontSize: 14,
                      color: value.isEmpty ? Colors.black45 : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
