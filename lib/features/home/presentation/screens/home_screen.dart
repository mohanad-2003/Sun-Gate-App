import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_bottom_nav_provider.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/category_chip_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/company_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_header_section.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/section_title_row.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(profileControllerProvider.notifier).getMyProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);
    final currentIndex = ref.watch(homeBotomNavProvider);
    final profileState = ref.watch(profileControllerProvider);

    final userName = profileState.profile?.firstName.trim().isNotEmpty == true
        ? profileState.profile!.firstName
        : 'User';

    final imagePath =
        profileState.profile?.profileImage?.trim().isNotEmpty == true
        ? profileState.profile?.profileImage
        : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeHeaderSection(
                      userName: userName,
                      imagePath: imagePath ?? '',
                      onBannerTap: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                      child: SectionTitleRow(
                        title: 'Category',
                        actionText: '',
                        onTap: () {},
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 108,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        scrollDirection: Axis.horizontal,
                        itemCount: homeState.categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return CategoryChipCard(
                            category: homeState.categories[index],
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: SectionTitleRow(
                        title: 'Popular Companies',
                        actionText: 'See all',
                        onTap: () {},
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return CompanyCard(
                          company: homeState.companies[index],
                          onTap: () {},
                        );
                      }, childCount: homeState.companies.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.73,
                          ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(homeBotomNavProvider.notifier).state = index;

          if (index == 4) {
            context.push(RouteNames.profile);
          }
        },
      ),
    );
  }
}
