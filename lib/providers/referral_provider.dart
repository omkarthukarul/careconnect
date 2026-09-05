import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/referral_model.dart';
import '../models/triage_result_model.dart';
import '../repositories/referral_repository.dart';

final referralRepositoryProvider = Provider<IReferralRepository>((ref) {
  return MockReferralRepository();
});

class ReferralListNotifier extends StateNotifier<AsyncValue<List<ReferralModel>>> {
  final IReferralRepository _repository;

  ReferralListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadReferrals();
  }

  Future<void> loadReferrals() async {
    state = const AsyncValue.loading();
    try {
      final referrals = await _repository.getReferrals();
      state = AsyncValue.data(referrals);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ReferralModel> createReferral(ReferralModel referral) async {
    final created = await _repository.createReferral(referral);
    await loadReferrals();
    return created;
  }

  Future<ReferralModel> advanceStatus({
    required String referralId,
    required ReferralStatus nextStatus,
    required String note,
  }) async {
    final updated = await _repository.advanceStatus(
      referralId: referralId,
      nextStatus: nextStatus,
      note: note,
    );
    await loadReferrals();
    return updated;
  }
}

final referralListProvider =
    StateNotifierProvider<ReferralListNotifier, AsyncValue<List<ReferralModel>>>((ref) {
  final repo = ref.watch(referralRepositoryProvider);
  return ReferralListNotifier(repo);
});

final activeReferralProvider = StateProvider<ReferralModel?>((ref) {
  final listAsync = ref.watch(referralListProvider);
  return listAsync.maybeWhen(
    data: (list) => list.isNotEmpty ? list.first : null,
    orElse: () => null,
  );
});

final emergencyReferralsCountProvider = Provider<int>((ref) {
  final listAsync = ref.watch(referralListProvider);
  return listAsync.maybeWhen(
    data: (list) => list.where((r) => r.urgency == TriageUrgency.emergency && r.status != ReferralStatus.completed).length,
    orElse: () => 0,
  );
});

final pendingReferralsCountProvider = Provider<int>((ref) {
  final listAsync = ref.watch(referralListProvider);
  return listAsync.maybeWhen(
    data: (list) => list.where((r) => r.status != ReferralStatus.completed).length,
    orElse: () => 0,
  );
});
