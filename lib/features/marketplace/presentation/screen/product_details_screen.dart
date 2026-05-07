import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageUrl =
        product.images.isNotEmpty ? product.images.first : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 260,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  product.category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  product.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        title: 'Condition',
                        value: product.condition,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _InfoCard(
                        title: 'Status',
                        value: product.status,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _InfoCard(
                  title: 'Sell As',
                  value: product.sellAs,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Reserve Product'),
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

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}