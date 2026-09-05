import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient_model.dart';
import '../repositories/patient_repository.dart';

final patientRepositoryProvider = Provider<IPatientRepository>((ref) {
  return MockPatientRepository();
});

class PatientListNotifier extends StateNotifier<AsyncValue<List<PatientModel>>> {
  final IPatientRepository _repository;

  PatientListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPatients();
  }

  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    try {
      final patients = await _repository.getPatients();
      state = AsyncValue.data(patients);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<PatientModel> registerPatient(PatientModel patient) async {
    final registered = await _repository.registerPatient(patient);
    // Reload state
    await loadPatients();
    return registered;
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final results = await _repository.searchPatients(query);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final patientListProvider =
    StateNotifierProvider<PatientListNotifier, AsyncValue<List<PatientModel>>>((ref) {
  final repo = ref.watch(patientRepositoryProvider);
  return PatientListNotifier(repo);
});

final selectedPatientProvider = StateProvider<PatientModel?>((ref) => null);
