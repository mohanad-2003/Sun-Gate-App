import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';

class HomeState {
  final bool isLoading;
  final List<CategoryItemModel> categories;

  const HomeState({this.isLoading = false, this.categories = const []});

  HomeState copyWith({bool? isLoading, List<CategoryItemModel>? categories}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  HomeController()
    : super(
        HomeState(
          categories: [
            CategoryItemModel(
              id: '1',
              titleKey: 'categoryBatteries',
              imagePath: 'assets/images/battery.jpg',
            ),
            CategoryItemModel(
              id: '2',
              titleKey: 'categoryInverters',
              imagePath: 'assets/images/inverter.jpg',
            ),
            CategoryItemModel(
              id: '3',
              titleKey: 'categoryPanels',
              imagePath: 'assets/images/panels.jpg',
            ),
            CategoryItemModel(
              id: '4',
              titleKey: 'categorySuppliers',
              imagePath: 'assets/images/suppliers.jpg',
            ),
          ],
        ),
      );
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(),
);
