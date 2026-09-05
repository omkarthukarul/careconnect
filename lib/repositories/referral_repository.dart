import '../models/referral_model.dart';
import '../models/triage_result_model.dart';
import '../mock_data/mock_referrals.dart';
import '../services/api_service.dart';

abstract class IReferralRepository {
  Future<List<ReferralModel>> getReferrals();
  Future<ReferralModel?> getReferralById(String id);
  Future<ReferralModel> createReferral(ReferralModel referral);
  Future<ReferralModel> advanceStatus({
    required String referralId,
    required ReferralStatus nextStatus,
    required String note,
  });
  Future<List<ReferralModel>> getReferralsByUrgency(TriageUrgency urgency);
}

class MockReferralRepository implements IReferralRepository {
  final List<ReferralModel> _referrals = List.from(MockReferrals.referrals);

  @override
  Future<List<ReferralModel>> getReferrals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_referrals);
  }

  @override
  Future<ReferralModel?> getReferralById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _referrals.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ReferralModel> createReferral(ReferralModel referral) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _referrals.insert(0, referral);
    return referral;
  }

  @override
  Future<ReferralModel> advanceStatus({
    required String referralId,
    required ReferralStatus nextStatus,
    required String note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _referrals.indexWhere((r) => r.id == referralId);
    if (index == -1) throw Exception('Referral not found');

    final current = _referrals[index];
    final updatedEvents = List<ReferralStatusEvent>.from(current.events)
      ..add(ReferralStatusEvent(
        status: nextStatus,
        timestamp: DateTime.now(),
        note: note,
      ));

    final updated = current.copyWith(
      status: nextStatus,
      updatedAt: DateTime.now(),
      events: updatedEvents,
    );

    _referrals[index] = updated;
    return updated;
  }

  @override
  Future<List<ReferralModel>> getReferralsByUrgency(TriageUrgency urgency) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _referrals.where((r) => r.urgency == urgency).toList();
  }
}

class ApiReferralRepository implements IReferralRepository {
  final ApiService _api;

  ApiReferralRepository({required ApiService api}) : _api = api;

  @override
  Future<List<ReferralModel>> getReferrals() async {
    final res = await _api.get('/referrals');
    final list = res.data as List;
    return list.map((e) => ReferralModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ReferralModel?> getReferralById(String id) async {
    final res = await _api.get('/referrals/$id');
    return ReferralModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<ReferralModel> createReferral(ReferralModel referral) async {
    final res = await _api.post('/referrals', data: referral.toJson());
    return ReferralModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<ReferralModel> advanceStatus({
    required String referralId,
    required ReferralStatus nextStatus,
    required String note,
  }) async {
    final res = await _api.put('/referrals/$referralId/status', data: {
      'status': nextStatus.name,
      'note': note,
    });
    return ReferralModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<ReferralModel>> getReferralsByUrgency(TriageUrgency urgency) async {
    final res = await _api.get('/referrals', queryParameters: {'urgency': urgency.name});
    final list = res.data as List;
    return list.map((e) => ReferralModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
