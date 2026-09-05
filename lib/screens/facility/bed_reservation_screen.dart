import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/id_generator.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/facility_model.dart';
import '../../models/referral_model.dart';
import '../../models/triage_result_model.dart';
import '../../providers/facility_provider.dart';
import '../../providers/patient_provider.dart';
import '../../providers/referral_provider.dart';
import '../../providers/triage_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';

class BedReservationScreen extends ConsumerStatefulWidget {
  const BedReservationScreen({super.key});

  @override
  ConsumerState<BedReservationScreen> createState() => _BedReservationScreenState();
}

class _BedReservationScreenState extends ConsumerState<BedReservationScreen> {
  bool _isReserved = false;
  String _reservedBedId = '';
  String _selectedBedType = 'ICU Bed';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final selectedFacility = ref.watch(selectedFacilityProvider);
    final patient = ref.watch(selectedPatientProvider);
    final triageResult = ref.watch(latestTriageResultProvider);

    final facility = selectedFacility ??
        const FacilityModel(
          id: 'FAC-PUN-001',
          name: 'District Hospital Pune (Aundh)',
          type: 'District Hospital',
          district: 'Pune',
          distanceKm: 12.4,
          etaMinutes: 25,
          totalBeds: 350,
          icuBeds: 24,
          icuAvailable: 4,
          oxygenBeds: 80,
          oxygenAvailable: 12,
          ventilators: 16,
          ventilatorsAvailable: 3,
          specialties: ['Cardiology', 'Emergency Medicine'],
          equipment: ['CT Scan', 'Cath Lab', 'Blood Bank'],
          isAvailable: true,
          address: 'Aundh Camp, Pune 411027',
          contactNumber: '+91 20 2728 0432',
          latitude: 18.5793,
          longitude: 73.8055,
        );

    final patientName = patient?.fullName ?? triageResult?.patientName ?? 'Ramesh Balasaheb Patil';
    final urgency = triageResult?.urgency ?? TriageUrgency.emergency;
    final requiredSpecialty = triageResult?.isEmergency == true ? 'Cardiology / Intensive Cardiac Care' : 'General Medicine';
    final requiredEquipment = 'Multipara Monitor, Invasive Ventilator standby';
    final eta = '${facility.etaMinutes} min';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('bedReservationTitle', lang)),
        actions: const [
          LanguageToggleButton(isDarkTheme: true),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Hospital Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTealLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_hospital_rounded, color: AppColors.primaryTeal, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              facility.name,
                              style: AppStyles.heading3.copyWith(fontSize: 16),
                            ),
                            Text(
                              '${facility.address} • ${facility.contactNumber}',
                              style: AppStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Distance: ${facility.distanceKm.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('ETA: $eta', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.deepNavy, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Patient Admission Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INCOMING ADMISSION DETAILS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(AppStrings.get('patient', lang), patientName),
                  _buildDetailRow(
                    AppStrings.get('urgency', lang),
                    urgency.labelEn,
                    badge: StatusBadge(
                      label: urgency.labelEn,
                      variant: urgency == TriageUrgency.emergency
                          ? BadgeVariant.emergency
                          : BadgeVariant.urgent,
                      isSmall: true,
                    ),
                  ),
                  _buildDetailRow(AppStrings.get('requiredSpecialty', lang), requiredSpecialty),
                  _buildDetailRow(AppStrings.get('requiredEquipment', lang), requiredEquipment),
                  _buildDetailRow(AppStrings.get('estimatedArrival', lang), 'In $eta'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Real-Time Hospital Capacity Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('hospitalCapacity', lang),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCapacityBox(
                          label: 'ICU Available',
                          count: facility.icuAvailable,
                          color: AppColors.availableGreen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCapacityBox(
                          label: 'Oxygen Beds',
                          count: facility.oxygenAvailable,
                          color: AppColors.urgentOrange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCapacityBox(
                          label: 'Ventilators',
                          count: facility.ventilatorsAvailable,
                          color: AppColors.inProgressBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bed Type Selection
                  const Text(
                    'Select Bed Classification to Lock',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedBedType,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    items: ['ICU Bed', 'High-Flow Oxygen Bed', 'General Ward Bed'].map((b) {
                      return DropdownMenuItem(value: b, child: Text(b));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedBedType = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Confirmation / Status Card when Reserved
            if (_isReserved) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.availableGreenLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.availableGreen),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.availableGreen, size: 42),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.get('bedReservedConfirmation', lang),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Bed Allocation ID: $_reservedBedId',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF047857),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bed status: RESERVED (Multipara monitor activated)',
                      style: TextStyle(fontSize: 11, color: Color(0xFF065F46)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/referral-tracking');
                },
                icon: const Icon(Icons.airport_shuttle_rounded),
                label: Text(AppStrings.get('dispatchAndTrack', lang)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ] else ...[
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.emergencyRed,
                        side: const BorderSide(color: AppColors.emergencyRed),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(AppStrings.get('reject', lang)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handleReserve,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(AppStrings.get('acceptAndReserve', lang)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleReserve() async {
    setState(() => _isProcessing = true);

    final bedId = IdGenerator.generateReservationId(_selectedBedType);

    // Call repository via provider
    final selectedFacility = ref.read(selectedFacilityProvider);
    if (selectedFacility != null) {
      await ref.read(facilityListProvider.notifier).reserveBed(
            facilityId: selectedFacility.id,
            bedType: _selectedBedType,
          );
    }

    // Create active referral
    final patient = ref.read(selectedPatientProvider);
    final triage = ref.read(latestTriageResultProvider);

    final referral = ReferralModel(
      id: IdGenerator.generateReferralId(),
      patientId: patient?.id ?? 'MH-PUN-2026-0842',
      patientName: patient?.fullName ?? 'Ramesh Balasaheb Patil',
      patientAge: patient?.age ?? 58,
      patientGender: patient?.gender ?? 'Male',
      originFacility: 'Shirur Primary Health Centre',
      destinationFacility: selectedFacility?.name ?? 'District Hospital Pune (Aundh)',
      assignedAmbulance: 'MH-12-EM-1081 (ALS Unit)',
      ambulanceDriver: 'Sambhaji Shinde',
      driverContact: '+91 98234 56789',
      etaMinutes: selectedFacility?.etaMinutes ?? 25,
      status: ReferralStatus.bedReserved,
      urgency: triage?.urgency ?? TriageUrgency.emergency,
      requiredSpecialty: 'Cardiology / ICCU',
      reservedBedId: bedId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      events: [
        ReferralStatusEvent(
          status: ReferralStatus.submitted,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          note: 'Referral initiated by Medical Officer.',
        ),
        ReferralStatusEvent(
          status: ReferralStatus.accepted,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          note: 'Accepted by receiving facility triage team.',
        ),
        ReferralStatusEvent(
          status: ReferralStatus.bedReserved,
          timestamp: DateTime.now(),
          note: 'Bed $bedId successfully reserved and locked.',
        ),
      ],
    );

    await ref.read(referralListProvider.notifier).createReferral(referral);
    ref.read(activeReferralProvider.notifier).state = referral;

    setState(() {
      _isProcessing = false;
      _isReserved = true;
      _reservedBedId = bedId;
    });
  }

  Widget _buildDetailRow(String label, String value, {Widget? badge}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          if (badge != null)
            badge
          else
            Flexible(
              child: Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCapacityBox({
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
