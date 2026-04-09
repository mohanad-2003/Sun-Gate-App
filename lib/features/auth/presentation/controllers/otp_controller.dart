import 'package:flutter_riverpod/legacy.dart';

final otpDigitProvider = StateProvider<List<String>>((ref) {
  return ['', '', '', ''];
});
