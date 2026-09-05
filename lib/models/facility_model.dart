class FacilityModel {
  final String id;
  final String name;
  final String type; // District Hospital, Medical College, Sub-District Hospital
  final String district;
  final double distanceKm;
  final int etaMinutes;
  final int totalBeds;
  final int icuBeds;
  final int icuAvailable;
  final int oxygenBeds;
  final int oxygenAvailable;
  final int ventilators;
  final int ventilatorsAvailable;
  final List<String> specialties;
  final List<String> equipment;
  final bool isAvailable;
  final String address;
  final String contactNumber;
  final double latitude;
  final double longitude;

  const FacilityModel({
    required this.id,
    required this.name,
    required this.type,
    required this.district,
    required this.distanceKm,
    required this.etaMinutes,
    required this.totalBeds,
    required this.icuBeds,
    required this.icuAvailable,
    required this.oxygenBeds,
    required this.oxygenAvailable,
    required this.ventilators,
    required this.ventilatorsAvailable,
    required this.specialties,
    required this.equipment,
    required this.isAvailable,
    required this.address,
    required this.contactNumber,
    required this.latitude,
    required this.longitude,
  });

  bool get hasIcu => icuAvailable > 0;
  bool get hasOxygen => oxygenAvailable > 0;
  bool get hasVentilator => ventilatorsAvailable > 0;

  FacilityModel copyWith({
    String? id,
    String? name,
    String? type,
    String? district,
    double? distanceKm,
    int? etaMinutes,
    int? totalBeds,
    int? icuBeds,
    int? icuAvailable,
    int? oxygenBeds,
    int? oxygenAvailable,
    int? ventilators,
    int? ventilatorsAvailable,
    List<String>? specialties,
    List<String>? equipment,
    bool? isAvailable,
    String? address,
    String? contactNumber,
    double? latitude,
    double? longitude,
  }) {
    return FacilityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      district: district ?? this.district,
      distanceKm: distanceKm ?? this.distanceKm,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      totalBeds: totalBeds ?? this.totalBeds,
      icuBeds: icuBeds ?? this.icuBeds,
      icuAvailable: icuAvailable ?? this.icuAvailable,
      oxygenBeds: oxygenBeds ?? this.oxygenBeds,
      oxygenAvailable: oxygenAvailable ?? this.oxygenAvailable,
      ventilators: ventilators ?? this.ventilators,
      ventilatorsAvailable: ventilatorsAvailable ?? this.ventilatorsAvailable,
      specialties: specialties ?? this.specialties,
      equipment: equipment ?? this.equipment,
      isAvailable: isAvailable ?? this.isAvailable,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      district: json['district'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      etaMinutes: json['etaMinutes'] as int,
      totalBeds: json['totalBeds'] as int,
      icuBeds: json['icuBeds'] as int,
      icuAvailable: json['icuAvailable'] as int,
      oxygenBeds: json['oxygenBeds'] as int,
      oxygenAvailable: json['oxygenAvailable'] as int,
      ventilators: json['ventilators'] as int,
      ventilatorsAvailable: json['ventilatorsAvailable'] as int,
      specialties: List<String>.from(json['specialties'] as List),
      equipment: List<String>.from(json['equipment'] as List),
      isAvailable: json['isAvailable'] as bool,
      address: json['address'] as String,
      contactNumber: json['contactNumber'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'district': district,
      'distanceKm': distanceKm,
      'etaMinutes': etaMinutes,
      'totalBeds': totalBeds,
      'icuBeds': icuBeds,
      'icuAvailable': icuAvailable,
      'oxygenBeds': oxygenBeds,
      'oxygenAvailable': oxygenAvailable,
      'ventilators': ventilators,
      'ventilatorsAvailable': ventilatorsAvailable,
      'specialties': specialties,
      'equipment': equipment,
      'isAvailable': isAvailable,
      'address': address,
      'contactNumber': contactNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
