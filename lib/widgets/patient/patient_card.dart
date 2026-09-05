import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../models/patient_model.dart';

class PatientCard extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback? onTap;
  final VoidCallback? onTriageTap;
  final VoidCallback? onHistoryTap;

  const PatientCard({
    super.key,
    required this.patient,
    this.onTap,
    this.onTriageTap,
    this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryTealLight,
                    child: Text(
                      patient.fullName.isNotEmpty ? patient.fullName[0].toUpperCase() : 'P',
                      style: const TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.fullName,
                          style: AppStyles.heading3.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${patient.age} yrs • ${patient.gender} • ${patient.village}, ${patient.district}',
                          style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      patient.id,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: AppColors.navySecondary,
                      ),
                    ),
                  ),
                ],
              ),
              if (patient.chiefComplaint != null && patient.chiefComplaint!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.medical_services_outlined, size: 14, color: Color(0xFFB45309)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          patient.chiefComplaint!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (patient.abhaId != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 13, color: AppColors.primaryTeal),
                    const SizedBox(width: 4),
                    Text(
                      'ABHA: ${patient.abhaId}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onHistoryTap != null)
                    TextButton.icon(
                      onPressed: onHistoryTap,
                      icon: const Icon(Icons.history, size: 16),
                      label: const Text('History'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (onTriageTap != null)
                    ElevatedButton.icon(
                      onPressed: onTriageTap,
                      icon: const Icon(Icons.bolt_rounded, size: 16),
                      label: const Text('New Triage'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
