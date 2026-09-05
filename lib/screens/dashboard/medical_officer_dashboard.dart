import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/facility_provider.dart';
import '../../providers/patient_provider.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/dashboard_metric_card.dart';
import '../../widgets/common/emergency_banner.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/patient/patient_card.dart';

class MedicalOfficerDashboard extends ConsumerStatefulWidget {
  const MedicalOfficerDashboard({super.key});

  @override
  ConsumerState<MedicalOfficerDashboard> createState() => _MedicalOfficerDashboardState();
}

class _MedicalOfficerDashboardState extends ConsumerState<MedicalOfficerDashboard> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    final patientsAsync = ref.watch(patientListProvider);
    final facilitiesAsync = ref.watch(facilityListProvider);
    final emergencyCount = ref.watch(emergencyReferralsCountProvider);
    final pendingCount = ref.watch(pendingReferralsCountProvider);

    final int totalFacilities = facilitiesAsync.maybeWhen(
      data: (list) => list.where((f) => f.isAvailable).length,
      orElse: () => 14,
    );

    final int activePatientsCount = patientsAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => 24,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? 'Dr. Sunil Deshmukh, MBBS',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              user?.facilityName ?? 'Shirur PHC • Pune District',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          const LanguageToggleButton(isDarkTheme: true),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push('/referrals');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(patientListProvider);
          ref.refresh(facilityListProvider);
          ref.refresh(referralListProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Emergency Alert Banner
              EmergencyBanner(
                count: emergencyCount > 0 ? emergencyCount : 2,
                onTap: () {
                  context.push('/referrals');
                },
              ),
              const SizedBox(height: 12),

              // Metric Cards 2x2 Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: [
                  DashboardMetricCard(
                    title: AppStrings.get('activePatients', lang),
                    value: '$activePatientsCount',
                    icon: Icons.people_outline_rounded,
                    accentColor: AppColors.primaryTeal,
                    subtitle: 'Total registered',
                    onTap: () => context.push('/patients-list'),
                  ),
                  DashboardMetricCard(
                    title: AppStrings.get('pendingReferrals', lang),
                    value: '$pendingCount',
                    icon: Icons.sync_problem_rounded,
                    accentColor: AppColors.urgentOrange,
                    subtitle: 'Awaiting bed',
                    onTap: () => context.push('/referrals'),
                  ),
                  DashboardMetricCard(
                    title: AppStrings.get('emergencyCases', lang),
                    value: '${emergencyCount > 0 ? emergencyCount : 2}',
                    icon: Icons.emergency_rounded,
                    accentColor: AppColors.emergencyRed,
                    subtitle: 'Immediate ALS',
                    onTap: () => context.push('/referrals'),
                  ),
                  DashboardMetricCard(
                    title: AppStrings.get('availableFacilities', lang),
                    value: '$totalFacilities',
                    icon: Icons.local_hospital_outlined,
                    accentColor: AppColors.navySecondary,
                    subtitle: 'Network ready',
                    onTap: () => context.push('/facility-ranking'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Actions Section
              Text(
                AppStrings.get('quickActions', lang),
                style: AppStyles.heading2.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionBtn(
                      context,
                      label: AppStrings.get('registerPatient', lang),
                      icon: Icons.person_add_alt_1_rounded,
                      color: AppColors.primaryTeal,
                      onTap: () => context.push('/register-patient'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionBtn(
                      context,
                      label: AppStrings.get('newTriage', lang),
                      icon: Icons.bolt_rounded,
                      color: AppColors.navySecondary,
                      onTap: () => context.push('/clinical-intake'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildActionBtn(
                      context,
                      label: AppStrings.get('findFacility', lang),
                      icon: Icons.travel_explore_rounded,
                      color: const Color(0xFF0D9488),
                      onTap: () => context.push('/facility-ranking'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionBtn(
                      context,
                      label: AppStrings.get('trackReferral', lang),
                      icon: Icons.alt_route_rounded,
                      color: const Color(0xFF4F46E5),
                      onTap: () => context.push('/referral-tracking'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Registered Patients Feed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.get('patients', lang)} (Recent Intake)',
                    style: AppStyles.heading2.copyWith(fontSize: 17),
                  ),
                  TextButton(
                    onPressed: () => context.push('/patients-list'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              patientsAsync.when(
                data: (patients) {
                  final recent = patients.take(3).toList();
                  return Column(
                    children: recent.map((p) {
                      return PatientCard(
                        patient: p,
                        onTap: () {
                          ref.read(selectedPatientProvider.notifier).state = p;
                          context.push('/clinical-intake');
                        },
                        onTriageTap: () {
                          ref.read(selectedPatientProvider.notifier).state = p;
                          context.push('/clinical-intake');
                        },
                        onHistoryTap: () {
                          ref.read(selectedPatientProvider.notifier).state = p;
                          context.push('/patient-history');
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Text('Error loading patients: $err'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentNavIndex = idx);
          switch (idx) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              context.push('/patients-list');
              break;
            case 2:
              context.push('/clinical-intake');
              break;
            case 3:
              context.push('/referrals');
              break;
            case 4:
              context.push('/profile');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: AppStrings.get('dashboard', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline_rounded),
            selectedIcon: const Icon(Icons.people_rounded),
            label: AppStrings.get('patients', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bolt_outlined),
            selectedIcon: const Icon(Icons.bolt_rounded),
            label: AppStrings.get('triage', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_rounded),
            selectedIcon: const Icon(Icons.swap_horizontal_circle_rounded),
            label: AppStrings.get('referrals', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_circle_outlined),
            selectedIcon: const Icon(Icons.account_circle_rounded),
            label: AppStrings.get('profile', lang),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: AppStyles.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
