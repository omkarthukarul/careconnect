import 'package:flutter_test/flutter_test.dart';
import 'package:careconnect_maharashtra/models/referral_model.dart';
import 'package:careconnect_maharashtra/models/triage_result_model.dart';
import 'package:careconnect_maharashtra/repositories/referral_repository.dart';

void main() {
  group('Referral Lifecycle Progression Tests', () {
    test('Sequential 6-stage transition from SUBMITTED to COMPLETED', () async {
      final repo = MockReferralRepository();

      final initialReferral = ReferralModel(
        id: 'REF-TEST-001',
        patientId: 'MH-PUN-2026-0001',
        patientName: 'Kisan Baburao Hazare',
        patientAge: 60,
        patientGender: 'Male',
        originFacility: 'Ralegan Siddhi Sub-Center',
        destinationFacility: 'District Hospital Ahmednagar',
        etaMinutes: 30,
        status: ReferralStatus.submitted,
        urgency: TriageUrgency.emergency,
        requiredSpecialty: 'Cardiology',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        events: [
          ReferralStatusEvent(
            status: ReferralStatus.submitted,
            timestamp: DateTime.now(),
            note: 'Referral created by MO.',
          ),
        ],
      );

      await repo.createReferral(initialReferral);

      // 1. Advance to ACCEPTED
      var updated = await repo.advanceStatus(
        referralId: 'REF-TEST-001',
        nextStatus: ReferralStatus.accepted,
        note: 'Referral accepted by receiving ER.',
      );
      expect(updated.status, equals(ReferralStatus.accepted));
      expect(updated.events.length, equals(2));

      // 2. Advance to BED RESERVED
      updated = await repo.advanceStatus(
        referralId: 'REF-TEST-001',
        nextStatus: ReferralStatus.bedReserved,
        note: 'ICU Bed #4 allocated.',
      );
      expect(updated.status, equals(ReferralStatus.bedReserved));
      expect(updated.events.length, equals(3));

      // 3. Advance to IN TRANSIT
      updated = await repo.advanceStatus(
        referralId: 'REF-TEST-001',
        nextStatus: ReferralStatus.inTransit,
        note: '108 Ambulance dispatched.',
      );
      expect(updated.status, equals(ReferralStatus.inTransit));
      expect(updated.events.length, equals(4));

      // 4. Advance to ARRIVED
      updated = await repo.advanceStatus(
        referralId: 'REF-TEST-001',
        nextStatus: ReferralStatus.arrived,
        note: 'Ambulance arrived at facility bay.',
      );
      expect(updated.status, equals(ReferralStatus.arrived));
      expect(updated.events.length, equals(5));

      // 5. Advance to COMPLETED
      updated = await repo.advanceStatus(
        referralId: 'REF-TEST-001',
        nextStatus: ReferralStatus.completed,
        note: 'Patient handed over to cardiology registrar.',
      );
      expect(updated.status, equals(ReferralStatus.completed));
      expect(updated.events.length, equals(6));
    });
  });
}
