import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_app_bar_section.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_banner_card.dart';

class HomeHeaderSection extends StatelessWidget {
  final String userName;
  final String imagePath;
  final VoidCallback onBannerTap;

  const HomeHeaderSection({
    super.key,
    required this.userName,
    required this.imagePath,
    required this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 270,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/company_sungrid.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: HomeAppBarSection(
                userName: userName,
                imagePath: imagePath,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: HomeBannerCard(onTap: onBannerTap),
          ),
        ],
      ),
    );
  }
}
