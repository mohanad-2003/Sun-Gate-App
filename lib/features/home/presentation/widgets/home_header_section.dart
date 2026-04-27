import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/category_chip_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/company_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_app_bar_section.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_banner_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/section_title_row.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/market_place_company_card.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class HomeHeaderSection extends ConsumerWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final homeState = ref.watch(homeControllerProvider);
    final theme = Theme.of(context);
    final previewCompanies = homeState.companies.take(2).toList();

    final userName = _resolveUserName(
      profileState.profile?.firstName.isNotEmpty == true
          ? profileState.profile!.firstName
          : profileState.profile?.fullName,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width < 360 ? 12.0 : 16.0;
        final headerHeight = width < 360 ? 220.0 : 270.0;
        final categoriesHeight = width < 360 ? 96.0 : 108.0;
        final loc = AppLocalizations.of(context)!;
        return Column(
          children: [
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: -20,
                    child: Image.asset(
                      'assets/images/home_header_pg2.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Container(color: const Color(0xFF314E7E));
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.08),
                            Colors.black.withOpacity(0.18),
                            Colors.black.withOpacity(0.32),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: HomeAppBarSection(userName: userName),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        theme.brightness == Brightness.dark ? 0.28 : 0.08,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        4,
                        horizontalPadding,
                        0,
                      ),
                      child: HomeBannerCard(
                        onTap: () {
                          context.push(RouteNames.market);
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: SectionTitleRow(
                        title: loc.category,
                        actionText: '',
                        onTap: () {},
                      ),
                    ),

                    SizedBox(
                      height: categoriesHeight,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          0,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: homeState.categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = homeState.categories[index];

                          return CategoryChipCard(
                            category: category,
                            onTap: () {
                              context.push(
                                RouteNames.categoryProducts,
                                extra: category,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: SectionTitleRow(
                        title: loc.popularCompanies,
                        actionText: loc.seeAll,
                        onTap: () {
                          context.push(RouteNames.allCompanies);
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        20,
                      ),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: previewCompanies.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.80,
                            ),
                        itemBuilder: (context, index) {
                          final company = homeState.companies[index];

                          return MarketplaceCompanyCard(
                            company: company,
                            onTap: () {
                              context.push(
                                RouteNames.companyDetail,
                                extra: company,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _resolveUserName(String? firstName) {
    if (firstName == null) return 'User';
    final trimmed = firstName.trim();
    if (trimmed.isEmpty) return 'User';
    return trimmed;
  }
}
