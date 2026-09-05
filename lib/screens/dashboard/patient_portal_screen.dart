import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/referral_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';

class PatientPortalScreen extends ConsumerWidget {
  const PatientPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final referralsAsync = ref.watch(referralListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? 'Ramesh Balasaheb Patil',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const Text(
              'Patient & Citizen Care Portal • ABHA Linked',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          const LanguageToggleButton(isDarkTheme: true),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 108 Emergency Call Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emergencyRed,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergencyRed.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.emergencyRed, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIAL 108 FREE AMBULANCE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Maharashtra Emergency Medical Services (MEMS)',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Citizen ABHA Digital Health Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepNavy, AppColors.navySecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.health_and_safety_rounded, color: AppColors.maharashtraSaffron, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'ABHA HEALTH CARD',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'GOVT OF MAHARASHTRA',
                          style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    user?.name ?? 'Ramesh Balasaheb Patil',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ABHA Number: 91-4920-1849-2041',
                    style: TextStyle(color: Color(0xFF6EE7B7), fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Patient ID: MH-PUN-2026-0842 • Shikrapur, Pune',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Care Referral
            Text(
              'My Active Referral & Bed Status',
              style: AppStyles.heading2.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),

            referralsAsync.when(
              data: (referrals) {
                final active = referrals.isNotEmpty ? referrals.first : null;
                if (active == null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No active emergency referral found.'),
                    ),
                  );
                }

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.borderLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              active.id,
                              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            StatusBadge(label: active.status.labelEn, variant: BadgeVariant.inProgress),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Destination: ${active.destinationFacility}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Assigned Bed: ${active.reservedBedId ?? 'ICU Bed #4'} • ETA ${active.etaMinutes} min',
                          style: const TextStyle(fontSize: 12, color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/referral-tracking'),
                          icon: const Icon(Icons.alt_route_rounded, size: 18),
                          label: const Text('TRACK LIVE STATUS'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navySecondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/patient-history'),
                    icon: const Icon(Icons.history_rounded),
                    label: const Text('Medical History'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/facility-ranking'),
                    icon: const Icon(Icons.local_hospital_outlined),
                    label: const Text('Nearby Hospitals'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
