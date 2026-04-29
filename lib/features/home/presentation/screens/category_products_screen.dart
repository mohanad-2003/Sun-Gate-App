import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/extentions/home_localization_extention.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/category_chip_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/product_list_title.dart';

class CategoryProductsScreen extends ConsumerWidget {
  final CategoryItemModel category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    final localizedCategoryTitle = loc.categoryByKey(category.titleKey);

    // final filteredProducts = state.products.where((product) {
    //   return product.tagKeys.contains(category.titleKey);
    // }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(localizedCategoryTitle), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          HomeSearchBar(hintText: loc.search),
          const SizedBox(height: 18),
          Text(
            loc.category,
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
                final item = state.categories[index];
                return CategoryChipCard(
                  category: item,
                  onTap: () {
                    context.pushReplacement(
                      RouteNames.categoryProducts,
                      extra: item,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            localizedCategoryTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          // if (filteredProducts.isEmpty)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 16),
          //     child: Text(
          //       loc.noProductsForCategory,
          //       style: theme.textTheme.bodyMedium,
          //     ),
          //   )
          // else
          //   ...filteredProducts.map(
          //     (product) => ProductListTile(
          //       product: product,
          //       onTap: () {
          //         context.push(RouteNames.productDetail, extra: product);
          //       },
          //     ),
          //  ),
        ],
      ),
    );
  }
}
