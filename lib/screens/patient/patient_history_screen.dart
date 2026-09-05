import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/patient_model.dart';
import '../../models/referral_model.dart';
import '../../providers/patient_provider.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';

class PatientHistoryScreen extends ConsumerStatefulWidget {
  const PatientHistoryScreen({super.key});

  @override
  ConsumerState<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends ConsumerState<PatientHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final selectedPatient = ref.watch(selectedPatientProvider);
    final referralsAsync = ref.watch(referralListProvider);

    final patient = selectedPatient ??
        PatientModel(
          id: 'MH-PUN-2026-0842',
          fullName: 'Ramesh Balasaheb Patil',
          age: 58,
          gender: 'Male',
          mobile: '9822019485',
          village: 'Shikrapur',
          district: 'Pune',
          emergencyContact: '9822019486 (Sunita Patil - Wife)',
          abhaId: '91-4920-1849-2041',
          registrationDate: DateTime.now().subtract(const Duration(days: 14)),
          chiefComplaint: 'Acute chest pain with radiating left arm tingling',
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('patientHistoryTitle', lang)),
        actions: const [
          LanguageToggleButton(isDarkTheme: true),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Summary
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
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primaryTealLight,
                        child: Text(
                          patient.fullName.isNotEmpty ? patient.fullName[0].toUpperCase() : 'P',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.fullName,
                              style: AppStyles.heading3.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${patient.age} yrs • ${patient.gender} • ${patient.village}, ${patient.district}',
                              style: AppStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Patient ID: ${patient.id}', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 12)),
                      if (patient.abhaId != null)
                        Text('ABHA: ${patient.abhaId}', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Triage Assessments Section
            Text(
              AppStrings.get('triageAssessments', lang),
              style: AppStyles.heading2.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),

            _buildAssessmentCard(
              date: DateTime.now().subtract(const Duration(hours: 1)),
              urgency: 'EMERGENCY',
              vitalsSummary: 'SpO₂: 88% | HR: 126 bpm | BP: 175/105 | Consciousness: Alert',
              notes: 'Severe chest tightness with ST elevations noted on field 12-lead ECG. Transferred to ICCU.',
              variant: BadgeVariant.emergency,
            ),
            const SizedBox(height: 10),
            _buildAssessmentCard(
              date: DateTime.now().subtract(const Duration(days: 14)),
              urgency: 'ROUTINE',
              vitalsSummary: 'SpO₂: 98% | HR: 74 bpm | BP: 128/82 | Temp: 98.4°F',
              notes: 'Routine hypertension follow-up at Shirur PHC. Tab Amlodipine 5mg renewed.',
              variant: BadgeVariant.available,
            ),
            const SizedBox(height: 24),

            // Inter-Facility Referrals & Transfers Section
            Text(
              AppStrings.get('hospitalTransfers', lang),
              style: AppStyles.heading2.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),

            referralsAsync.when(
              data: (referrals) {
                final patientRefs = referrals.where((r) => r.patientId == patient.id).toList();
                final list = patientRefs.isNotEmpty ? patientRefs : referrals.take(2).toList();

                return Column(
                  children: list.map((refItem) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                refItem.id,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.navySecondary,
                                ),
                              ),
                              StatusBadge(
                                label: refItem.status.labelEn,
                                variant: refItem.status == ReferralStatus.completed
                                    ? BadgeVariant.completed
                                    : BadgeVariant.inProgress,
                                isSmall: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.trip_origin_rounded, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Origin: ${refItem.originFacility}', style: const TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 14, color: AppColors.availableGreen),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Destination: ${refItem.destinationFacility}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Specialty: ${refItem.requiredSpecialty} • Bed: ${refItem.reservedBedId ?? 'Allocated'}',
                            style: const TextStyle(fontSize: 12, color: AppColors.deepNavy, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Initiated: ${DateFormatter.formatDateTime(refItem.createdAt)}',
                            style: AppStyles.caption,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error loading transfers: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard({
    required DateTime date,
    required String urgency,
    required String vitalsSummary,
    required String notes,
    required BadgeVariant variant,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormatter.formatDateTime(date),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
              ),
              StatusBadge(label: urgency, variant: variant, isSmall: true),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vitalsSummary,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            notes,
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
          ),
        ],
      ),
    );
  }
}
