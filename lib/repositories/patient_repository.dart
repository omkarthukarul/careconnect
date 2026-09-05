import '../models/patient_model.dart';
import '../mock_data/mock_patients.dart';
import '../services/api_service.dart';

abstract class IPatientRepository {
  Future<List<PatientModel>> getPatients();
  Future<PatientModel?> getPatientById(String id);
  Future<PatientModel> registerPatient(PatientModel patient);
  Future<List<PatientModel>> searchPatients(String query);
}

class MockPatientRepository implements IPatientRepository {
  final List<PatientModel> _patients = List.from(MockPatients.patients);

  @override
  Future<List<PatientModel>> getPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_patients);
  }

  @override
  Future<PatientModel?> getPatientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<PatientModel> registerPatient(PatientModel patient) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _patients.insert(0, patient);
    return patient;
  }

  @override
  Future<List<PatientModel>> searchPatients(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (query.trim().isEmpty) return List.unmodifiable(_patients);
    final q = query.toLowerCase();
    return _patients.where((p) {
      return p.fullName.toLowerCase().contains(q) ||
             p.id.toLowerCase().contains(q) ||
             p.mobile.contains(q) ||
             (p.abhaId?.contains(q) ?? false);
    }).toList();
  }
}

class ApiPatientRepository implements IPatientRepository {
  final ApiService _api;

  ApiPatientRepository({required ApiService api}) : _api = api;

  @override
  Future<List<PatientModel>> getPatients() async {
    final res = await _api.get('/patients');
    final list = res.data as List;
    return list.map((e) => PatientModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PatientModel?> getPatientById(String id) async {
    final res = await _api.get('/patients/$id');
    return PatientModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<PatientModel> registerPatient(PatientModel patient) async {
    final res = await _api.post('/patients', data: patient.toJson());
    return PatientModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<PatientModel>> searchPatients(String query) async {
    final res = await _api.get('/patients/search', queryParameters: {'q': query});
    final list = res.data as List;
    return list.map((e) => PatientModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
