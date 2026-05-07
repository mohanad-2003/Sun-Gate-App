import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/company_card.dart';

class AllCompanyScreen extends ConsumerStatefulWidget {
  const AllCompanyScreen({super.key});

  @override
  ConsumerState<AllCompanyScreen> createState() => _AllCompanyScreenState();
}

class _AllCompanyScreenState extends ConsumerState<AllCompanyScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(marketPlaceControllerProvider.notifier).getCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.popularCompanies),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return ref.read(marketPlaceControllerProvider.notifier).getCompanies();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HomeSearchBar(
              hintText: loc.search,
            ),

            const SizedBox(height: 20),

            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.20),
                  ),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              )
            else if (state.companies.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No companies yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...state.companies.map(
                (company) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CompanyCard(
                    company: company,
                    onTap: () {
                      context.push(
                        RouteNames.companyDetail,
                        extra: company,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}