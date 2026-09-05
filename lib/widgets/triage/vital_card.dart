import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class VitalCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final bool isAbnormal;
  final bool isCritical;
  final VoidCallback? onTap;

  const VitalCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.isAbnormal = false,
    this.isCritical = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color bgColor;
    final Color iconColor;
    final Color textColor;

    if (isCritical) {
      borderColor = AppColors.emergencyRed;
      bgColor = AppColors.emergencyRedLight;
      iconColor = AppColors.emergencyRed;
      textColor = AppColors.emergencyRed;
    } else if (isAbnormal) {
      borderColor = AppColors.urgentOrange;
      bgColor = AppColors.urgentOrangeLight;
      iconColor = AppColors.urgentOrange;
      textColor = const Color(0xFFB45309);
    } else {
      borderColor = AppColors.borderLight;
      bgColor = Colors.white;
      iconColor = AppColors.primaryTeal;
      textColor = AppColors.textPrimary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isCritical || isAbnormal ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isCritical || isAbnormal ? textColor : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isCritical || isAbnormal ? textColor.withOpacity(0.8) : AppColors.textMuted,
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
