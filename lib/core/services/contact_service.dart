import 'package:url_launcher/url_launcher.dart';

class ContactService {
  static Future<void> call(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'cannot launch call';
    }
  }

  // static Future<void> email(String email) async {
  //   final Uri url = Uri(scheme: email, query: 'subject-contact&body=Hello');
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Cannot launch email';
  //   }
  // }
}
