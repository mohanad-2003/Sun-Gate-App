import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/core/services/location_helper_service.dart';
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

  bool _didPopulateInitialData = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 80);

    if (file == null) return;

    await ref
        .read(profileControllerProvider.notifier)
        .uploadProfilePicture(filePath: file.path);
  }

  String selectedGender = 'male';
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

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).profile;

    firstNameController = TextEditingController(text: profile?.firstName ?? '');
    lastNameController = TextEditingController(text: profile?.lastName ?? '');
    emailController = TextEditingController(text: profile?.email ?? '');
    locationController = TextEditingController(text: profile?.location ?? '');
    selectedGender = (profile?.gender?.isNotEmpty ?? false)
        ? profile!.gender!
        : 'male';

    if ((profile?.location == null || profile!.location!.isEmpty)) {
      _loadCurrentLocation();
    }
    birthDateController = TextEditingController(text: profile?.birthDate ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;
    final loc = AppLocalizations.of(context)!;

    if (profile != null && !_didPopulateInitialData) {
      firstNameController.text = profile.firstName;
      lastNameController.text = profile.lastName;
      emailController.text = profile.email;
      locationController.text = profile.location ?? '';

      selectedGender = (profile.gender?.isNotEmpty ?? false)
          ? profile.gender!
          : 'male';

      _didPopulateInitialData = true;
    }
    ref.listen(profileControllerProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.successMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(loc.userInfo)),
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
                          (profile?.imageUrl != null &&
                              profile!.imageUrl!.isNotEmpty)
                          ? NetworkImage(profile.imageUrl!)
                          : null,
                      child:
                          (profile?.imageUrl == null ||
                              profile!.imageUrl!.isEmpty)
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
                  final DateTime? date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    initialDate:
                        DateTime.tryParse(birthDateController.text) ??
                        DateTime(2000),
                  );

                  if (date != null) {
                    // ❌ حذفنا formatting من UI
                    // ✔ صار في UseCase داخل Controller
                    ref
                        .read(profileControllerProvider.notifier)
                        .updateBirthDate(date);

                    // تحديث UI مباشرة
                    final month = date.month.toString().padLeft(2, '0');
                    final day = date.day.toString().padLeft(2, '0');

                    setState(() {
                      birthDateController.text = "${date.year}-$month-$day";
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
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
                      maxLines: 2,
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
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              if (state.errorMessage != null) ...[
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
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isSaving
                      ? null
                      : () {
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateProfile(
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                gender: selectedGender,
                                location: locationController.text.trim(),
                              );
                        },
                  child: state.isSaving
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
