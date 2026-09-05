import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vitals_model.dart';
import '../models/triage_result_model.dart';
import '../services/triage_rule_engine.dart';

final currentVitalsProvider = StateProvider<VitalsModel>((ref) {
  return VitalsModel.empty();
});

final currentSymptomsProvider = StateProvider<List<String>>((ref) {
  return [];
});

class TriageHistoryNotifier extends StateNotifier<List<TriageResultModel>> {
  TriageHistoryNotifier() : super([]);

  void addResult(TriageResultModel result) {
    state = [result, ...state];
  }
}

final triageHistoryProvider =
    StateNotifierProvider<TriageHistoryNotifier, List<TriageResultModel>>((ref) {
  return TriageHistoryNotifier();
});

final latestTriageResultProvider = StateProvider<TriageResultModel?>((ref) => null);

class TriageController {
  final Ref _ref;

  TriageController(this._ref);

  TriageResultModel runTriage({
    required String patientId,
    required String patientName,
    String? clinicalNotes,
  }) {
    final vitals = _ref.read(currentVitalsProvider);
    final symptoms = _ref.read(currentSymptomsProvider);

    final result = TriageRuleEngine.evaluate(
      patientId: patientId,
      patientName: patientName,
      vitals: vitals,
      symptoms: symptoms,
      clinicalNotes: clinicalNotes,
    );

    _ref.read(latestTriageResultProvider.notifier).state = result;
    _ref.read(triageHistoryProvider.notifier).addResult(result);
    return result;
  }
}

final triageControllerProvider = Provider<TriageController>((ref) {
  return TriageController(ref);
});
