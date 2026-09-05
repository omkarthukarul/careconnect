import '../models/vitals_model.dart';
import '../models/triage_result_model.dart';

class TriageRuleEngine {
  TriageRuleEngine._();

  /// Evaluates clinical input and returns an algorithmic Triage recommendation
  /// Note: Decision-support prototype, NOT an autonomous medical diagnosis system.
  static TriageResultModel evaluate({
    required String patientId,
    required String patientName,
    required VitalsModel vitals,
    required List<String> symptoms,
    String? clinicalNotes,
  }) {
    final List<String> riskFactors = [];
    int emergencyScore = 0;
    int urgentScore = 0;

    // 1. SpO2 Analysis
    if (vitals.spo2 < 90.0) {
      riskFactors.add('Critical Hypoxia: SpO₂ is ${vitals.spo2.toStringAsFixed(1)}% (< 90%)');
      emergencyScore += 3;
    } else if (vitals.spo2 < 95.0) {
      riskFactors.add('Moderate Hypoxemia: SpO₂ is ${vitals.spo2.toStringAsFixed(1)}% (90-94%)');
      urgentScore += 1;
    }

    // 2. Blood Pressure Analysis
    if (vitals.systolicBP < 90) {
      riskFactors.add('Hypotension / Shock: Systolic BP is ${vitals.systolicBP} mmHg (< 90)');
      emergencyScore += 3;
    } else if (vitals.systolicBP >= 180) {
      riskFactors.add('Hypertensive Crisis: Systolic BP is ${vitals.systolicBP} mmHg (≥ 180)');
      emergencyScore += 2;
    } else if (vitals.systolicBP >= 140) {
      riskFactors.add('Stage 2 Hypertension: Systolic BP is ${vitals.systolicBP} mmHg');
      urgentScore += 1;
    }

    // 3. Heart Rate Analysis
    if (vitals.heartRate > 125) {
      riskFactors.add('Severe Tachycardia: Heart Rate is ${vitals.heartRate} bpm (> 125)');
      emergencyScore += 2;
    } else if (vitals.heartRate < 45) {
      riskFactors.add('Severe Bradycardia: Heart Rate is ${vitals.heartRate} bpm (< 45)');
      emergencyScore += 2;
    } else if (vitals.heartRate > 100) {
      riskFactors.add('Mild Tachycardia: Heart Rate is ${vitals.heartRate} bpm');
      urgentScore += 1;
    }

    // 4. Respiratory Rate Analysis
    if (vitals.respiratoryRate > 30 || vitals.respiratoryRate < 8) {
      riskFactors.add('Imminent Respiratory Failure: RR is ${vitals.respiratoryRate} /min');
      emergencyScore += 3;
    } else if (vitals.respiratoryRate > 22) {
      riskFactors.add('Tachypnea: Respiratory Rate is ${vitals.respiratoryRate} /min');
      urgentScore += 1;
    }

    // 5. Consciousness Assessment (AVPU)
    if (vitals.consciousness == ConsciousnessLevel.unresponsive) {
      riskFactors.add('Unresponsive patient (Comatose / GCS low)');
      emergencyScore += 4;
    } else if (vitals.consciousness == ConsciousnessLevel.pain) {
      riskFactors.add('Responds only to painful stimuli (Altered Sensorium)');
      emergencyScore += 3;
    } else if (vitals.consciousness == ConsciousnessLevel.verbal) {
      riskFactors.add('Altered mental state: Responds only to verbal commands');
      urgentScore += 2;
    }

    // 6. Symptoms Cross-Matching
    final lowerSymptoms = symptoms.map((s) => s.toLowerCase()).toList();
    final hasChestPain = lowerSymptoms.any((s) => s.contains('chest pain'));
    final hasBreathlessness = lowerSymptoms.any((s) => s.contains('breathlessness'));
    final hasBleeding = lowerSymptoms.any((s) => s.contains('bleeding'));
    final hasTrauma = lowerSymptoms.any((s) => s.contains('trauma'));
    final hasFever = lowerSymptoms.any((s) => s.contains('fever'));

    if (hasChestPain && (vitals.heartRate > 95 || vitals.systolicBP >= 140 || vitals.systolicBP < 95)) {
      riskFactors.add('Suspected Acute Coronary Syndrome (ACS) with hemodynamic anomaly');
      emergencyScore += 3;
    } else if (hasChestPain) {
      riskFactors.add('Chest pain with potential cardiac etiology');
      urgentScore += 2;
    }

    if (hasBreathlessness && vitals.spo2 < 94) {
      riskFactors.add('Acute Respiratory Distress with oxygen desaturation');
      emergencyScore += 3;
    }

    if (hasBleeding && (hasTrauma || vitals.systolicBP < 100)) {
      riskFactors.add('Active hemorrhage with threat of hypovolemic shock');
      emergencyScore += 3;
    }

    if (hasTrauma && vitals.consciousness != ConsciousnessLevel.alert) {
      riskFactors.add('Trauma with suspected traumatic brain injury (TBI)');
      emergencyScore += 3;
    }

    if (hasFever && vitals.temperature >= 102.5) {
      riskFactors.add('High-grade Hyperpyrexia: Temperature ${vitals.temperature}°F');
      urgentScore += 1;
    }

    // Final Urgency Classification
    TriageUrgency urgency;
    String recommendation;

    if (emergencyScore >= 2 || (emergencyScore >= 1 && urgentScore >= 2)) {
      urgency = TriageUrgency.emergency;
      if (hasChestPain) {
        recommendation = 'Immediate referral to Tertiary Hospital with 24/7 Cath Lab & Intensive Cardiac Care Unit (ICCU). Dispatch 108 ALS Ambulance.';
      } else if (hasTrauma || hasBleeding) {
        recommendation = 'Immediate transfer to Level-1 Trauma Center with Surgical OT & Blood Bank standby. Dispatch ALS Ambulance.';
      } else if (vitals.spo2 < 90 || hasBreathlessness) {
        recommendation = 'Immediate transfer to Intensive Care Unit (ICU) with High-Flow Nasal Cannula or Invasive Ventilator support.';
      } else {
        recommendation = 'Immediate Emergency Department admission at District Hospital with Resuscitation bay.';
      }
    } else if (urgentScore >= 1 || emergencyScore == 1) {
      urgency = TriageUrgency.urgent;
      recommendation = 'Urgent evaluation at Sub-District or District Hospital within 1-2 hours. Initiate supplemental oxygen or IV fluids as indicated.';
    } else {
      urgency = TriageUrgency.routine;
      if (riskFactors.isEmpty) {
        riskFactors.add('Vital signs within normal physiological ranges.');
      }
      recommendation = 'Standard Outpatient Department (OPD) consultation at Primary Health Centre (PHC) or Community Health Centre (CHC).';
    }

    return TriageResultModel(
      id: 'TR-${DateTime.now().millisecondsSinceEpoch % 100000}',
      patientId: patientId,
      patientName: patientName,
      urgency: urgency,
      riskFactors: riskFactors,
      recommendedReferral: recommendation,
      timestamp: DateTime.now(),
      vitals: vitals,
      symptoms: symptoms,
      clinicalNotes: clinicalNotes,
    );
  }
}
