import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum BadgeVariant {
  emergency,
  urgent,
  available,
  inProgress,
  completed,
  neutral,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.label,
    required this.variant,
    this.icon,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;
    final Color borderColor;

    switch (variant) {
      case BadgeVariant.emergency:
        bgColor = AppColors.emergencyRedLight;
        textColor = AppColors.emergencyRed;
        borderColor = AppColors.emergencyRed.withOpacity(0.3);
        break;
      case BadgeVariant.urgent:
        bgColor = AppColors.urgentOrangeLight;
        textColor = AppColors.urgentOrange;
        borderColor = AppColors.urgentOrange.withOpacity(0.3);
        break;
      case BadgeVariant.available:
        bgColor = AppColors.availableGreenLight;
        textColor = AppColors.availableGreen;
        borderColor = AppColors.availableGreen.withOpacity(0.3);
        break;
      case BadgeVariant.inProgress:
        bgColor = AppColors.inProgressBlueLight;
        textColor = AppColors.inProgressBlue;
        borderColor = AppColors.inProgressBlue.withOpacity(0.3);
        break;
      case BadgeVariant.completed:
        bgColor = AppColors.completedGreyLight;
        textColor = AppColors.completedGrey;
        borderColor = AppColors.completedGrey.withOpacity(0.3);
        break;
      case BadgeVariant.neutral:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
        borderColor = const Color(0xFFCBD5E1);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 12 : 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
