import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/category_chip_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/company_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_search_bar.dart';

class AllCompanyScreen extends ConsumerWidget {
  const AllCompanyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HomeSearchBar(hintText: 'Search . . .'),
            const SizedBox(height: 18),
            Text(
              'Category',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
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
            Row(
              children: [
                Text(
                  'Suppliers List',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('See all')),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              itemCount: state.companies.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.73,
              ),
              itemBuilder: (context, index) {
                final company = state.companies[index];
                return CompanyCard(
                  company: company,
                  onTap: () {
                    context.push(RouteNames.companyDetail, extra: company);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
