enum ConsciousnessLevel {
  alert('A - Alert', 'जागृत'),
  verbal('V - Responds to Voice', 'आवाजाला प्रतिसाद'),
  pain('P - Responds to Pain', 'वेदनांना प्रतिसाद'),
  unresponsive('U - Unresponsive', 'अचेतन / प्रतिसाद नाही');

  final String labelEn;
  final String labelMr;

  const ConsciousnessLevel(this.labelEn, this.labelMr);
}

class VitalsModel {
  final int heartRate; // bpm
  final int systolicBP; // mmHg
  final int diastolicBP; // mmHg
  final double spo2; // %
  final double temperature; // °F
  final int respiratoryRate; // breaths/min
  final ConsciousnessLevel consciousness;

  const VitalsModel({
    required this.heartRate,
    required this.systolicBP,
    required this.diastolicBP,
    required this.spo2,
    required this.temperature,
    required this.respiratoryRate,
    required this.consciousness,
  });

  factory VitalsModel.empty() {
    return const VitalsModel(
      heartRate: 75,
      systolicBP: 120,
      diastolicBP: 80,
      spo2: 98.0,
      temperature: 98.6,
      respiratoryRate: 16,
      consciousness: ConsciousnessLevel.alert,
    );
  }

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      heartRate: (json['heartRate'] as num?)?.toInt() ?? 75,
      systolicBP: (json['systolicBP'] as num?)?.toInt() ?? 120,
      diastolicBP: (json['diastolicBP'] as num?)?.toInt() ?? 80,
      spo2: (json['spo2'] as num?)?.toDouble() ?? 98.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 98.6,
      respiratoryRate: (json['respiratoryRate'] as num?)?.toInt() ?? 16,
      consciousness: ConsciousnessLevel.values.firstWhere(
        (c) => c.name == json['consciousness'],
        orElse: () => ConsciousnessLevel.alert,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'spo2': spo2,
      'temperature': temperature,
      'respiratoryRate': respiratoryRate,
      'consciousness': consciousness.name,
    };
  }

  VitalsModel copyWith({
    int? heartRate,
    int? systolicBP,
    int? diastolicBP,
    double? spo2,
    double? temperature,
    int? respiratoryRate,
    ConsciousnessLevel? consciousness,
  }) {
    return VitalsModel(
      heartRate: heartRate ?? this.heartRate,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
      spo2: spo2 ?? this.spo2,
      temperature: temperature ?? this.temperature,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      consciousness: consciousness ?? this.consciousness,
    );
  }
}
