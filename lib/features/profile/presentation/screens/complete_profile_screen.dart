import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();      
  String gender = 'male';

  @override
  void dispose() {
    birthDateController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(profileControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Birth Date
            TextField(
              controller: birthDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Birth Date",
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: DateTime(2000),
                );

                if (date != null) {
                  final formatted = "${date.year}-${date.month}-${date.day}";

                  birthDateController.text = formatted;
                }
              },
            ),

            const SizedBox(height: 16),

            ///  Location
            TextField(
              controller: locationController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Location",
                prefixIcon: Icon(Icons.location_on),
              ),
              onTap: () async {
                final location = await controller
                    .getLocationForCompleteProfile();

                locationController.text = location;
              },
            ),

            const SizedBox(height: 16),

            ///  Gender
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Male"),
                    value: "male",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() => gender = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Female"),
                    value: "female",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() => gender = value!);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ///  Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isSaving
                    ? null
                    : () async {
                        await controller.updateProfile(
                          birthDate: birthDateController.text,
                          location: locationController.text,
                          gender: gender,
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                child: state.isSaving
                    ? const CircularProgressIndicator()
                    : const Text("Save & Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
