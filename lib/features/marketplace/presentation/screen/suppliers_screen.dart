import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/product_card.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  String _selectedCategory = 'all';
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(marketPlaceControllerProvider.notifier);
      final state = ref.read(marketPlaceControllerProvider);

      if (state.myCompany == null) {
        await controller.getMyCompany();
      }
      await controller.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final products = _supplierProducts(state.products);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.suppliers),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = ref.read(marketPlaceControllerProvider.notifier);
          await controller.getMyCompany();
          await controller.getProducts();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SupplierHeader(
                      productsCount: products.length,
                      isArabic: isArabic,
                    ),
                    const SizedBox(height: 16),
                    HomeSearchBar(
                      hintText: loc.searchInMarket,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    const SizedBox(height: 16),
                    _CategorySelector(
                      selectedCategory: _selectedCategory,
                      isArabic: isArabic,
                      onChanged: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isArabic
                          ? 'منتجات الشركات الأخرى'
                          : 'Products from other companies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isArabic
                          ? 'هنا تظهر المنتجات التي لم تضفها شركتك الحالية.'
                          : 'Only products that do not belong to your current company are shown here.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 14),
                      _ErrorBox(message: state.errorMessage!),
                    ],
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            if (state.isLoading && products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptySuppliersState(isArabic: isArabic),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push(
                          RouteNames.productDetail,
                          extra: product,
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.62,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<ProductEntity> _supplierProducts(List<ProductEntity> products) {
    return products.where((product) {
      if (_isCurrentCompanyProduct(product)) return false;
      if (!_matchesCategory(product)) return false;
      return _matchesQuery(product);
    }).toList();
  }

  bool _isCurrentCompanyProduct(ProductEntity product) {
    final state = ref.read(marketPlaceControllerProvider);
    final myCompanyId = state.myCompany?.id.trim() ?? '';
    final productId = product.id.trim();

    if (myCompanyId.isNotEmpty &&
        state.ownedProductKeys.contains('$myCompanyId:$productId')) {
      return true;
    }

    if (product.isOwnedByCurrentUser == true) return true;

    final ownerCompanyId = product.ownerCompanyId?.trim() ?? '';
    return myCompanyId.isNotEmpty &&
        ownerCompanyId.isNotEmpty &&
        ownerCompanyId == myCompanyId;
  }

  bool _matchesCategory(ProductEntity product) {
    if (_selectedCategory == 'all') return true;

    final category = product.category.toLowerCase();
    switch (_selectedCategory) {
      case 'battery':
        return category.contains('battery') || category.contains('بطار');
      case 'panels':
        return category.contains('panel') || category.contains('لوح');
      case 'inverter':
        return category.contains('inverter') || category.contains('انفرتر');
      default:
        return true;
    }
  }

  bool _matchesQuery(ProductEntity product) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return true;

    return product.title.toLowerCase().contains(query) ||
        product.description.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query);
  }
}

class _SupplierHeader extends StatelessWidget {
  final int productsCount;
  final bool isArabic;

  const _SupplierHeader({
    required this.productsCount,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'سوق الموردين' : 'Supplier Marketplace',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? '$productsCount منتج متاح من شركات أخرى'
                      : '$productsCount products available from other companies',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final bool isArabic;
  final ValueChanged<String> onChanged;

  const _CategorySelector({
    required this.selectedCategory,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      _SupplierCategory('all', isArabic ? 'الكل' : 'All', Icons.widgets_rounded),
      _SupplierCategory(
        'battery',
        isArabic ? 'بطاريات' : 'Battery',
        Icons.battery_charging_full_rounded,
      ),
      _SupplierCategory(
        'panels',
        isArabic ? 'ألواح' : 'Panels',
        Icons.solar_power_rounded,
      ),
      _SupplierCategory(
        'inverter',
        isArabic ? 'انفرتر' : 'Inverter',
        Icons.electrical_services_rounded,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories) ...[
            _CategoryChip(
              category: category,
              isSelected: selectedCategory == category.value,
              onTap: () => onChanged(category.value),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final _SupplierCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 17,
              color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySuppliersState extends StatelessWidget {
  final bool isArabic;

  const _EmptySuppliersState({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 54,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 14),
          Text(
            isArabic ? 'لا توجد منتجات موردين حالياً' : 'No supplier products yet',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? 'عندما تضيف الشركات الأخرى منتجات، ستظهر هنا.'
                : 'Products added by other companies will appear here.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;

  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.20)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 13),
      ),
    );
  }
}

class _SupplierCategory {
  final String value;
  final String label;
  final IconData icon;

  const _SupplierCategory(this.value, this.label, this.icon);
}
