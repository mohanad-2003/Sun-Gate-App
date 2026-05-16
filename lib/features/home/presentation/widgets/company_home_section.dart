import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyHomeSection extends ConsumerStatefulWidget {
  final CompanyEntity company;

  const CompanyHomeSection({super.key, required this.company});

  @override
  ConsumerState<CompanyHomeSection> createState() => _CompanyHomeSectionState();
}

class _CompanyHomeSectionState extends ConsumerState<CompanyHomeSection> {
  String _selectedCategory = 'all';

  Future<void> _launchCompanyAction(Uri uri) async {
    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (launched || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this contact option')),
    );
  }

  Future<void> _callCompany() async {
    final phone = widget.company.phone.trim();
    if (phone.isEmpty) return;
    await _openWhatsApp(phone);
  }

  Future<void> _emailCompany() async {
    final email = widget.company.email.trim();
    if (email.isEmpty) return;
    await _launchCompanyAction(Uri(scheme: 'mailto', path: email));
  }

  Future<void> _openCompanyLocation() async {
    final address = widget.company.address.trim();
    if (address.isEmpty) return;

    await _launchCompanyAction(
      Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': address,
      }),
    );
  }

  Future<void> _openEngineerWhatsApp() async {
    final engineerNumber = widget.company.engineerNumber?.trim() ?? '';
    if (engineerNumber.isEmpty) return;
    await _openWhatsApp(engineerNumber);
  }

  Future<void> _openWhatsApp(String phone) async {
    final normalizedPhone = _normalizeWhatsAppPhone(phone);
    if (normalizedPhone.isEmpty) return;

    await _launchCompanyAction(Uri.https('wa.me', '/$normalizedPhone'));
  }

  String _normalizeWhatsAppPhone(String phone) {
    var normalized = phone.trim();
    if (normalized.startsWith('00')) {
      normalized = normalized.substring(2);
    }
    normalized = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalized.startsWith('0')) {
      normalized = '970${normalized.substring(1)}';
    }
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final filteredProducts = _filterProducts(state.products);
    final products = filteredProducts.take(4).toList();
    final engineerNumber = widget.company.engineerNumber?.trim() ?? '';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // ✅ كان Color(0xFFF5F7FB)
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF162B1B),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.company.logo != null &&
                      widget.company.logo!.isNotEmpty)
                    Image.network(
                      widget.company.logo!,
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
                          Colors.black.withValues(alpha: 0.10),
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 48,
                    right: 16,
                    child: IconButton.filledTonal(
                      onPressed: () => context.push(RouteNames.profile),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 18,
                    right: 18,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: widget.company.logo != null &&
                                  widget.company.logo!.isNotEmpty
                              ? Image.network(
                                  widget.company.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.apartment_rounded,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                )
                              : const Icon(
                                  Icons.apartment_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.company.companyName.isNotEmpty
                                    ? widget.company.companyName
                                    : widget.company.ownerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic ? 'واجهة الشركة' : 'Company Home',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor, // ✅ كان theme.scaffoldBackgroundColor بالفعل صح
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      children: [
                        _InfoChip(
                          icon: Icons.location_on_outlined,
                          label: widget.company.address.isNotEmpty
                              ? widget.company.address
                              : (isArabic ? 'العنوان غير متوفر' : 'No address'),
                          onTap: widget.company.address.isNotEmpty
                              ? _openCompanyLocation
                              : null,
                        ),
                        _InfoChip(
                          icon: Icons.phone_outlined,
                          label: widget.company.phone.isNotEmpty
                              ? widget.company.phone
                              : (isArabic ? 'الهاتف غير متوفر' : 'No phone'),
                          onTap: widget.company.phone.isNotEmpty
                              ? _callCompany
                              : null,
                        ),
                        _InfoChip(
                          icon: Icons.email_outlined,
                          label: widget.company.email.isNotEmpty
                              ? widget.company.email
                              : (isArabic ? 'البريد غير متوفر' : 'No email'),
                          onTap: widget.company.email.isNotEmpty
                              ? _emailCompany
                              : null,
                        ),
                        _InfoChip(
                          icon: Icons.engineering_outlined,
                          label: engineerNumber.isNotEmpty
                              ? engineerNumber
                              : (isArabic
                                    ? 'رقم المهندس غير متوفر'
                                    : 'No engineer number'),
                          onTap: engineerNumber.isNotEmpty
                              ? _openEngineerWhatsApp
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      isArabic ? 'الوصف' : 'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      widget.company.description?.trim().isNotEmpty == true
                          ? widget.company.description!.trim()
                          : isArabic
                          ? 'هذه واجهة الشركة داخل الصفحة الرئيسية. يمكنك منها استعراض بيانات الشركة، فتح السوق، إضافة منتج جديد، ومشاهدة المنتجات حسب القسم.'
                          : 'This company home highlights company details, quick market access, product creation, and category-based browsing.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          onTap: () =>
                              setState(() => _selectedCategory = 'inverter'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.add_circle_outline_rounded),
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
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      isArabic ? 'قائمة المنتجات' : 'List Items',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colorScheme.surface, 
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Text(
                          isArabic
                              ? 'لا توجد منتجات مطابقة لهذا القسم حالياً.'
                              : 'No products available for this category right now.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _CompanyProductListTile(
                          product: product,
                          canManage:
                              state.ownedProductKeys.contains(
                                _ownedProductKey(product),
                              ) ||
                              _canManageProduct(product),
                          onTap: () => context.push(
                            RouteNames.productDetail,
                            extra: product,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 32),
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

  bool _canManageProduct(ProductEntity product) {
    if (product.isOwnedByCurrentUser != null) {
      return product.isOwnedByCurrentUser!;
    }

    final ownerCompanyId = product.ownerCompanyId?.trim();
    final currentCompanyId = widget.company.id.trim();

    return ownerCompanyId != null &&
        ownerCompanyId.isNotEmpty &&
        currentCompanyId.isNotEmpty &&
        ownerCompanyId == currentCompanyId;
  }

  String _ownedProductKey(ProductEntity product) {
    return '${widget.company.id.trim()}:${product.id.trim()}';
  }
}

class _CompanyProductListTile extends ConsumerWidget {
  final ProductEntity product;
  final bool canManage;
  final VoidCallback onTap;

  const _CompanyProductListTile({
    required this.product,
    required this.canManage,
    required this.onTap,
  });

  Future<void> _editProduct(BuildContext context) async {
    await context.push(RouteNames.editProduct, extra: product);
  }

  Future<void> _deleteProduct(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete product?'),
          content: Text(
            'This will permanently delete "${product.title}". This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(marketPlaceControllerProvider.notifier)
        .deleteProduct(product.id);

    if (!context.mounted) return;

    final state = ref.read(marketPlaceControllerProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Product deleted successfully'
              : (state.errorMessage ?? 'Failed to delete product'),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageUrl = product.images.isNotEmpty ? product.images.first : '';
    final isSaving = ref.watch(marketPlaceControllerProvider).isSaving;

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
                      errorBuilder: (_, _, _) =>
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
            if (canManage) ...[
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 126),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: isSaving ? null : () => _editProduct(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text(
                        'Edit Product',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: isSaving
                          ? null
                          : () => _deleteProduct(context, ref),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                        foregroundColor: Colors.red,
                        side: BorderSide(
                          color: Colors.red.withValues(alpha: 0.5),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text(
                        'Delete Product',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _InfoChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.primary),
        const SizedBox(width: 5),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - 72,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: child,
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
