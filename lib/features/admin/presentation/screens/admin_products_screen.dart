import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_ui_kit.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(adminControllerProvider.notifier).loadProducts(),
    );
  }

  Future<bool?> _confirmDelete(bool isArabic) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(isArabic ? 'حذف المنتج' : 'Delete product'),
        content: Text(
          isArabic
              ? 'هل تريد حذف هذا المنتج نهائياً؟'
              : 'Do you want to delete this product permanently?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إدارة المنتجات' : 'Product moderation'),
      ),
      body: AdminScreenContainer(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(adminControllerProvider.notifier).loadProducts(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              AdminHeroBanner(
                eyebrow: isArabic ? 'المنتجات' : 'Products',
                title: isArabic ? 'مراجعة المنتجات' : 'Review products',
                subtitle: isArabic
                    ? 'راجع بطاقات المنتجات واحذف العناصر غير المناسبة بسرعة.'
                    : 'Review product cards and remove inappropriate items quickly.',
                icon: Icons.inventory_2_outlined,
                footer: [
                  AdminHeroMetric(
                    label: isArabic ? 'إجمالي المنتجات' : 'Total products',
                    value: '${state.products.length}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AdminMessageBanner(
                errorMessage: state.errorMessage,
                successMessage: state.successMessage,
              ),
              if (state.isLoading)
                const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.products.isEmpty)
                AdminEmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: isArabic ? 'لا توجد منتجات' : 'No products found',
                  subtitle: isArabic
                      ? 'ستظهر المنتجات هنا عند توفرها.'
                      : 'Products will appear here when available.',
                )
              else
                ...state.products.map((product) {
                  final image =
                      product.images.isNotEmpty ? product.images.first : null;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdminPanel(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: image != null
                                ? Image.network(
                                    image,
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _placeholder(),
                                  )
                                : _placeholder(),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    AdminBadge(
                                      label: product.category,
                                      color: const Color(0xFF274777),
                                    ),
                                    AdminBadge(
                                      label: product.status,
                                      color: const Color(0xFF039BE5),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${product.price.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 112,
                            child: FilledButton.tonalIcon(
                              onPressed: state.isSaving
                                  ? null
                                  : () async {
                                      final confirmed =
                                          await _confirmDelete(isArabic);
                                      if (confirmed == true && mounted) {
                                        await ref
                                            .read(
                                              adminControllerProvider.notifier,
                                            )
                                            .deleteProduct(product.id);
                                      }
                                    },
                              icon: const Icon(Icons.delete_outline),
                              label: Text(isArabic ? 'حذف' : 'Delete'),
                              style: FilledButton.styleFrom(
                                foregroundColor: const Color(0xFFC62828),
                                backgroundColor: const Color(
                                  0xFFC62828,
                                ).withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 82,
      height: 82,
      color: const Color(0xFF274777).withValues(alpha: 0.08),
      child: const Icon(Icons.image_outlined),
    );
  }
}
