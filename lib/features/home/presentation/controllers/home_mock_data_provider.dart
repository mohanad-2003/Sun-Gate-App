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
      id: '1',
      name: 'Luminance Solar',
      coverImagePath: 'assets/images/company_luminance.jpeg',
      logoPath: 'assets/images/companies/logo_luminance.png',
      shortDescription: 'Expert installation of high-efficiency panels',
      description:
          'Luminance Solar specializes in modern solar panel systems for homes and small businesses with strong performance and reliable maintenance support.',
      location: 'Amman, Jordan',
      rating: 4.7,
      reviewCount: 31,
      tags: ['Batteries', 'Panels'],
    ),
    CompanyModel(
      id: '2',
      name: 'VoltGuard Com',
      coverImagePath: 'assets/images/company_voltguard.jpeg',
      logoPath: 'assets/images/companies/logo_voltguard.png',
      shortDescription: 'Advanced battery and inverter management',
      description:
          'VoltGuard provides advanced inverter solutions and backup battery systems suitable for residential and commercial energy needs.',
      location: 'Zarqa, Jordan',
      rating: 4.5,
      reviewCount: 24,
      tags: ['Batteries', 'Inverter'],
    ),
    CompanyModel(
      id: '3',
      name: 'EcoVolt Solar',
      coverImagePath: 'assets/images/company_ecovolt.jpeg',
      logoPath: 'assets/images/companies/logo_ecovolt.png',
      shortDescription: 'Residential and commercial solar solutions',
      description:
          'EcoVolt Solar focuses on complete solar energy solutions including design, supply, installation, and after-sales support.',
      location: 'Irbid, Jordan',
      rating: 4.6,
      reviewCount: 28,
      tags: ['Panels', 'Suppliers'],
    ),
    CompanyModel(
      id: '4',
      name: 'Zenith Power',
      coverImagePath: 'assets/images/company_zenith.jpeg',
      logoPath: 'assets/images/companies/logo_zenith.png',
      shortDescription: 'High-performance lithium battery solutions',
      description:
          'Zenith Power delivers high-capacity battery systems and smart energy storage units designed for dependable long-term use.',
      location: 'Aqaba, Jordan',
      rating: 4.8,
      reviewCount: 19,
      tags: ['Batteries', 'Suppliers'],
    ),
    CompanyModel(
      id: '5',
      name: 'SunCore Energy',
      coverImagePath: 'assets/images/company_suncore.jpeg',
      logoPath: 'assets/images/companies/logo_suncore.png',
      shortDescription: 'Reliable solar products for modern projects',
      description:
          'SunCore Energy serves solar projects with quality modules, trusted installation materials, and strong technical consultation.',
      location: 'Nablus, Palestine',
      rating: 4.4,
      reviewCount: 16,
      tags: ['Panels', 'Inverter'],
    ),
    CompanyModel(
      id: '6',
      name: 'NovaGrid Solutions',
      coverImagePath: 'assets/images/company_novagrid.jpg',
      logoPath: 'assets/images/logo_novagrid.png',
      shortDescription: 'Smart renewable systems and supplier services',
      description:
          'NovaGrid Solutions combines smart controllers, renewable products, and supply services for scalable clean-energy setups.',
      location: 'Ramallah, Palestine',
      rating: 4.6,
      reviewCount: 22,
      tags: ['Suppliers', 'Panels'],
    ),
  ];

  const products = [
    ProductModel(
      id: 'p1',
      companyId: '1',
      name: 'Monocrystalline Solar Panel',
      imagePath: 'assets/images/products/panel.jpg',
      description:
          'High-efficiency 200W solar panel suitable for residential systems.',
      howItWorks: [
        'Absorbs sunlight using photovoltaic cells.',
        'Converts solar energy into electrical power.',
        'Connects to an inverter for direct usage.',
      ],
      price: 120,
      ownerName: 'Ahmad Saleh',
      ownerRole: 'Luminance Engineer',
      ownerPhone: '+972 598 111 111',
      ownerEmail: 'luminance@sungate.com',
      tags: ['Panels'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p2',
      companyId: '1',
      name: 'Portable Solar Power System',
      imagePath: 'assets/images/products/generator_1.jpg',
      description:
          'Compact solar power unit with built-in battery and LED lighting.',
      howItWorks: [
        'Charges from solar panels during daylight.',
        'Stores energy in its internal battery.',
        'Provides output for lights and small devices.',
      ],
      price: 250,
      ownerName: 'Ahmad Saleh',
      ownerRole: 'Luminance Engineer',
      ownerPhone: '+972 598 111 111',
      ownerEmail: 'luminance@sungate.com',
      tags: ['Batteries'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p3',
      companyId: '2',
      name: 'Pure Sine Wave Inverter',
      imagePath: 'assets/images/products/inverter_1.jpg',
      description: '1000W high-efficiency inverter with smart cooling system.',
      howItWorks: [
        'Connect to the battery system.',
        'Convert DC power to AC power.',
        'Run compatible home devices efficiently.',
      ],
      price: 85,
      ownerName: 'Mohamoud Ali',
      ownerRole: 'SunGrid Manager',
      ownerPhone: '+972 599 000 000',
      ownerEmail: 'owner@sungate.com',
      tags: ['Inverter'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p4',
      companyId: '2',
      name: 'Portable Solar Generator',
      imagePath: 'assets/images/products/generator_2.jpg',
      description:
          'Portable backup system for outdoor and emergency applications.',
      howItWorks: [
        'Collects solar power through connected panels.',
        'Stores energy for later use.',
        'Supplies power through multiple output ports.',
      ],
      price: 310,
      ownerName: 'Mohamoud Ali',
      ownerRole: 'SunGrid Manager',
      ownerPhone: '+972 599 000 000',
      ownerEmail: 'owner@sungate.com',
      tags: ['Batteries'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p5',
      companyId: '3',
      name: 'Hybrid Solar Inverter',
      imagePath: 'assets/images/products/inverter_2.jpg',
      description: 'Advanced inverter supporting both solar and grid systems.',
      howItWorks: [
        'Accepts solar and grid input.',
        'Automatically switches power sources.',
        'Optimizes usage efficiency.',
      ],
      price: 300,
      ownerName: 'Omar Khaled',
      ownerRole: 'EcoVolt Manager',
      ownerPhone: '+972 597 222 222',
      ownerEmail: 'ecovolt@sungate.com',
      tags: ['Inverter'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p6',
      companyId: '3',
      name: 'Solar Roof Panel Kit',
      imagePath: 'assets/images/products/panel_2.jpg',
      description: 'Complete roof-mount panel kit with durable aluminum frame.',
      howItWorks: [
        'Mounts securely on rooftops.',
        'Captures solar radiation efficiently.',
        'Works with hybrid or standard inverters.',
      ],
      price: 180,
      ownerName: 'Omar Khaled',
      ownerRole: 'EcoVolt Manager',
      ownerPhone: '+972 597 222 222',
      ownerEmail: 'ecovolt@sungate.com',
      tags: ['Panels'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p7',
      companyId: '4',
      name: 'Lithium Solar Battery',
      imagePath: 'assets/images/products/battery_1.jpg',
      description: 'Long-life lithium battery for high-capacity solar storage.',
      howItWorks: [
        'Stores extra solar energy.',
        'Provides backup during outages.',
        'Maintains stable output for critical systems.',
      ],
      price: 450,
      ownerName: 'Sara Nabil',
      ownerRole: 'Zenith Specialist',
      ownerPhone: '+972 596 333 333',
      ownerEmail: 'zenith@sungate.com',
      tags: ['Batteries'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p8',
      companyId: '4',
      name: 'Deep Cycle Battery Pack',
      imagePath: 'assets/images/products/battery_2.jpg',
      description:
          'Reliable deep-cycle battery pack for long-duration energy backup.',
      howItWorks: [
        'Stores energy for repeated discharge cycles.',
        'Supports backup and solar storage systems.',
        'Works with inverters and charge controllers.',
      ],
      price: 390,
      ownerName: 'Sara Nabil',
      ownerRole: 'Zenith Specialist',
      ownerPhone: '+972 596 333 333',
      ownerEmail: 'zenith@sungate.com',
      tags: ['Batteries'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p9',
      companyId: '5',
      name: 'Solar Street Light',
      imagePath: 'assets/images/products/light_1.jpg',
      description:
          'Outdoor solar-powered street light with automatic night mode.',
      howItWorks: [
        'Charges during the day.',
        'Turns on automatically at night.',
        'Uses stored energy for long lighting hours.',
      ],
      price: 90,
      ownerName: 'Ali Hasan',
      ownerRole: 'SunCore Supervisor',
      ownerPhone: '+972 595 444 444',
      ownerEmail: 'suncore@sungate.com',
      tags: ['Lighting'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p10',
      companyId: '5',
      name: 'Outdoor Solar Flood Light',
      imagePath: 'assets/images/products/light_2.jpg',
      description:
          'High-brightness solar flood light for gardens and outdoor spaces.',
      howItWorks: [
        'Collects energy through its top solar panel.',
        'Stores charge in the built-in battery.',
        'Provides strong focused light after sunset.',
      ],
      price: 70,
      ownerName: 'Ali Hasan',
      ownerRole: 'SunCore Supervisor',
      ownerPhone: '+972 595 444 444',
      ownerEmail: 'suncore@sungate.com',
      tags: ['Lighting'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p11',
      companyId: '6',
      name: 'Smart Distribution Cabinet',
      imagePath: 'assets/images/products/grid_1.jpg',
      description:
          'Energy distribution cabinet for smart solar infrastructure.',
      howItWorks: [
        'Organizes incoming and outgoing electrical connections.',
        'Improves safety and monitoring.',
        'Supports scalable solar installations.',
      ],
      price: 520,
      ownerName: 'Rami Adel',
      ownerRole: 'NovaGrid Engineer',
      ownerPhone: '+972 594 555 555',
      ownerEmail: 'novagrid@sungate.com',
      tags: ['Suppliers'],
      imageProfile: 'assets/images/profile.jpg',
    ),

    ProductModel(
      id: 'p12',
      companyId: '6',
      name: 'Solar Grid Control Unit',
      imagePath: 'assets/images/products/grid_2.jpg',
      description:
          'Control unit for monitoring and managing distributed solar power.',
      howItWorks: [
        'Monitors energy flow across the system.',
        'Helps balance consumption and storage.',
        'Improves efficiency of solar distribution.',
      ],
      price: 610,
      ownerName: 'Rami Adel',
      ownerRole: 'NovaGrid Engineer',
      ownerPhone: '+972 594 555 555',
      ownerEmail: 'novagrid@sungate.com',
      tags: ['Suppliers'],
      imageProfile: 'assets/images/profile.jpg',
    ),
  ];
  return HomeState(
    categories: categories,
    companies: companies,
    products: products,
  );
});
