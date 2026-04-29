import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/marketplace/presentation/provider/market_place_provider.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/product_card.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(marketPlaceControllerProvider.notifier).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }

          if (state.products.isEmpty) {
            return const Center(child: Text("No Products"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = state.products[index];

              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
