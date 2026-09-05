import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/triage_result_model.dart';
import '../common/status_badge.dart';

class TriageResultCard extends StatelessWidget {
  final TriageResultModel result;
  final VoidCallback? onFindFacilities;

  const TriageResultCard({
    super.key,
    required this.result,
    this.onFindFacilities,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor;
    final Color bgColor;
    final IconData statusIcon;
    final BadgeVariant badgeVariant;

    switch (result.urgency) {
      case TriageUrgency.emergency:
        mainColor = AppColors.emergencyRed;
        bgColor = const Color(0xFFFEF2F2);
        statusIcon = Icons.e_mobiledata_rounded; // or emergency icon
        badgeVariant = BadgeVariant.emergency;
        break;
      case TriageUrgency.urgent:
        mainColor = AppColors.urgentOrange;
        bgColor = const Color(0xFFFFFBEB);
        statusIcon = Icons.warning_rounded;
        badgeVariant = BadgeVariant.urgent;
        break;
      case TriageUrgency.routine:
        mainColor = AppColors.availableGreen;
        bgColor = const Color(0xFFF0FDF4);
        statusIcon = Icons.check_circle_rounded;
        badgeVariant = BadgeVariant.available;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mainColor.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Urgency Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              border: Border(bottom: BorderSide(color: mainColor.withOpacity(0.2))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    result.isEmergency
                        ? Icons.notification_important_rounded
                        : result.isUrgent
                            ? Icons.warning_amber_rounded
                            : Icons.check_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRIAGE LEVEL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: mainColor,
                        ),
                      ),
                      Text(
                        result.urgency.labelEn,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: mainColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(
                  label: result.urgency.labelMr,
                  variant: badgeVariant,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient & Timestamp Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Patient: ${result.patientName}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      DateFormatter.formatTime(result.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Identified Risk Factors
                const Text(
                  'IDENTIFIED RISK FACTORS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.riskFactors.map(
                  (rf) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 7,
                          color: mainColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rf,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 12),

                // Recommended Immediate Referral
                const Text(
                  'RECOMMENDED IMMEDIATE REFERRAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.local_hospital_rounded, color: AppColors.primaryTeal, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          result.recommendedReferral,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepNavy,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Mandatory Statutory Disclaimer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Decision-support prototype: NOT an autonomous medical diagnosis system. Clinical officer discretion is primary.',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (onFindFacilities != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: onFindFacilities,
                    icon: const Icon(Icons.location_searching_rounded),
                    label: const Text('FIND BEST MATCHED FACILITIES'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
