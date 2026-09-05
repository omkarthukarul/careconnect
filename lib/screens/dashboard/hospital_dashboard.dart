import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/referral_model.dart';
import '../../models/triage_result_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/facility_provider.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/emergency_banner.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/facility/bed_status_card.dart';

class HospitalDashboard extends ConsumerStatefulWidget {
  const HospitalDashboard({super.key});

  @override
  ConsumerState<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends ConsumerState<HospitalDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    final facilitiesAsync = ref.watch(facilityListProvider);
    final referralsAsync = ref.watch(referralListProvider);

    final currentFacility = facilitiesAsync.maybeWhen(
      data: (list) => list.firstWhere(
        (f) => f.name.contains('District Hospital Pune'),
        orElse: () => list.first,
      ),
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentFacility?.name ?? 'District Hospital Pune (Aundh)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              '${user?.name ?? 'Sister Sunita More'} • Bed Registry Control',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          const LanguageToggleButton(isDarkTheme: true),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GovTech Capacity Notice
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.deepNavy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.hub_rounded, color: AppColors.maharashtraSaffron, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Maharashtra State Integrated Bed Allocation Hub • Level-2 Tertiary Network',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Emergency Banner for Incoming Cases
            const EmergencyBanner(count: 3),
            const SizedBox(height: 16),

            // Live Bed Matrix Section
            Text(
              AppStrings.get('hospitalDashboardTitle', lang),
              style: AppStyles.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),

            if (currentFacility != null) ...[
              BedStatusCard(
                title: 'ICU Beds',
                available: currentFacility.icuAvailable,
                total: currentFacility.icuBeds,
                icon: Icons.monitor_heart_rounded,
                accentColor: AppColors.emergencyRed,
                onIncrement: () {
                  ref.read(facilityListProvider.notifier).updateCapacity(
                        facilityId: currentFacility.id,
                        icuAvailable: currentFacility.icuAvailable + 1,
                      );
                },
                onDecrement: () {
                  if (currentFacility.icuAvailable > 0) {
                    ref.read(facilityListProvider.notifier).updateCapacity(
                          facilityId: currentFacility.id,
                          icuAvailable: currentFacility.icuAvailable - 1,
                        );
                  }
                },
              ),
              const SizedBox(height: 10),
              BedStatusCard(
                title: 'Oxygen Beds',
                available: currentFacility.oxygenAvailable,
                total: currentFacility.oxygenBeds,
                icon: Icons.air_rounded,
                accentColor: AppColors.urgentOrange,
                onIncrement: () {
                  ref.read(facilityListProvider.notifier).updateCapacity(
                        facilityId: currentFacility.id,
                        oxygenAvailable: currentFacility.oxygenAvailable + 1,
                      );
                },
                onDecrement: () {
                  if (currentFacility.oxygenAvailable > 0) {
                    ref.read(facilityListProvider.notifier).updateCapacity(
                          facilityId: currentFacility.id,
                          oxygenAvailable: currentFacility.oxygenAvailable - 1,
                        );
                  }
                },
              ),
              const SizedBox(height: 10),
              BedStatusCard(
                title: 'Ventilators',
                available: currentFacility.ventilatorsAvailable,
                total: currentFacility.ventilators,
                icon: Icons.device_thermostat_rounded,
                accentColor: AppColors.inProgressBlue,
                onIncrement: () {
                  ref.read(facilityListProvider.notifier).updateCapacity(
                        facilityId: currentFacility.id,
                        ventilatorsAvailable: currentFacility.ventilatorsAvailable + 1,
                      );
                },
                onDecrement: () {
                  if (currentFacility.ventilatorsAvailable > 0) {
                    ref.read(facilityListProvider.notifier).updateCapacity(
                          facilityId: currentFacility.id,
                          ventilatorsAvailable: currentFacility.ventilatorsAvailable - 1,
                        );
                  }
                },
              ),
            ],
            const SizedBox(height: 24),

            // Incoming Referrals Tabbed Section
            Text(
              AppStrings.get('incomingReferrals', lang),
              style: AppStyles.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryTeal,
                labelColor: AppColors.primaryTeal,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'Emergency (🔴)'),
                  Tab(text: 'Urgent (🟠)'),
                  Tab(text: 'Routine (🟢)'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            referralsAsync.when(
              data: (referrals) {
                return SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildReferralsList(
                        referrals.where((r) => r.urgency == TriageUrgency.emergency).toList(),
                        lang,
                      ),
                      _buildReferralsList(
                        referrals.where((r) => r.urgency == TriageUrgency.urgent).toList(),
                        lang,
                      ),
                      _buildReferralsList(
                        referrals.where((r) => r.urgency == TriageUrgency.routine).toList(),
                        lang,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralsList(List<ReferralModel> list, AppLanguage lang) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No referrals in this urgency category.'),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final refItem = list[idx];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      refItem.patientName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    StatusBadge(
                      label: refItem.status.labelEn,
                      variant: refItem.urgency == TriageUrgency.emergency
                          ? BadgeVariant.emergency
                          : BadgeVariant.urgent,
                      isSmall: true,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'From: ${refItem.originFacility} • ETA ${refItem.etaMinutes}m',
                  style: AppStyles.caption,
                ),
                Text(
                  'Specialty: ${refItem.requiredSpecialty}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Referral ${refItem.id} declined/rerouted.')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.emergencyRed,
                        side: const BorderSide(color: AppColors.emergencyRed),
                        minimumSize: const Size(0, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Reject', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await ref.read(referralListProvider.notifier).advanceStatus(
                              referralId: refItem.id,
                              nextStatus: ReferralStatus.bedReserved,
                              note: 'Bed reserved by District Hospital Triage Officer Sister Sunita More.',
                            );
                        ref.read(activeReferralProvider.notifier).state = refItem;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bed locked for ${refItem.patientName} (${refItem.id})'),
                            backgroundColor: AppColors.availableGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: const Text('Accept & Reserve Bed', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
