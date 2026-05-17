import 'package:flutter_riverpod/legacy.dart';

/// `null` = all accounts. Otherwise: `user`, `engineer`, or `company`.
final adminAccountRoleFilterProvider = StateProvider<String?>((ref) => null);
