import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BedStatusCard extends StatelessWidget {
  final String title;
  final int available;
  final int total;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const BedStatusCard({
    super.key,
    required this.title,
    required this.available,
    required this.total,
    required this.icon,
    required this.accentColor,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = total > 0 ? (available / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: available > 0 ? AppColors.availableGreenLight : AppColors.emergencyRedLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  available > 0 ? '$available FREE' : 'FULL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: available > 0 ? AppColors.availableGreen : AppColors.emergencyRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$available / $total',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(percentage * 100).toInt()}% Capacity Free',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: available > 0 ? AppColors.availableGreen : AppColors.emergencyRed,
                    ),
                  ),
                ],
              ),
              if (onIncrement != null && onDecrement != null)
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove_circle_outline),
                      iconSize: 24,
                      color: AppColors.textSecondary,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 24,
                      color: AppColors.primaryTeal,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                available > (total * 0.3)
                    ? AppColors.availableGreen
                    : available > 0
                        ? AppColors.urgentOrange
                        : AppColors.emergencyRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
