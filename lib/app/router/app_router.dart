import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/login_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/new_password_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/otp_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/company_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';
import 'package:sun_gate_app/features/home/presentation/screens/all_company_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/category_products_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/company_detail_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/create_product_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/home_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/market_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/product_detail_screen.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:sun_gate_app/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/help_support_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/legal_policies_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/user_info_screen.dart';
import 'package:sun_gate_app/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OtpScreen(email: email);
        },
      ),
      GoRoute(
        path: RouteNames.newPassword,
        builder: (context, state) {
          final args = state.extra as Map<String, String>? ?? {};
          return NewPasswordScreen(
            email: args['email'] ?? '',
            token: args['token'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.userInfo,
        builder: (context, state) => const UserInfoScreen(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.legalPolicies,
        builder: (context, state) => const LegalPoliciesScreen(),
      ),
      GoRoute(
        path: RouteNames.helpSupport,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.allCompanies,
        builder: (context, state) => const AllCompanyScreen(),
      ),
      GoRoute(
        path: RouteNames.companyDetail,
        builder: (context, state) {
          final company = state.extra as CompanyModel;
          return CompanyDetailScreen(company: company);
        },
      ),
      GoRoute(
        path: RouteNames.productDetail,
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: RouteNames.categoryProducts,
        builder: (context, state) {
          final category = state.extra as CategoryItemModel;
          return CategoryProductsScreen(category: category);
        },
      ),
      GoRoute(
        path: RouteNames.createProduct,
        builder: (context, state) => const CreateProductScreen(),
      ),
      GoRoute(
        path: RouteNames.market,
        builder: (context, state) => const MarketScreen(),
      ),
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => const MainNavigationScreen(),
      ),
    ],
  );
}
