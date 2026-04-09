import 'package:flutter/widgets.dart';

class AppStrings {
  static bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  static String get(BuildContext context, String key) {
    final isAr = isArabic(context);

    final ar = <String, String>{
      'onboarding_1_title': 'تخطيط ذكي للطاقة\nوإدارة الاستهلاك اليومي',
      'onboarding_1_desc': 'توصيات مخصصة لمساعدتك على التغلب على مشاكل الكهرباء',
      'onboarding_2_title': 'شبكة محلية موثوقة\nللتواصل مع الخبراء',
      'onboarding_2_desc': 'تواصل مع مزودين محليين موثوقين وفنيين مختصين لبناء وصيانة نظامك الشمسي',
      'onboarding_3_title': 'دقة بين يديك\nوحسابات تقنية دقيقة',
      'onboarding_3_desc': 'احسب احتياجات نظامك الشمسي من الألواح حتى سعة البطاريات باستخدام أدواتنا المتقدمة',
      'onboarding_4_title': 'طاقتك\nتدار بذكاء',
      'onboarding_4_desc': 'Sun Gate. تمكين مستقبلك بالطاقة الشمسية',
      'skip': 'تخطي',
      'get_started': 'ابدأ الآن',
      'dont_have_account': 'ليس لديك حساب؟ ',
      'sign_up': 'إنشاء حساب',
      'sun_gate': 'Sun Gate',
    };

    final en = <String, String>{
      'onboarding_1_title': 'Smart Energy Planning\nDaily Consumption Efficiently',
      'onboarding_1_desc': 'Tailored recommendations to help you overcome electricity shortages',
      'onboarding_2_title': 'Trusted Local Network\nConnecting with Experts',
      'onboarding_2_desc': 'Connect with verified local suppliers and expert technicians to build and maintain your solar system',
      'onboarding_3_title': 'Precision at Your Fingertips\nTechnical Accuracy',
      'onboarding_3_desc': 'Calculate your solar system needs, from panels to battery capacity, using our advanced calculators',
      'onboarding_4_title': 'Your Energy\nManaged Wisely',
      'onboarding_4_desc': 'Sun Gate. Empowering Your Future with Solar Energy',
      'skip': 'Skip',
      'get_started': 'Get Started',
      'dont_have_account': 'Don’t have an account? ',
      'sign_up': 'Sign Up',
      'sun_gate': 'Sun Gate',
    };

    return isAr ? (ar[key] ?? key) : (en[key] ?? key);
  }
}