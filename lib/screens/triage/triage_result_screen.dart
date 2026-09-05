import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/triage_result_model.dart';
import '../../models/vitals_model.dart';
import '../../providers/triage_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/triage/triage_result_card.dart';
import '../../widgets/triage/vital_card.dart';

class TriageResultScreen extends ConsumerWidget {
  const TriageResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final triageResult = ref.watch(latestTriageResultProvider);

    // Fallback if accessed directly
    final effectiveResult = triageResult ??
        TriageResultModel(
          id: 'TR-DEMO-001',
          patientId: 'MH-PUN-2026-0842',
          patientName: 'Ramesh Balasaheb Patil',
          urgency: TriageUrgency.emergency,
          riskFactors: [
            'Critical Hypoxia: SpO₂ is 88.0% (< 90%)',
            'Severe Tachycardia: Heart Rate is 126 bpm',
            'Suspected Acute Coronary Syndrome (ACS) with hemodynamic anomaly',
          ],
          recommendedReferral:
              'Immediate referral to Tertiary Hospital with 24/7 Cath Lab & Intensive Cardiac Care Unit (ICCU). Dispatch 108 ALS Ambulance.',
          timestamp: DateTime.now(),
          vitals: const VitalsModel(
            heartRate: 126,
            systolicBP: 175,
            diastolicBP: 105,
            spo2: 88.0,
            temperature: 98.4,
            respiratoryRate: 26,
            consciousness: ConsciousnessLevel.alert,
          ),
          symptoms: ['Chest Pain', 'Breathlessness'],
        );

    final vitals = effectiveResult.vitals;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('triageResultTitle', lang)),
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
            // Hero Visual Result Card
            TriageResultCard(
              result: effectiveResult,
              onFindFacilities: () {
                context.push('/facility-ranking');
              },
            ),
            const SizedBox(height: 24),

            // Evaluated Vitals Parameter Grid
            const Text(
              'EVALUATED VITALS & TELEMETRY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.1,
              children: [
                VitalCard(
                  label: AppStrings.get('spo2', lang),
                  value: '${vitals.spo2.toStringAsFixed(1)}',
                  unit: '%',
                  icon: Icons.water_drop_rounded,
                  isCritical: vitals.spo2 < 90,
                  isAbnormal: vitals.spo2 < 95,
                ),
                VitalCard(
                  label: AppStrings.get('heartRate', lang),
                  value: '${vitals.heartRate}',
                  unit: 'BPM',
                  icon: Icons.favorite_rounded,
                  isCritical: vitals.heartRate > 120 || vitals.heartRate < 45,
                  isAbnormal: vitals.heartRate > 100,
                ),
                VitalCard(
                  label: 'Blood Pressure',
                  value: '${vitals.systolicBP}/${vitals.diastolicBP}',
                  unit: 'mmHg',
                  icon: Icons.speed_rounded,
                  isCritical: vitals.systolicBP < 90 || vitals.systolicBP >= 180,
                  isAbnormal: vitals.systolicBP >= 140,
                ),
                VitalCard(
                  label: AppStrings.get('temperature', lang),
                  value: '${vitals.temperature.toStringAsFixed(1)}',
                  unit: '°F',
                  icon: Icons.thermostat_rounded,
                  isAbnormal: vitals.temperature >= 101,
                ),
                VitalCard(
                  label: 'Respiratory Rate',
                  value: '${vitals.respiratoryRate}',
                  unit: '/min',
                  icon: Icons.air_rounded,
                  isCritical: vitals.respiratoryRate > 28,
                  isAbnormal: vitals.respiratoryRate > 22,
                ),
                VitalCard(
                  label: 'Consciousness (AVPU)',
                  value: vitals.consciousness.name.toUpperCase()[0],
                  unit: 'Scale',
                  icon: Icons.psychology_rounded,
                  isCritical: vitals.consciousness != ConsciousnessLevel.alert,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Symptoms Presented
            const Text(
              'PRESENTING SYMPTOMS EVALUATED',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: effectiveResult.symptoms.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Direct Facility Search Button
            ElevatedButton.icon(
              onPressed: () {
                context.push('/facility-ranking');
              },
              icon: const Icon(Icons.travel_explore_rounded, size: 20),
              label: Text(AppStrings.get('btnFindFacility', lang)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('EDIT CLINICAL INTAKE'),
            ),
          ],
        ),
      ),
    );
  }
}
