import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'حذف المنتجات' : 'Delete Product'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(adminControllerProvider.notifier).loadProducts(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
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
              SizedBox(
                height: 280,
                child: Center(
                  child: Text(
                    isArabic ? 'لا توجد منتجات' : 'No products found',
                  ),
                ),
              )
            else
              ...state.products.map((product) {
                final image = product.images.isNotEmpty
                    ? product.images.first
                    : null;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: image != null
                          ? Image.network(
                              image,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                    ),
                    title: Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${product.category} • ${product.price.toStringAsFixed(0)} • ${product.status}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: state.isSaving
                          ? null
                          : () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    isArabic ? 'حذف المنتج' : 'Delete product',
                                  ),
                                  content: Text(
                                    isArabic
                                        ? 'هل تريد حذف هذا المنتج نهائياً؟'
                                        : 'Delete this product permanently?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(
                                        isArabic ? 'إلغاء' : 'Cancel',
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        isArabic ? 'حذف' : 'Delete',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true && mounted) {
                                await ref
                                    .read(adminControllerProvider.notifier)
                                    .deleteProduct(product.id);
                              }
                            },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 56,
      height: 56,
      color: const Color(0xFF274777).withValues(alpha: 0.08),
      child: const Icon(Icons.image_outlined),
    );
  }
}
