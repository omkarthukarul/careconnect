enum UserRole {
  medicalOfficer('Medical Officer', 'वैद्यकीय अधिकारी'),
  hospitalStaff('Hospital Staff', 'रुग्णालय कर्मचारी'),
  ambulanceEMS('Ambulance / EMS', 'रुग्णवाहिका / आपत्कालीन'),
  patient('Patient', 'रुग्ण / नागरिक');

  final String labelEn;
  final String labelMr;

  const UserRole(this.labelEn, this.labelMr);
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final UserRole role;
  final String facilityName;
  final String district;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.facilityName,
    required this.district,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.medicalOfficer,
      ),
      facilityName: json['facilityName'] as String? ?? 'District Health Office',
      district: json['district'] as String? ?? 'Pune',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'role': role.name,
      'facilityName': facilityName,
      'district': district,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    UserRole? role,
    String? facilityName,
    String? district,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      facilityName: facilityName ?? this.facilityName,
      district: district ?? this.district,
    );
  }
}
