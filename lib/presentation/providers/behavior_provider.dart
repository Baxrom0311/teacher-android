import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/behavior_api.dart';
import '../../data/models/behavior_model.dart';
import 'auth_provider.dart';

final behaviorApiProvider = Provider<BehaviorApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BehaviorApi(apiService);
});

class BehaviorListState {
  final bool isLoading;
  final String? error;
  final List<BehaviorIncidentModel> incidents;
  final bool isCreating;

  const BehaviorListState({
    this.isLoading = false,
    this.error,
    this.incidents = const [],
    this.isCreating = false,
  });
}

class BehaviorListNotifier extends StateNotifier<BehaviorListState> {
  final BehaviorApi _api;

  BehaviorListNotifier(this._api) : super(const BehaviorListState());

  Future<void> loadIncidents({String? type}) async {
    state = const BehaviorListState(isLoading: true);
    try {
      final incidents = await _api.getIncidents(type: type);
      state = BehaviorListState(incidents: incidents);
    } catch (e) {
      state = BehaviorListState(error: e.toString());
    }
  }

  Future<bool> createIncident({
    required int studentId,
    required String type,
    required String category,
    String? description,
    required int points,
    required String incidentDate,
  }) async {
    state = BehaviorListState(incidents: state.incidents, isCreating: true);
    try {
      final incident = await _api.createIncident(
        studentId: studentId,
        type: type,
        category: category,
        description: description,
        points: points,
        incidentDate: incidentDate,
      );
      state = BehaviorListState(incidents: [incident, ...state.incidents]);
      return true;
    } catch (e) {
      state = BehaviorListState(incidents: state.incidents, error: e.toString());
      return false;
    }
  }
}

final behaviorListProvider =
    StateNotifierProvider.autoDispose<BehaviorListNotifier, BehaviorListState>(
  (ref) {
    final api = ref.watch(behaviorApiProvider);
    return BehaviorListNotifier(api);
  },
);
