import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/referral_model.dart';

class ReferralTimeline extends StatelessWidget {
  final ReferralModel referral;
  final Function(ReferralStatus nextStatus)? onAdvanceStatus;

  const ReferralTimeline({
    super.key,
    required this.referral,
    this.onAdvanceStatus,
  });

  @override
  Widget build(BuildContext context) {
    const steps = ReferralStatus.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            final isCompleted = referral.status.step > step.step;
            final isCurrent = referral.status.step == step.step;
            final isUpcoming = referral.status.step < step.step;

            // Find matching event from history if recorded
            final event = referral.events.where((e) => e.status == step).toList().lastOrNull;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Node & Line
                  SizedBox(
                    width: 40,
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.availableGreen
                                : isCurrent
                                    ? AppColors.inProgressBlue
                                    : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.availableGreen
                                  : isCurrent
                                      ? AppColors.inProgressBlue
                                      : AppColors.borderLight,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isCompleted
                                ? Icons.check
                                : _getIconForStatus(step),
                            size: 14,
                            color: isCompleted || isCurrent
                                ? Colors.white
                                : AppColors.textMuted,
                          ),
                        ),
                        if (index < steps.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isCompleted
                                  ? AppColors.availableGreen
                                  : AppColors.borderLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Event Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                step.labelEn,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                  color: isCurrent
                                      ? AppColors.inProgressBlue
                                      : isCompleted
                                          ? AppColors.textPrimary
                                          : AppColors.textMuted,
                                ),
                              ),
                              if (event != null)
                                Text(
                                  DateFormatter.formatTime(event.timestamp),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                            ],
                          ),
                          if (event != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              event.note,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ] else if (isUpcoming) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Pending previous stages completion',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textMuted.withOpacity(0.8),
                              ),
                            ),
                          ],

                          // Fast simulate button for demonstration
                          if (isCurrent && referral.status != ReferralStatus.completed && onAdvanceStatus != null) ...[
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () => onAdvanceStatus!(referral.status.next()),
                              icon: const Icon(Icons.fast_forward_rounded, size: 14),
                              label: Text('Advance to ${referral.status.next().labelEn}'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.inProgressBlue,
                                side: const BorderSide(color: AppColors.inProgressBlue),
                                minimumSize: const Size(0, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconForStatus(ReferralStatus status) {
    switch (status) {
      case ReferralStatus.submitted:
        return Icons.send_rounded;
      case ReferralStatus.accepted:
        return Icons.verified_rounded;
      case ReferralStatus.bedReserved:
        return Icons.hotel_rounded;
      case ReferralStatus.inTransit:
        return Icons.airport_shuttle_rounded;
      case ReferralStatus.arrived:
        return Icons.location_on_rounded;
      case ReferralStatus.completed:
        return Icons.task_alt_rounded;
    }
  }
}
