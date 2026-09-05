import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/referral_model.dart';
import '../../models/triage_result_model.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';

class ReferralListScreen extends ConsumerStatefulWidget {
  const ReferralListScreen({super.key});

  @override
  ConsumerState<ReferralListScreen> createState() => _ReferralListScreenState();
}

class _ReferralListScreenState extends ConsumerState<ReferralListScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final referralsAsync = ref.watch(referralListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('referrals', lang)),
        actions: const [
          LanguageToggleButton(isDarkTheme: true),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilter('All'),
                  _buildFilter('In Transit'),
                  _buildFilter('Emergency'),
                  _buildFilter('Bed Reserved'),
                  _buildFilter('Completed'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          Expanded(
            child: referralsAsync.when(
              data: (referrals) {
                final filtered = referrals.where((r) {
                  if (_selectedFilter == 'In Transit') return r.status == ReferralStatus.inTransit;
                  if (_selectedFilter == 'Emergency') return r.urgency == TriageUrgency.emergency;
                  if (_selectedFilter == 'Bed Reserved') return r.status == ReferralStatus.bedReserved;
                  if (_selectedFilter == 'Completed') return r.status == ReferralStatus.completed;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No referrals found for this filter.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.borderLight),
                      ),
                      child: InkWell(
                        onTap: () {
                          ref.read(activeReferralProvider.notifier).state = item;
                          context.push('/referral-tracking');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.id,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.navySecondary,
                                    ),
                                  ),
                                  StatusBadge(
                                    label: item.status.labelEn,
                                    variant: item.urgency == TriageUrgency.emergency
                                        ? BadgeVariant.emergency
                                        : BadgeVariant.inProgress,
                                    isSmall: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.patientName,
                                style: AppStyles.heading3.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.patientAge} yrs • ${item.patientGender} • ${item.requiredSpecialty}',
                                style: AppStyles.caption,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.arrow_right_alt_rounded, color: AppColors.primaryTeal, size: 20),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${item.originFacility} ➔ ${item.destinationFacility}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (item.assignedAmbulance != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Ambulance: ${item.assignedAmbulance} • ETA: ${item.etaMinutes} min',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryTeal,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        backgroundColor: AppColors.background,
        onSelected: (val) {
          if (val) setState(() => _selectedFilter = label);
        },
      ),
    );
  }
}
