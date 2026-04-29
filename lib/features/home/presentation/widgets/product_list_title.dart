// import 'package:flutter/material.dart';
// import 'package:sun_gate_app/app/localization/app_localizations.dart';
// import 'package:sun_gate_app/features/home/data/models/product_model.dart';
// import 'package:sun_gate_app/features/home/presentation/extentions/home_localization_extention.dart';

// class ProductListTile extends StatelessWidget {
//   final ProductModel product;
//   final VoidCallback onTap;

//   const ProductListTile({
//     super.key,
//     required this.product,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final imageSize = screenWidth < 360 ? 54.0 : 60.0;
//     final loc = AppLocalizations.of(context)!;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: colorScheme.surface,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: colorScheme.outlineVariant.withValues(alpha: 0.45),
//           ),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(14),
//               child: Image.asset(
//                 product.imagePath,
//                 width: imageSize,
//                 height: imageSize,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, _, _) {
//                   return Container(
//                     width: imageSize,
//                     height: imageSize,
//                     color: colorScheme.surfaceContainerHighest,
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.image_not_supported_outlined,
//                       color: colorScheme.onSurfaceVariant,
//                       size: 20,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     loc.productByKey(product.nameKey),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: theme.textTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     loc.productByKey(product.descriptionKey),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: colorScheme.onSurfaceVariant,
//                       height: 1.45,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     '\$${product.price.toStringAsFixed(0)}',
//                     style: theme.textTheme.labelLarge?.copyWith(
//                       color: colorScheme.primary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             CircleAvatar(
//               radius: 16,
//               backgroundColor: colorScheme.surfaceContainerHighest,
//               child: Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 14,
//                 color: colorScheme.onSurfaceVariant,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
