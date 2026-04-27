// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sun_gate_app/features/marketplace/data/models/company_model.dart';
// import 'package:sun_gate_app/features/home/presentation/widgets/company_cover_header.dart';

// class CompanyDetailScreen extends ConsumerWidget {
//   final CompanyModel company;

//   const CompanyDetailScreen({
//     super.key,
//     required this.company,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final horizontalPadding = screenWidth < 360 ? 14.0 : 16.0;

//     final companyName = company.ownerName;
//     final companyLocation = company.address;
//     final companyPhone = company.phone;
//     final coverImage = company.coverImage;

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       body: Column(
//         children: [
//           CompanyCoverHeader(
//             title: companyName,
//             imagePath: coverImage ?? '',
//           ),
//           Expanded(
//             child: Transform.translate(
//               offset: const Offset(0, -24),
//               child: Container(
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   color: colorScheme.surface,
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(28),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(
//                         alpha: theme.brightness == Brightness.dark ? 0.22 : 0.06,
//                       ),
//                       blurRadius: 18,
//                       offset: const Offset(0, -4),
//                     ),
//                   ],
//                 ),
//                 child: ListView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.fromLTRB(
//                     horizontalPadding,
//                     20,
//                     horizontalPadding,
//                     24,
//                   ),
//                   children: [
//                     Text(
//                       companyName,
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           size: 18,
//                           color: colorScheme.onSurfaceVariant,
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             companyLocation,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               color: colorScheme.onSurfaceVariant,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     Text(
//                       'Phone',
//                       style: theme.textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     Text(
//                       companyPhone,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: colorScheme.onSurfaceVariant,
//                         height: 1.6,
//                       ),
//                     ),

//                     const SizedBox(height: 22),

//                     Text(
//                       'Company Details',
//                       style: theme.textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: colorScheme.surfaceContainerHighest,
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: Text(
//                         'Owner: $companyName\nAddress: $companyLocation\nPhone: $companyPhone',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: colorScheme.onSurfaceVariant,
//                           height: 1.6,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }