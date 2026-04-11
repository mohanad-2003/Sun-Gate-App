import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/company_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';

class HomeState {
  final bool isLoading;
  final List<CategoryItemModel> categories;
  final List<CompanyModel> companies;
  final List<ProductModel> products;

  const HomeState({
    this.isLoading = false,
    this.categories = const [],
    this.companies = const [],
    this.products = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    List<CategoryItemModel>? categories,
    List<CompanyModel>? companies,
    List<ProductModel>? products,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      companies: companies ?? this.companies,
      products: products ?? this.products,
    );
  }
}

final homeControllerProvider = Provider<HomeState>((ref) {
  final categories = [
    CategoryItemModel(
      id: '1',
      title: 'Batteries',
      imagePath: 'assets/images/battery.jpg',
    ),
    CategoryItemModel(
      id: '2',
      title: 'Invertors',
      imagePath: 'assets/images/inverter.jpg',
    ),
    CategoryItemModel(
      id: '3',
      title: 'Panels',
      imagePath: 'assets/images/panels.jpg',
    ),
    CategoryItemModel(
      id: '4',
      title: 'Suppliers',
      imagePath: 'assets/images/suppliers.jpg',
    ),
  ];

  final companies = [
    CompanyModel(
      id: 'c1',
      name: 'Luminance Solar',
      logoPath: 'assets/images/company_luminis.jpg',
      coverImagePath: 'assets/images/company_luminis.jpg',
      shortDescription: 'Expert installation of high-efficiency panels',
      description:
          'Luminance Solar provides advanced solar energy solutions for homes and businesses with a focus on quality and long-term performance.',
      location: 'San Diego, California',
      rating: 4.4,
      reviewCount: 23,
      tags: ['Batteries', 'Panels'],
    ),
    CompanyModel(
      id: 'c2',
      name: 'VoltGuard Com',
      logoPath: 'assets/images/company_sungrid.jpg',
      coverImagePath: 'assets/images/company_sungrid.jpg',
      shortDescription: 'Advanced battery and inverter management',
      description:
          'VoltGuard specializes in battery systems, inverter solutions, and smart energy components for modern solar projects.',
      location: 'San Diego, California',
      rating: 4.4,
      reviewCount: 23,
      tags: ['Batteries', 'Inverter'],
    ),
  ];

  const products = [
    ProductModel(
      id: 'p1',
      companyId: 'c2',
      name: 'Portal Solar Power System',
      imagePath: 'assets/images/product_generator.jpg',
      description:
          'Compact 500W unit with built-in battery and LED lighting for emergency use.',
      howItWorks: [
        'Connect the included solar panel to the main unit to convert sunlight into electrical energy.',
        'The built-in battery stores the captured power for use during the night or during power outages.',
        'Simply plug in your devices into the USB or DC ports for instant power.',
      ],
      price: 2500.50,
      ownerName: 'Mohamoud Ali',
      ownerRole: 'SunGrid Manager',
      ownerPhone: '+972 599 000 000',
      ownerEmail: 'owner@sungate.com',
      tags: ['Batteries'],
    ),
    ProductModel(
      id: 'p2',
      companyId: 'c2',
      name: 'Pure Sine Wave Inverter',
      imagePath: 'assets/images/product_inverter.jpg',
      description:
          '1000W high-efficiency power inverter with smart cooling system.',
      howItWorks: [
        'Connect the inverter to the battery system.',
        'Use it to convert DC power into AC power.',
        'Run compatible home or office devices efficiently.',
      ],
      price: 85,
      ownerName: 'Mohamoud Ali',
      ownerRole: 'SunGrid Manager',
      ownerPhone: '+972 599 000 000',
      ownerEmail: 'owner@sungate.com',
      tags: ['Inverter'],
    ),
  ];

  return HomeState(
    categories: categories,
    companies: companies,
    products: products,
  );
});
