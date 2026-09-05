import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../models/facility_model.dart';
import '../common/status_badge.dart';

class FacilityCard extends StatelessWidget {
  final FacilityModel facility;
  final VoidCallback? onRequestBed;
  final VoidCallback? onTap;

  const FacilityCard({
    super.key,
    required this.facility,
    this.onRequestBed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: facility.isAvailable ? AppColors.borderLight : const Color(0xFFE5E7EB),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Name & Availability
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.name,
                          style: AppStyles.heading3.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          facility.type,
                          style: AppStyles.caption.copyWith(color: AppColors.primaryTeal),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: facility.isAvailable ? 'AVAILABLE' : 'FULL / LIMITED',
                    variant: facility.isAvailable ? BadgeVariant.available : BadgeVariant.neutral,
                    isSmall: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Distance & ETA Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.near_me_outlined, size: 16, color: AppColors.primaryTeal),
                        const SizedBox(width: 6),
                        Text(
                          '${facility.distanceKm.toStringAsFixed(1)} km',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                    Container(height: 16, width: 1, color: AppColors.borderLight),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 16, color: AppColors.deepNavy),
                        const SizedBox(width: 6),
                        Text(
                          'ETA ${facility.etaMinutes} min',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Capacity Matrix (ICU, Oxygen, Ventilator)
              Row(
                children: [
                  Expanded(
                    child: _buildBedStat(
                      label: 'ICU Beds',
                      count: facility.icuAvailable,
                      total: facility.icuBeds,
                      color: facility.icuAvailable > 0 ? AppColors.availableGreen : AppColors.emergencyRed,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBedStat(
                      label: 'Oxygen Beds',
                      count: facility.oxygenAvailable,
                      total: facility.oxygenBeds,
                      color: facility.oxygenAvailable > 0 ? AppColors.availableGreen : AppColors.urgentOrange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBedStat(
                      label: 'Ventilators',
                      count: facility.ventilatorsAvailable,
                      total: facility.ventilators,
                      color: facility.ventilatorsAvailable > 0 ? AppColors.availableGreen : AppColors.completedGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Specialties & Equipment
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ...facility.specialties.take(3).map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTealLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ),
                  ...facility.equipment.take(2).map(
                    (eq) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        eq,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),

              // Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    facility.address,
                    style: AppStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ElevatedButton.icon(
                    onPressed: facility.isAvailable ? onRequestBed : null,
                    icon: const Icon(Icons.hotel_rounded, size: 16),
                    label: const Text('REQUEST BED'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildBedStat({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$count / $total',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
