import 'package:flutter_test/flutter_test.dart';
import 'package:careconnect_maharashtra/models/vitals_model.dart';
import 'package:careconnect_maharashtra/models/triage_result_model.dart';
import 'package:careconnect_maharashtra/services/triage_rule_engine.dart';

void main() {
  group('Clinical Triage Rule Engine Tests', () {
    test('Identifies Critical Hypoxia (SpO2 < 90%) as EMERGENCY', () {
      final vitals = const VitalsModel(
        heartRate: 85,
        systolicBP: 120,
        diastolicBP: 80,
        spo2: 86.0, // Critical
        temperature: 98.6,
        respiratoryRate: 22,
        consciousness: ConsciousnessLevel.alert,
      );

      final result = TriageRuleEngine.evaluate(
        patientId: 'TEST-001',
        patientName: 'Test Patient',
        vitals: vitals,
        symptoms: ['Breathlessness'],
      );

      expect(result.urgency, equals(TriageUrgency.emergency));
      expect(result.isEmergency, isTrue);
      expect(result.riskFactors.any((r) => r.contains('Critical Hypoxia')), isTrue);
    });

    test('Identifies Hypotensive Shock (Systolic BP < 90) as EMERGENCY', () {
      final vitals = const VitalsModel(
        heartRate: 130, // Severe Tachycardia
        systolicBP: 80, // Shock
        diastolicBP: 50,
        spo2: 95.0,
        temperature: 97.4,
        respiratoryRate: 26,
        consciousness: ConsciousnessLevel.alert,
      );

      final result = TriageRuleEngine.evaluate(
        patientId: 'TEST-002',
        patientName: 'Shock Patient',
        vitals: vitals,
        symptoms: ['Trauma', 'Bleeding'],
      );

      expect(result.urgency, equals(TriageUrgency.emergency));
      expect(result.riskFactors.any((r) => r.contains('Hypotension')), isTrue);
    });

    test('Identifies Acute STEMI / Severe Chest Pain as EMERGENCY', () {
      final vitals = const VitalsModel(
        heartRate: 115,
        systolicBP: 165,
        diastolicBP: 98,
        spo2: 93.0,
        temperature: 98.4,
        respiratoryRate: 20,
        consciousness: ConsciousnessLevel.alert,
      );

      final result = TriageRuleEngine.evaluate(
        patientId: 'TEST-003',
        patientName: 'Cardiac Patient',
        vitals: vitals,
        symptoms: ['Chest Pain', 'Breathlessness'],
      );

      expect(result.urgency, equals(TriageUrgency.emergency));
      expect(result.recommendedReferral.contains('Cath Lab'), isTrue);
    });

    test('Identifies Stable Vitals as ROUTINE', () {
      final vitals = const VitalsModel(
        heartRate: 72,
        systolicBP: 118,
        diastolicBP: 76,
        spo2: 99.0,
        temperature: 98.6,
        respiratoryRate: 16,
        consciousness: ConsciousnessLevel.alert,
      );

      final result = TriageRuleEngine.evaluate(
        patientId: 'TEST-004',
        patientName: 'Routine Patient',
        vitals: vitals,
        symptoms: ['Fever'],
      );

      expect(result.urgency, equals(TriageUrgency.routine));
      expect(result.isRoutine, isTrue);
    });
  });
}
