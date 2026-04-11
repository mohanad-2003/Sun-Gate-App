import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
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

    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getMyProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: homeState.isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : SafeArea(
              bottom: false,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeHeaderSection(onBannerTap: () {}),
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
                            onTap: () {
                              context.push(
                                RouteNames.categoryProducts,
                                extra: homeState.categories[index],
                              );
                            },
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
                        onTap: () {
                          context.push(RouteNames.allComopanies);
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return CompanyCard(
                          company: homeState.companies[index],
                          onTap: () {
                            context.push(
                              RouteNames.companyDetail,
                              extra: homeState.companies[index],
                            );
                          },
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
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                ],
              ),
            ),
    );
  }
}
