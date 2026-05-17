import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/section_title_row.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/company_card.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/product_card.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(marketPlaceControllerProvider.notifier).getCompanies();
      await ref.read(marketPlaceControllerProvider.notifier).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;
    final visibleProducts = state.products.where((product) {
      final status = product.status.trim().toLowerCase();
      return status.isEmpty || status == 'active';
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.market),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(marketPlaceControllerProvider.notifier).getCompanies();

          await ref.read(marketPlaceControllerProvider.notifier).getProducts();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HomeSearchBar(
              hintText: loc.searchInMarket,
            ),

            const SizedBox(height: 20),

            Text(
              loc.marketDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 24),

            // ================= PRODUCTS =================

            SectionTitleRow(
              title: loc.itemsYouCanBuy,
              actionText: '',
              onTap: () {},
            ),

            const SizedBox(height: 14),

            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (visibleProducts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('No products yet'),
                ),
              )
            else
              GridView.builder(
                itemCount: visibleProducts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                itemBuilder: (context, index) {
                  final product = visibleProducts[index];

                  return ProductCard(
                    product: product,
                    onTap: () {
                      context.push(
                        RouteNames.productDetail,
                        extra: product,
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 28),

            // ================= COMPANIES =================

            SectionTitleRow(
              title: loc.popularCompanies,
              actionText: '',
              onTap: () {},
            ),

            const SizedBox(height: 14),

            if (state.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.20),
                  ),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              )
            else if (state.companies.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'No companies yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...state.companies.map(
                (company) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CompanyCard(
                    company: company,
                    onTap: () {
                      context.push(
                        RouteNames.companyDetail,
                        extra: company,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
