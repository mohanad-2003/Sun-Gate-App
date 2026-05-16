import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/core/services/location_helper_service.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_section_label.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController locationController;
  late final TextEditingController birthDateController;
  late final TextEditingController ownerController;
  late final TextEditingController descriptionController;
  late final TextEditingController companyLocationController;
  late final TextEditingController phoneController;
  late final TextEditingController establishmentDateController;
  late final TextEditingController engineerNumberController;

  String selectedGender = 'male';
  bool _didPopulateUserData = false;
  bool _didPopulateCompanyData = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 80);

    if (file == null) return;

    final myCompany = ref.read(marketPlaceControllerProvider).myCompany;
    if (myCompany != null) {
      final logo = myCompany.logo;
      if (logo != null && logo.isNotEmpty) {
        await NetworkImage(logo).evict();
      }
      await ref
          .read(marketPlaceControllerProvider.notifier)
          .uploadCompanyLogo(filePath: file.path);
      return;
    }

    await ref
        .read(profileControllerProvider.notifier)
        .uploadProfilePicture(filePath: file.path);
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final location = await LocationHelper.getCurrentLocationName();

      if (!mounted) return;

      setState(() {
        locationController.text = location;
      });
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  Future<void> _pickCompanyEstablishmentDate() async {
    final currentDate =
        DateTime.tryParse(establishmentDateController.text) ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date == null || !mounted) return;

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    setState(() {
      establishmentDateController.text = '${date.year}-$month-$day';
    });
  }

  String _dateOnly(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).profile;
    final marketState = ref.read(marketPlaceControllerProvider);
    final myCompany = marketState.myCompany;

    firstNameController = TextEditingController(text: profile?.firstName ?? '');
    lastNameController = TextEditingController(text: profile?.lastName ?? '');
    emailController = TextEditingController(text: profile?.email ?? '');
    locationController = TextEditingController(text: profile?.location ?? '');
    birthDateController = TextEditingController(text: profile?.birthDate ?? '');

    selectedGender = (profile?.gender?.isNotEmpty ?? false)
        ? profile!.gender!
        : 'male';

    ownerController = TextEditingController(text: myCompany?.ownerName ?? '');
    descriptionController = TextEditingController(
      text: myCompany?.description ?? '',
    );
    companyLocationController = TextEditingController(
      text: myCompany?.address ?? '',
    );
    phoneController = TextEditingController(text: myCompany?.phone ?? '');
    establishmentDateController = TextEditingController(
      text: _dateOnly(myCompany?.establishmentDate ?? ''),
    );
    engineerNumberController = TextEditingController(
      text: myCompany?.engineerNumber ?? '',
    );

    if (profile?.location == null || profile!.location!.isEmpty) {
      _loadCurrentLocation();
    }

    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getMyProfile();
      ref.read(marketPlaceControllerProvider.notifier).getMyCompany();
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    birthDateController.dispose();
    ownerController.dispose();
    descriptionController.dispose();
    companyLocationController.dispose();
    phoneController.dispose();
    establishmentDateController.dispose();
    engineerNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;
    final marketState = ref.watch(marketPlaceControllerProvider);
    final myCompany = marketState.myCompany;
    final shouldUseCompanyProfile = myCompany != null;
    final loc = AppLocalizations.of(context)!;

    if (profile != null && !_didPopulateUserData) {
      firstNameController.text = profile.firstName;
      lastNameController.text = profile.lastName;
      emailController.text = profile.email;
      locationController.text = profile.location ?? '';
      birthDateController.text = profile.birthDate ?? '';
      selectedGender = (profile.gender?.isNotEmpty ?? false)
          ? profile.gender!
          : 'male';
      _didPopulateUserData = true;
    }

    if (myCompany != null && !_didPopulateCompanyData) {
      ownerController.text = myCompany.ownerName;
      descriptionController.text = myCompany.description ?? '';
      companyLocationController.text = myCompany.address;
      phoneController.text = myCompany.phone;
      engineerNumberController.text = myCompany.engineerNumber ?? '';
      establishmentDateController.text = _dateOnly(
        myCompany.establishmentDate ?? '',
      );
      _didPopulateCompanyData = true;
    }

    ref.listen(profileControllerProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.successMessage!)));
      }
    });

    ref.listen(marketPlaceControllerProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.successMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(shouldUseCompanyProfile ? loc.companyInfo : loc.userInfo),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage:
                          shouldUseCompanyProfile &&
                              myCompany.logo != null &&
                              myCompany.logo!.isNotEmpty
                          ? NetworkImage(myCompany.logo!)
                          : (!shouldUseCompanyProfile &&
                                profile?.imageUrl?.isNotEmpty == true)
                          ? NetworkImage(profile!.imageUrl!)
                          : null,
                      child:
                          (shouldUseCompanyProfile &&
                                  (myCompany.logo == null ||
                                      myCompany.logo!.isEmpty)) ||
                              (!shouldUseCompanyProfile &&
                                  (profile?.imageUrl == null ||
                                      profile?.imageUrl?.isEmpty == true))
                          ? const Icon(Icons.person, size: 32)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 14,
                          color: Colors.white,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              builder: (_) {
                                return SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          loc.changeYourPicture,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                          title: Text(loc.takePhoto),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await _pickImage(
                                              ImageSource.camera,
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.folder_outlined,
                                          ),
                                          title: Text(loc.chooseFromFiles),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await _pickImage(
                                              ImageSource.gallery,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (shouldUseCompanyProfile) ...[
                ProfileSectionLabel(title: loc.owner),
                const SizedBox(height: 8),
                TextField(controller: ownerController),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.description),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.location),
                const SizedBox(height: 8),
                TextField(controller: companyLocationController),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.mobileNumber),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.establishmentDate),
                const SizedBox(height: 8),
                TextField(
                  controller: establishmentDateController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.engineerNumber),
                const SizedBox(height: 8),
                TextField(
                  controller: engineerNumberController,
                  enabled: false,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
              ] else ...[
                ProfileSectionLabel(title: loc.firstName),
                const SizedBox(height: 8),
                TextField(controller: firstNameController),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.lastName),
                const SizedBox(height: 8),
                TextField(controller: lastNameController),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.email),
                const SizedBox(height: 8),
                TextField(controller: emailController, enabled: false),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.birthDate),
                const SizedBox(height: 8),
                TextField(
                  controller: birthDateController,
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (date != null) {
                      ref
                          .read(profileControllerProvider.notifier)
                          .updateBirthDate(date);

                      final month = date.month.toString().padLeft(2, '0');
                      final day = date.day.toString().padLeft(2, '0');

                      setState(() {
                        birthDateController.text = '${date.year}-$month-$day';
                      });
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.edit_calendar),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ProfileSectionLabel(title: loc.location),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: locationController,
                        maxLines: 1,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: loc.location,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 20),
              if (state.errorMessage != null ||
                  marketState.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    state.errorMessage ?? marketState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isSaving || marketState.isSaving
                      ? null
                      : () {
                          if (shouldUseCompanyProfile) {
                            final request = UpdateCompanyRequestDto(
                              ownerName: ownerController.text.trim(),
                              description: descriptionController.text.trim(),
                              address: companyLocationController.text.trim(),
                              phone: phoneController.text.trim(),
                            );

                            ref
                                .read(marketPlaceControllerProvider.notifier)
                                .updateCompany(request);
                          } else {
                            ref
                                .read(profileControllerProvider.notifier)
                                .updateProfile(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  gender: selectedGender,
                                  location: locationController.text.trim(),
                                );
                          }
                        },
                  child: (state.isSaving || marketState.isSaving)
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(loc.saveChanges),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
