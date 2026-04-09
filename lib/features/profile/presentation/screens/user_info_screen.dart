import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_gender_selector.dart';
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
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 80);

    if (file == null) return;

    await ref
        .read(profileControllerProvider.notifier)
        .uploadProfilePicture(filePath: file.path);
  }

  String selectedGender = 'male';

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
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;

    ref.listen(profileControllerProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.successMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
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
                                        const Text(
                                          'Change your picture',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                          title: const Text('Take a photo'),
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
                                          title: const Text(
                                            'Choose from your file',
                                          ),
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

              const ProfileSectionLabel(title: 'First Name'),
              const SizedBox(height: 8),
              TextField(controller: firstNameController),
              const SizedBox(height: 16),

              const ProfileSectionLabel(title: 'Last Name'),
              const SizedBox(height: 8),
              TextField(controller: lastNameController),
              const SizedBox(height: 16),

              const ProfileSectionLabel(title: 'Email'),
              const SizedBox(height: 8),
              TextField(controller: emailController, enabled: false),
              const SizedBox(height: 16),

              const ProfileSectionLabel(title: 'Gender'),
              const SizedBox(height: 8),
              ProfileGenderSelector(
                selectedGender: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              const ProfileSectionLabel(title: 'Location'),
              const SizedBox(height: 8),
              TextField(
                controller: locationController,
                maxLines: 4,
                minLines: 4,
              ),
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
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
