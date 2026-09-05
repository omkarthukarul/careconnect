import '../models/facility_model.dart';
import '../models/triage_result_model.dart';
import '../mock_data/mock_facilities.dart';
import '../services/api_service.dart';

abstract class IFacilityRepository {
  Future<List<FacilityModel>> getFacilities();
  Future<FacilityModel?> getFacilityById(String id);
  Future<FacilityModel> reserveBed({
    required String facilityId,
    required String bedType,
  });
  Future<FacilityModel> updateCapacity({
    required String facilityId,
    int? icuAvailable,
    int? oxygenAvailable,
    int? ventilatorsAvailable,
  });
  Future<List<FacilityModel>> rankFacilitiesForPatient({
    required TriageUrgency urgency,
    String? requiredSpecialty,
  });
}

class MockFacilityRepository implements IFacilityRepository {
  final List<FacilityModel> _facilities = List.from(MockFacilities.facilities);

  @override
  Future<List<FacilityModel>> getFacilities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_facilities);
  }

  @override
  Future<FacilityModel?> getFacilityById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<FacilityModel> reserveBed({
    required String facilityId,
    required String bedType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _facilities.indexWhere((f) => f.id == facilityId);
    if (index == -1) throw Exception('Facility not found');

    final current = _facilities[index];
    int newIcu = current.icuAvailable;
    int newOxygen = current.oxygenAvailable;

    if (bedType.toUpperCase().contains('ICU') && current.icuAvailable > 0) {
      newIcu -= 1;
    } else if (bedType.toUpperCase().contains('OXYGEN') && current.oxygenAvailable > 0) {
      newOxygen -= 1;
    }

    final updated = current.copyWith(
      icuAvailable: newIcu,
      oxygenAvailable: newOxygen,
    );
    _facilities[index] = updated;
    return updated;
  }

  @override
  Future<FacilityModel> updateCapacity({
    required String facilityId,
    int? icuAvailable,
    int? oxygenAvailable,
    int? ventilatorsAvailable,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _facilities.indexWhere((f) => f.id == facilityId);
    if (index == -1) throw Exception('Facility not found');

    final current = _facilities[index];
    final updated = current.copyWith(
      icuAvailable: icuAvailable ?? current.icuAvailable,
      oxygenAvailable: oxygenAvailable ?? current.oxygenAvailable,
      ventilatorsAvailable: ventilatorsAvailable ?? current.ventilatorsAvailable,
    );
    _facilities[index] = updated;
    return updated;
  }

  @override
  Future<List<FacilityModel>> rankFacilitiesForPatient({
    required TriageUrgency urgency,
    String? requiredSpecialty,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final list = List<FacilityModel>.from(_facilities);

    // Dynamic heuristic ranking:
    // Score based on distance, bed availability, and specialty matching
    list.sort((a, b) {
      int scoreA = 0;
      int scoreB = 0;

      if (urgency == TriageUrgency.emergency) {
        // High priority on ICU beds, ventilators, and shortest ETA
        scoreA += a.icuAvailable * 10;
        scoreB += b.icuAvailable * 10;
        scoreA += a.ventilatorsAvailable * 5;
        scoreB += b.ventilatorsAvailable * 5;
        scoreA -= (a.etaMinutes * 2);
        scoreB -= (b.etaMinutes * 2);
      } else {
        scoreA += a.oxygenAvailable * 5;
        scoreB += b.oxygenAvailable * 5;
        scoreA -= a.etaMinutes;
        scoreB -= b.etaMinutes;
      }

      if (requiredSpecialty != null && requiredSpecialty.isNotEmpty) {
        if (a.specialties.any((s) => s.toLowerCase().contains(requiredSpecialty.toLowerCase()))) {
          scoreA += 50;
        }
        if (b.specialties.any((s) => s.toLowerCase().contains(requiredSpecialty.toLowerCase()))) {
          scoreB += 50;
        }
      }

      return scoreB.compareTo(scoreA); // Highest score first
    });

    return list;
  }
}

class ApiFacilityRepository implements IFacilityRepository {
  final ApiService _api;

  ApiFacilityRepository({required ApiService api}) : _api = api;

  @override
  Future<List<FacilityModel>> getFacilities() async {
    final res = await _api.get('/facilities');
    final list = res.data as List;
    return list.map((e) => FacilityModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<FacilityModel?> getFacilityById(String id) async {
    final res = await _api.get('/facilities/$id');
    return FacilityModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<FacilityModel> reserveBed({required String facilityId, required String bedType}) async {
    final res = await _api.post('/facilities/$facilityId/reserve', data: {'bedType': bedType});
    return FacilityModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<FacilityModel> updateCapacity({
    required String facilityId,
    int? icuAvailable,
    int? oxygenAvailable,
    int? ventilatorsAvailable,
  }) async {
    final res = await _api.put('/facilities/$facilityId/capacity', data: {
      if (icuAvailable != null) 'icuAvailable': icuAvailable,
      if (oxygenAvailable != null) 'oxygenAvailable': oxygenAvailable,
      if (ventilatorsAvailable != null) 'ventilatorsAvailable': ventilatorsAvailable,
    });
    return FacilityModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<FacilityModel>> rankFacilitiesForPatient({
    required TriageUrgency urgency,
    String? requiredSpecialty,
  }) async {
    final res = await _api.get('/facilities/rank', queryParameters: {
      'urgency': urgency.name,
      if (requiredSpecialty != null) 'specialty': requiredSpecialty,
    });
    final list = res.data as List;
    return list.map((e) => FacilityModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
