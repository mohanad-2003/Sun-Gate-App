import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/account_type_selection_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/company_sign_up_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/login_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/new_password_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/otp_screen.dart';
import 'package:sun_gate_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/battery_capacity_advanced_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/calculator_summary_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/charge_controller_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/device_consumpation_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/inverter_power_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/number_of_panels_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/return_on_investment_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/system_efficiency_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/title_of_panels_screen.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/wire_cross_section_screen.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/presentation/screen/all_company_screen.dart';
import 'package:sun_gate_app/features/marketplace/presentation/screen/company_details_screen.dart';
import 'package:sun_gate_app/features/marketplace/presentation/screen/create_product_screen.dart';
import 'package:sun_gate_app/features/marketplace/presentation/screen/market_screen.dart';
import 'package:sun_gate_app/features/marketplace/presentation/screen/product_details_screen.dart';
import 'package:sun_gate_app/features/notifications/presentation/screens/notification_screen.dart';
import 'package:sun_gate_app/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/change_password_screen.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/complete_profile_screen.dart';
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
        path: RouteNames.accountType,
        builder: (context, state) => const AccountTypeSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.companySignUp,
        builder: (context, state) => const CompanySignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return OtpScreen(
            email: args['email'] as String? ?? '',
            flowType:
                args['flowType'] as OtpFlowType? ?? OtpFlowType.verifyEmail,
            companyRegistrationData:
                args['companyRegistrationData'] as Map<String, dynamic>?,
          );
        },
      ),
      GoRoute(
        path: RouteNames.newPassword,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return NewPasswordScreen(
            email: args['email'] ?? '',
            token: args['token'] ?? '',
            flowType:
                args['flowType'] as OtpFlowType? ?? OtpFlowType.verifyEmail,
            companyRegistrationData:
                args['companyRegistrationData'] as Map<String, dynamic>?,
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
        path: RouteNames.market,
        builder: (context, state) => const MarketScreen(),
      ),
      GoRoute(
        path: RouteNames.companyDetail,
        builder: (context, state) {
          final company = state.extra as CompanyEntity;
          return CompanyDetailScreen(company: company);
        },
      ),
      GoRoute(
        path: RouteNames.productDetail,
        builder: (context, state) {
          final product = state.extra as ProductEntity;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: RouteNames.createProduct,
        builder: (context, state) => const CreateProductScreen(),
      ),
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: RouteNames.calculator,
        builder: (context, state) => CalculatorScreen(),
      ),
      GoRoute(
        path: RouteNames.deviceConsumption,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return DeviceConsumptionScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.numberOfPanels,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return NumberOfPanelsScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.allCompanies,
        builder: (context, state) => const AllCompanyScreen(),
      ),
      GoRoute(
        path: RouteNames.batteryCapacity,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return BatteryCapacityAdvancedScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.tiltOfPanels,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return TiltOfPanelsScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.systemEfficiency,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return SystemEfficiencyScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.inverterPower,
        builder: (context, state) => const InverterPowerScreen(),
      ),
      GoRoute(
        path: RouteNames.wireCrossSection,
        builder: (context, state) => const WireCrossSectionScreen(),
      ),
      GoRoute(
        path: RouteNames.chargeController,
        builder: (context, state) => const ChargeControllerScreen(),
      ),
      GoRoute(
        path: RouteNames.returnOnInvestment,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return ReturnOnInvestmentScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.calculatorSummary,
        builder: (context, state) {
          final data =
              state.extra as CalculatorFlowData? ?? const CalculatorFlowData();
          return CalculatorSummaryScreen(flowData: data);
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.completeProfile,
        builder: (context, state) => const CompleteProfileScreen(),
      ),
    ],
  );
}