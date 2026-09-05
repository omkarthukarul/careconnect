import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/referral_model.dart';
import '../../models/triage_result_model.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/referral/referral_timeline.dart';

class ReferralTrackingScreen extends ConsumerWidget {
  const ReferralTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final activeReferral = ref.watch(activeReferralProvider);

    // Fallback if accessed standalone
    final referral = activeReferral ??
        ReferralModel(
          id: 'REF-MH-2026-90142',
          patientId: 'MH-PUN-2026-0842',
          patientName: 'Ramesh Balasaheb Patil',
          patientAge: 58,
          patientGender: 'Male',
          originFacility: 'Shirur Primary Health Centre',
          destinationFacility: 'District Hospital Pune (Aundh)',
          assignedAmbulance: 'MH-12-EM-1081 (ALS Unit)',
          ambulanceDriver: 'Sambhaji Shinde',
          driverContact: '+91 98234 56789',
          etaMinutes: 18,
          status: ReferralStatus.inTransit,
          urgency: TriageUrgency.emergency,
          requiredSpecialty: 'Cardiology / ICCU',
          reservedBedId: 'ICU-B04',
          createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 8)),
          events: [
            ReferralStatusEvent(
              status: ReferralStatus.submitted,
              timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
              note: 'Urgent referral initiated for Acute Coronary Syndrome.',
            ),
            ReferralStatusEvent(
              status: ReferralStatus.accepted,
              timestamp: DateTime.now().subtract(const Duration(minutes: 36)),
              note: 'Accepted by ER in-charge.',
            ),
            ReferralStatusEvent(
              status: ReferralStatus.bedReserved,
              timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
              note: 'ICU Bed #ICU-B04 reserved.',
            ),
            ReferralStatusEvent(
              status: ReferralStatus.inTransit,
              timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
              note: 'Ambulance en route to District Hospital with continuous SpO2 monitoring.',
            ),
          ],
        );

    final BadgeVariant badgeVariant;
    switch (referral.status) {
      case ReferralStatus.submitted:
      case ReferralStatus.accepted:
        badgeVariant = BadgeVariant.urgent;
        break;
      case ReferralStatus.bedReserved:
      case ReferralStatus.inTransit:
        badgeVariant = BadgeVariant.inProgress;
        break;
      case ReferralStatus.arrived:
      case ReferralStatus.completed:
        badgeVariant = BadgeVariant.completed;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('referralTrackingTitle', lang)),
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
            // Referral Overview Card
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('referralId', lang),
                            style: AppStyles.caption,
                          ),
                          Text(
                            referral.id,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.navySecondary,
                            ),
                          ),
                        ],
                      ),
                      StatusBadge(
                        label: referral.status.labelEn,
                        variant: badgeVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 10),

                  // Patient & Urgency
                  _infoRow(
                    label: AppStrings.get('patient', lang),
                    value: '${referral.patientName} (${referral.patientAge}y, ${referral.patientGender})',
                  ),
                  _infoRow(
                    label: AppStrings.get('origin', lang),
                    value: referral.originFacility,
                    icon: Icons.my_location_rounded,
                  ),
                  _infoRow(
                    label: AppStrings.get('destination', lang),
                    value: referral.destinationFacility,
                    icon: Icons.local_hospital_rounded,
                  ),
                  if (referral.assignedAmbulance != null)
                    _infoRow(
                      label: AppStrings.get('ambulance', lang),
                      value: '${referral.assignedAmbulance} (${referral.ambulanceDriver})',
                      icon: Icons.airport_shuttle_rounded,
                    ),
                  _infoRow(
                    label: AppStrings.get('eta', lang),
                    value: '${referral.etaMinutes} minutes',
                    icon: Icons.timer_outlined,
                  ),
                  if (referral.reservedBedId != null)
                    _infoRow(
                      label: 'Reserved Bed',
                      value: referral.reservedBedId!,
                      icon: Icons.hotel_rounded,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Ambulance Tracking Map CTA
            InkWell(
              onTap: () => context.push('/ambulance'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.navySecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.map_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LIVE GPS AMBULANCE MAP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Track real-time telemetry, location and arrival route',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Referral Timeline
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
                    'STAGE-BY-STAGE CARE LIFECYCLE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ReferralTimeline(
                    referral: referral,
                    onAdvanceStatus: (nextStatus) async {
                      final updated = await ref.read(referralListProvider.notifier).advanceStatus(
                            referralId: referral.id,
                            nextStatus: nextStatus,
                            note: 'Stage updated to ${nextStatus.labelEn} by officer.',
                          );
                      ref.read(activeReferralProvider.notifier).state = updated;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: AppColors.primaryTeal),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
