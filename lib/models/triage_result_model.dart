import 'vitals_model.dart';

enum TriageUrgency {
  emergency('EMERGENCY', 'आपत्कालीन', 1),
  urgent('URGENT', 'तातडीचे', 2),
  routine('ROUTINE', 'नियमित', 3);

  final String labelEn;
  final String labelMr;
  final int priority;

  const TriageUrgency(this.labelEn, this.labelMr, this.priority);
}

class TriageResultModel {
  final String id;
  final String patientId;
  final String patientName;
  final TriageUrgency urgency;
  final List<String> riskFactors;
  final String recommendedReferral;
  final DateTime timestamp;
  final VitalsModel vitals;
  final List<String> symptoms;
  final String? clinicalNotes;

  const TriageResultModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.urgency,
    required this.riskFactors,
    required this.recommendedReferral,
    required this.timestamp,
    required this.vitals,
    required this.symptoms,
    this.clinicalNotes,
  });

  bool get isEmergency => urgency == TriageUrgency.emergency;
  bool get isUrgent => urgency == TriageUrgency.urgent;
  bool get isRoutine => urgency == TriageUrgency.routine;

  factory TriageResultModel.fromJson(Map<String, dynamic> json) {
    return TriageResultModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      urgency: TriageUrgency.values.firstWhere(
        (u) => u.name == json['urgency'],
        orElse: () => TriageUrgency.routine,
      ),
      riskFactors: List<String>.from(json['riskFactors'] as List),
      recommendedReferral: json['recommendedReferral'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      vitals: VitalsModel.fromJson(json['vitals'] as Map<String, dynamic>),
      symptoms: List<String>.from(json['symptoms'] as List),
      clinicalNotes: json['clinicalNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'urgency': urgency.name,
      'riskFactors': riskFactors,
      'recommendedReferral': recommendedReferral,
      'timestamp': timestamp.toIso8601String(),
      'vitals': vitals.toJson(),
      'symptoms': symptoms,
      'clinicalNotes': clinicalNotes,
    };
  }
}
