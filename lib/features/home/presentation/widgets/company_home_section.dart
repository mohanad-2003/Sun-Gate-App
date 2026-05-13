import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/product_card.dart';

class CompanyHomeSection extends ConsumerStatefulWidget {
  final CompanyEntity company;

  const CompanyHomeSection({super.key, required this.company});

  @override
  ConsumerState<CompanyHomeSection> createState() => _CompanyHomeSectionState();
}

class _CompanyHomeSectionState extends ConsumerState<CompanyHomeSection> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final filteredProducts = _filterProducts(state.products);
    final products = filteredProducts.take(4).toList();

    return Container(
      color: const Color(0xFFF5F7FB),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CompanyHero(company: widget.company),
              Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.company.companyName.isNotEmpty
                            ? widget.company.companyName
                            : widget.company.ownerName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 14,
                        runSpacing: 10,
                        children: [
                          _InfoChip(
                            icon: Icons.location_on_outlined,
                            label: widget.company.address.isNotEmpty
                                ? widget.company.address
                                : (isArabic
                                      ? 'العنوان غير متوفر'
                                      : 'No address'),
                          ),
                          _InfoChip(
                            icon: Icons.phone_outlined,
                            label: widget.company.phone.isNotEmpty
                                ? widget.company.phone
                                : (isArabic ? 'الهاتف غير متوفر' : 'No phone'),
                          ),
                          _InfoChip(
                            icon: Icons.email_outlined,
                            label: widget.company.email,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        isArabic ? 'الوصف' : 'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isArabic
                            ? 'هذه واجهة الشركة داخل الصفحة الرئيسية. يمكنك منها استعراض بيانات الشركة، فتح السوق، إضافة منتج جديد، ومشاهدة المنتجات حسب القسم.'
                            : 'This company home highlights company details, quick market access, product creation, and category-based browsing.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _CategoryPill(
                              label: isArabic ? 'الكل' : 'All',
                              isSelected: _selectedCategory == 'all',
                              onTap: () =>
                                  setState(() => _selectedCategory = 'all'),
                            ),
                            const SizedBox(width: 10),
                            _CategoryPill(
                              label: isArabic ? 'بطاريات' : 'Battery',
                              isSelected: _selectedCategory == 'battery',
                              onTap: () =>
                                  setState(() => _selectedCategory = 'battery'),
                            ),
                            const SizedBox(width: 10),
                            _CategoryPill(
                              label: isArabic ? 'ألواح' : 'Panels',
                              isSelected: _selectedCategory == 'panels',
                              onTap: () =>
                                  setState(() => _selectedCategory = 'panels'),
                            ),
                            const SizedBox(width: 10),
                            _CategoryPill(
                              label: isArabic ? 'انفرتر' : 'Inverter',
                              isSelected: _selectedCategory == 'inverter',
                              onTap: () => setState(
                                () => _selectedCategory = 'inverter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push(RouteNames.market),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.storefront_outlined),
                              label: Text(
                                isArabic ? 'فتح السوق' : 'Open Market',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  context.push(RouteNames.createProduct),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_circle_outline_rounded,
                              ),
                              label: Text(
                                isArabic ? 'إضافة منتج' : 'Add Product',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isArabic ? 'قائمة المنتجات' : 'List Items',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (state.isLoading && products.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (products.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            isArabic
                                ? 'لا توجد منتجات مطابقة لهذا القسم حالياً.'
                                : 'No products available for this category right now.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: products.length * 120.0,
                          child: ListView.separated(
                            itemCount: products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return _CompanyProductListTile(
                                product: product,
                                onTap: () => context.push(
                                  RouteNames.productDetail,
                                  extra: product,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ProductEntity> _filterProducts(List<ProductEntity> products) {
    if (_selectedCategory == 'all') return products;

    return products.where((product) {
      final category = product.category.toLowerCase();
      switch (_selectedCategory) {
        case 'battery':
          return category.contains('battery') || category.contains('بطار');
        case 'panels':
          return category.contains('panel') || category.contains('لوح');
        case 'inverter':
          return category.contains('inverter') || category.contains('محول');
        default:
          return true;
      }
    }).toList();
  }
}

class _CompanyProductListTile extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const _CompanyProductListTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageUrl = product.images.isNotEmpty ? product.images.first : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _productPlaceholder(colorScheme),
                    )
                  : _productPlaceholder(colorScheme),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: 64,
      height: 64,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}

class _CompanyHero extends StatelessWidget {
  final CompanyEntity company;

  const _CompanyHero({required this.company});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (company.logo != null && company.logo!.isNotEmpty)
            Image.network(
              company.logo!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackBackground(),
            )
          else
            _fallbackBackground(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.40),
                  Colors.black.withValues(alpha: 0.70),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton.filledTonal(
                      onPressed: () => context.push(RouteNames.profile),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: company.logo != null && company.logo!.isNotEmpty
                        ? Image.network(
                            company.logo!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.apartment_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                          )
                        : const Icon(
                            Icons.apartment_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    company.companyName.isNotEmpty
                        ? company.companyName
                        : company.ownerName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? 'واجهة الشركة' : 'Company Home',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF385B2A), Color(0xFF162B1B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
