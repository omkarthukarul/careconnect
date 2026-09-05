import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/facility_model.dart';
import '../models/triage_result_model.dart';
import '../repositories/facility_repository.dart';

final facilityRepositoryProvider = Provider<IFacilityRepository>((ref) {
  return MockFacilityRepository();
});

class FacilityListNotifier extends StateNotifier<AsyncValue<List<FacilityModel>>> {
  final IFacilityRepository _repository;

  FacilityListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFacilities();
  }

  Future<void> loadFacilities() async {
    state = const AsyncValue.loading();
    try {
      final facilities = await _repository.getFacilities();
      state = AsyncValue.data(facilities);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCapacity({
    required String facilityId,
    int? icuAvailable,
    int? oxygenAvailable,
    int? ventilatorsAvailable,
  }) async {
    try {
      await _repository.updateCapacity(
        facilityId: facilityId,
        icuAvailable: icuAvailable,
        oxygenAvailable: oxygenAvailable,
        ventilatorsAvailable: ventilatorsAvailable,
      );
      await loadFacilities();
    } catch (_) {}
  }

  Future<void> reserveBed({
    required String facilityId,
    required String bedType,
  }) async {
    try {
      await _repository.reserveBed(
        facilityId: facilityId,
        bedType: bedType,
      );
      await loadFacilities();
    } catch (_) {}
  }
}

final facilityListProvider =
    StateNotifierProvider<FacilityListNotifier, AsyncValue<List<FacilityModel>>>((ref) {
  final repo = ref.watch(facilityRepositoryProvider);
  return FacilityListNotifier(repo);
});

final selectedFacilityProvider = StateProvider<FacilityModel?>((ref) => null);

final rankedFacilitiesProvider = FutureProvider.family<List<FacilityModel>, TriageUrgency>((ref, urgency) async {
  final repo = ref.watch(facilityRepositoryProvider);
  return repo.rankFacilitiesForPatient(urgency: urgency);
});
