import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';
import 'package:sun_gate_app/features/home/presentation/extentions/home_localization_extention.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/product_owner_card.dart';

class ProductDetailScreen extends StatelessWidget {
 // final ProductModel product;

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              children: [
                // Image.asset(
                //   product.imagePath,
                //   width: double.infinity,
                //   height: 250,
                //   fit: BoxFit.cover,
                // ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      loc.productDetailTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  // Text(
                  //   loc.productByKey(product.nameKey),
                  //   style: theme.textTheme.titleLarge?.copyWith(
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  const SizedBox(height: 18),
                  Text(
                    loc.description,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   loc.productByKey(product.descriptionKey),
                  //   style: theme.textTheme.bodyMedium?.copyWith(
                  //     color: colorScheme.onSurfaceVariant,
                  //     height: 1.65,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Text(
                    loc.howItWorks,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ...product.howItWorksKeys.map(
                  //   (itemKey) => Padding(
                  //     padding: const EdgeInsets.only(bottom: 6),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const Text('• '),
                  //         Expanded(
                  //           child: Text(
                  //             loc.productByKey(itemKey),
                  //             style: theme.textTheme.bodyMedium?.copyWith(
                  //               color: colorScheme.onSurfaceVariant,
                  //               height: 1.6,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Text(
                    loc.contactOwner,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ProductOwnerCard(
                  //   ownerName: loc.productByKey(product.ownerNameKey),
                  //   ownerRole: loc.productByKey(product.ownerRoleKey),
                  //   ownerPhone: product.ownerPhone,
                  //   ownerEmail: product.ownerEmail,
                  // ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text(
                        loc.price,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      // Text(
                      //   '\$${product.price.toStringAsFixed(2)}',
                      //   style: theme.textTheme.titleMedium?.copyWith(
                      //     color: colorScheme.primary,
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
