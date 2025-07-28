import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/shared/service/hive_service.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});
