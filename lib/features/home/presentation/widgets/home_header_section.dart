import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_app_bar_section.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_banner_card.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class HomeHeaderSection extends ConsumerWidget {
  final VoidCallback onBannerTap;

  const HomeHeaderSection({super.key, required this.onBannerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;

    final userName = _getUserName(profile);
    final imageUrl = _getUserImage(profile);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/p.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBarSection(userName: userName, imageUrl: imageUrl),
              const SizedBox(height: 18),
              HomeBannerCard(onTap: onBannerTap),
            ],
          ),
        ),
      ),
    );
  }

  String _getUserName(dynamic profile) {
    if (profile == null) return 'User';

    final firstName = (profile.firstName ?? '').toString().trim();
    final fullName = (profile.fullName ?? '').toString().trim();

    if (firstName.isNotEmpty) return firstName;
    if (fullName.isNotEmpty) return fullName;

    return 'User';
  }

  String? _getUserImage(dynamic profile) {
    if (profile == null) return null;

    final imageUrl = profile.imageUrl?.toString().trim();
    final profileImage = profile.profileImage?.toString().trim();

    if (imageUrl != null && imageUrl.isNotEmpty) return imageUrl;
    if (profileImage != null && profileImage.isNotEmpty) return profileImage;

    return null;
  }
}
