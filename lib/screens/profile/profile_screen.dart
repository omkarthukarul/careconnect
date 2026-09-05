import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('profile', lang)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryTealLight,
                    child: const Icon(Icons.person, size: 40, color: AppColors.primaryTeal),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Dr. Sunil Deshmukh, MBBS',
                    style: AppStyles.heading2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user != null
                        ? (lang.code == 'mr' ? user.role.labelMr : user.role.labelEn)
                        : 'Medical Officer',
                    style: const TextStyle(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.facilityName ?? 'Shirur Primary Health Centre',
                    style: AppStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings & Preferences
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
                    'LANGUAGE PREFERENCE / भाषा निवडा',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('English')),
                          selected: lang == AppLanguage.english,
                          selectedColor: AppColors.primaryTeal,
                          labelStyle: TextStyle(
                            color: lang == AppLanguage.english ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) ref.read(languageProvider.notifier).setLanguage(AppLanguage.english);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('मराठी (Marathi)')),
                          selected: lang == AppLanguage.marathi,
                          selectedColor: AppColors.primaryTeal,
                          labelStyle: TextStyle(
                            color: lang == AppLanguage.marathi ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) ref.read(languageProvider.notifier).setLanguage(AppLanguage.marathi);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Switch Active Role Demo Box
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
                    'HACKATHON ROLE SWITCHER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Instantly switch context to evaluate the workflow from another stakeholder perspective:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: UserRole.values.map((role) {
                      return ActionChip(
                        avatar: const Icon(Icons.swap_horiz, size: 14),
                        label: Text(role.labelEn),
                        onPressed: () async {
                          await ref.read(authNotifierProvider.notifier).demoLogin(role);
                          if (context.mounted) {
                            switch (role) {
                              case UserRole.medicalOfficer:
                                context.go('/mo-dashboard');
                                break;
                              case UserRole.hospitalStaff:
                                context.go('/hospital-dashboard');
                                break;
                              case UserRole.ambulanceEMS:
                                context.go('/ambulance');
                                break;
                              case UserRole.patient:
                                context.go('/patient-portal');
                                break;
                            }
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SIH App Info
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
                    'PROJECT SPECIFICATIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _specRow('Application', 'CareConnect Maharashtra (संजीवन महा-नेट)'),
                  _specRow('Architecture', 'Clean Architecture + Riverpod + GoRouter'),
                  _specRow('Backend Ready', 'Dio REST Layer (Separated for Node.js API)'),
                  _specRow('Mapping', 'OpenStreetMap / Flutter Map'),
                  _specRow('Version', '1.0.0 Production Build'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(AppStrings.get('logout', lang)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emergencyRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
