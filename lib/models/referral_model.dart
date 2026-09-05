import 'triage_result_model.dart';

enum ReferralStatus {
  submitted('SUBMITTED', 'सादर केले', 1),
  accepted('ACCEPTED', 'स्वीकृत', 2),
  bedReserved('BED RESERVED', 'खाट आरक्षित', 3),
  inTransit('IN TRANSIT', 'वाटेत आहे', 4),
  arrived('ARRIVED', 'पोहोचले', 5),
  completed('COMPLETED', 'पूर्ण झाले', 6);

  final String labelEn;
  final String labelMr;
  final int step;

  const ReferralStatus(this.labelEn, this.labelMr, this.step);

  ReferralStatus next() {
    switch (this) {
      case ReferralStatus.submitted:
        return ReferralStatus.accepted;
      case ReferralStatus.accepted:
        return ReferralStatus.bedReserved;
      case ReferralStatus.bedReserved:
        return ReferralStatus.inTransit;
      case ReferralStatus.inTransit:
        return ReferralStatus.arrived;
      case ReferralStatus.arrived:
        return ReferralStatus.completed;
      case ReferralStatus.completed:
        return ReferralStatus.completed;
    }
  }
}

class ReferralStatusEvent {
  final ReferralStatus status;
  final DateTime timestamp;
  final String note;

  const ReferralStatusEvent({
    required this.status,
    required this.timestamp,
    required this.note,
  });

  factory ReferralStatusEvent.fromJson(Map<String, dynamic> json) {
    return ReferralStatusEvent(
      status: ReferralStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ReferralStatus.submitted,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }
}

class ReferralModel {
  final String id;
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String originFacility;
  final String destinationFacility;
  final String? assignedAmbulance;
  final String? ambulanceDriver;
  final String? driverContact;
  final int etaMinutes;
  final ReferralStatus status;
  final TriageUrgency urgency;
  final String requiredSpecialty;
  final String? reservedBedId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ReferralStatusEvent> events;

  const ReferralModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.originFacility,
    required this.destinationFacility,
    this.assignedAmbulance,
    this.ambulanceDriver,
    this.driverContact,
    required this.etaMinutes,
    required this.status,
    required this.urgency,
    required this.requiredSpecialty,
    this.reservedBedId,
    required this.createdAt,
    required this.updatedAt,
    required this.events,
  });

  ReferralModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    int? patientAge,
    String? patientGender,
    String? originFacility,
    String? destinationFacility,
    String? assignedAmbulance,
    String? ambulanceDriver,
    String? driverContact,
    int? etaMinutes,
    ReferralStatus? status,
    TriageUrgency? urgency,
    String? requiredSpecialty,
    String? reservedBedId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ReferralStatusEvent>? events,
  }) {
    return ReferralModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      originFacility: originFacility ?? this.originFacility,
      destinationFacility: destinationFacility ?? this.destinationFacility,
      assignedAmbulance: assignedAmbulance ?? this.assignedAmbulance,
      ambulanceDriver: ambulanceDriver ?? this.ambulanceDriver,
      driverContact: driverContact ?? this.driverContact,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      requiredSpecialty: requiredSpecialty ?? this.requiredSpecialty,
      reservedBedId: reservedBedId ?? this.reservedBedId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      events: events ?? this.events,
    );
  }

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as int,
      patientGender: json['patientGender'] as String,
      originFacility: json['originFacility'] as String,
      destinationFacility: json['destinationFacility'] as String,
      assignedAmbulance: json['assignedAmbulance'] as String?,
      ambulanceDriver: json['ambulanceDriver'] as String?,
      driverContact: json['driverContact'] as String?,
      etaMinutes: json['etaMinutes'] as int,
      status: ReferralStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ReferralStatus.submitted,
      ),
      urgency: TriageUrgency.values.firstWhere(
        (u) => u.name == json['urgency'],
        orElse: () => TriageUrgency.emergency,
      ),
      requiredSpecialty: json['requiredSpecialty'] as String,
      reservedBedId: json['reservedBedId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => ReferralStatusEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'originFacility': originFacility,
      'destinationFacility': destinationFacility,
      'assignedAmbulance': assignedAmbulance,
      'ambulanceDriver': ambulanceDriver,
      'driverContact': driverContact,
      'etaMinutes': etaMinutes,
      'status': status.name,
      'urgency': urgency.name,
      'requiredSpecialty': requiredSpecialty,
      'reservedBedId': reservedBedId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
