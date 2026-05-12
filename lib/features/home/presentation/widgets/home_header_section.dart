import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/weather_provider.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/category_chip_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_app_bar_section.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_banner_card.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_weather_section.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/section_title_row.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/weather_background.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/widget/market_place_company_card.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class HomeHeaderSection extends ConsumerWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final homeState = ref.watch(homeControllerProvider);
    final marketState = ref.watch(marketPlaceControllerProvider);
    final weatherState = ref.watch(weatherProvider);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    final previewCompanies = marketState.companies.take(4).toList();

    final userName = _resolveUserName(
      profileState.profile?.firstName.isNotEmpty == true
          ? profileState.profile!.firstName
          : profileState.profile?.fullName,
      companyName: marketState.myCompany?.companyName,
      ownerName: marketState.myCompany?.ownerName,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Column(
      children: [
        weatherState.when(
          data: (data) {
            final headerImage = _getHeaderImage(data.mainCondition);
            final topOverlay = _getOverlayColor(data.mainCondition);

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(headerImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: WeatherBackground(condition: data.condition),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            topOverlay,
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: HomeAppBarSection(userName: userName),
                      ),
                      const SizedBox(height: 20),
                      HomeWeatherSection(
                        temp: data.temp,
                        humidity: data.humidity,
                        wind: data.wind,
                        condition: data.condition,
                        cityName: data.cityName,
                        hourly: data.hourly,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const SizedBox(),
        ),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeBannerCard(
                  onTap: () => context.push(RouteNames.market),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionTitleRow(
                  title: loc.category,
                  actionText: '',
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: homeState.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = homeState.categories[index];

                    return CategoryChipCard(
                      category: category,
                      onTap: () {
                        context.push(
                          RouteNames.categoryProducts,
                          extra: category,
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionTitleRow(
                  title: loc.popularCompanies,
                  actionText: loc.seeAll,
                  onTap: () => context.push(RouteNames.allCompanies),
                ),
              ),

              const SizedBox(height: 10),

              if (marketState.isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (previewCompanies.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No companies yet'),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: previewCompanies.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.80,
                        ),
                    itemBuilder: (context, index) {
                      final company = previewCompanies[index];

                      return MarketplaceCompanyCard(
                        company: company,
                        onTap: () {
                          context.push(
                            RouteNames.companyDetail,
                            extra: company,
                          );
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  String _getHeaderImage(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'rain':
        return 'assets/images/rain.jpg';
      case 'clouds':
        return 'assets/images/cloud.jpg';
      case 'clear':
        return 'assets/images/sun.jpg';
      default:
        return 'assets/images/sp.jpg';
    }
  }

  Color _getOverlayColor(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return Colors.orange.withValues(alpha: 0.5);
      case 'clouds':
        return Colors.black.withValues(alpha: 0.6);
      case 'rain':
        return Colors.blueGrey.withValues(alpha: 0.6);
      default:
        return Colors.black.withValues(alpha: 0.6);
    }
  }

  String _resolveUserName(
    String? name, {
    String? companyName,
    String? ownerName,
  }) {
    if (name != null && name.trim().isNotEmpty) return name.trim();
    if (companyName != null && companyName.trim().isNotEmpty) {
      return companyName.trim();
    }
    if (ownerName != null && ownerName.trim().isNotEmpty) {
      return ownerName.trim();
    }
    return 'User';
  }
}
