import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/dashboard_api.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'auth_provider.dart';

final dashboardApiProvider = Provider<DashboardApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return DashboardApi(apiService);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final api = ref.watch(dashboardApiProvider);
  return DashboardRepository(api);
});

final dashboardProvider = FutureProvider.autoDispose<TeacherDashboardResponse>((
  ref,
) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.fetchDashboard();
});
