class PatientModel {
  final String id;
  final String fullName;
  final int age;
  final String gender;
  final String mobile;
  final String village;
  final String district;
  final String emergencyContact;
  final String? abhaId;
  final DateTime registrationDate;
  final String? chiefComplaint;

  const PatientModel({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.village,
    required this.district,
    required this.emergencyContact,
    this.abhaId,
    required this.registrationDate,
    this.chiefComplaint,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      mobile: json['mobile'] as String,
      village: json['village'] as String,
      district: json['district'] as String,
      emergencyContact: json['emergencyContact'] as String,
      abhaId: json['abhaId'] as String?,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      chiefComplaint: json['chiefComplaint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'mobile': mobile,
      'village': village,
      'district': district,
      'emergencyContact': emergencyContact,
      'abhaId': abhaId,
      'registrationDate': registrationDate.toIso8601String(),
      'chiefComplaint': chiefComplaint,
    };
  }

  PatientModel copyWith({
    String? id,
    String? fullName,
    int? age,
    String? gender,
    String? mobile,
    String? village,
    String? district,
    String? emergencyContact,
    String? abhaId,
    DateTime? registrationDate,
    String? chiefComplaint,
  }) {
    return PatientModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      mobile: mobile ?? this.mobile,
      village: village ?? this.village,
      district: district ?? this.district,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      abhaId: abhaId ?? this.abhaId,
      registrationDate: registrationDate ?? this.registrationDate,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
    );
  }
}
