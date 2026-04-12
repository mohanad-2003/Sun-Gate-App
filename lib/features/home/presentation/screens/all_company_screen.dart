import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/category_chip_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/company_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/section_title_row.dart';

class AllCompanyScreen extends ConsumerWidget {
  const AllCompanyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width < 360 ? 12.0 : 16.0;
            final categoriesHeight = width < 360 ? 96.0 : 108.0;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    8,
                    horizontalPadding,
                    0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Spacer(),
                      Text(
                        'Suppliers',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: HomeSearchBar(
                    hintText: 'Search . . .',
                  ),
                ),

                const SizedBox(height: 18),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const SectionTitleRow(
                    title: 'Category',
                    actionText: '',
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
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SectionTitleRow(
                    title: 'Suppliers List',
                    actionText: 'See all',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      24,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: homeState.companies.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.73,
                    ),
                    itemBuilder: (context, index) {
                      final company = homeState.companies[index];

                      return CompanyCard(
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
            );
          },
        ),
      ),
    );
  }
}