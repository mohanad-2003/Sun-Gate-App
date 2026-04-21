import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/data/models/company_model.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/extentions/home_localization_extention.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/company_cover_header.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/product_list_title.dart';

class CompanyDetailScreen extends ConsumerWidget {
  final CompanyModel company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final loc = AppLocalizations.of(context)!;

    final horizontalPadding = screenWidth < 360 ? 14.0 : 16.0;
    final companyProducts = state.products
        .where((product) => product.companyId == company.id)
        .toList();

    final companyName = loc.companyByKey(company.nameKey);
    final companyLocation = loc.companyByKey(company.locationKey);
    final companyDescription = loc.companyByKey(company.descriptionKey);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          CompanyCoverHeader(
            title: loc.companyDetailTitle(companyName),
            imagePath: company.coverImagePath,
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: theme.brightness == Brightness.dark ? 0.22 : 0.06,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    24,
                  ),
                  children: [
                    Text(
                      companyName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            companyLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${company.rating} ${loc.reviewsCount(company.reviewCount)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      loc.description,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      companyDescription,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      loc.listItems,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (companyProducts.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          loc.noProductsForCompany,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else
                      ...List.generate(
                        companyProducts.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == companyProducts.length - 1
                                ? 0
                                : 10,
                          ),
                          child: ProductListTile(
                            product: companyProducts[index],
                            onTap: () {
                              context.push(
                                RouteNames.productDetail,
                                extra: companyProducts[index],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}