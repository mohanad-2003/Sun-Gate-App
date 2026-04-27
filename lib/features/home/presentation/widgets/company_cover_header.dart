// import 'package:flutter/material.dart';

// class CompanyCoverHeader extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final VoidCallback? onBackTap;

//   const CompanyCoverHeader({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     this.onBackTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final topPadding = MediaQuery.of(context).padding.top;
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final headerHeight = screenWidth < 360 ? 280.0 : 320.0;

//     return SizedBox(
//       height: headerHeight,
//       width: double.infinity,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             imagePath,
//             fit: BoxFit.cover,
//             errorBuilder: (_, _, _) {
//               return Container(
//                 color: theme.colorScheme.surfaceContainerHighest,
//                 alignment: Alignment.center,
//                 child: Icon(
//                   Icons.image_not_supported_outlined,
//                   size: 34,
//                   color: theme.colorScheme.onSurfaceVariant,
//                 ),
//               );
//             },
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.black.withOpacity(0.18),
//                   Colors.black.withOpacity(0.20),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: topPadding + 14,
//             left: 16,
//             right: 16,
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: onBackTap ?? () => Navigator.pop(context),
//                   borderRadius: BorderRadius.circular(22),
//                   child: Container(
//                     width: 42,
//                     height: 42,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.92),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       size: 18,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 42),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
