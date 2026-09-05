import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/facility_model.dart';
import '../../models/triage_result_model.dart';
import '../../providers/facility_provider.dart';
import '../../providers/triage_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/facility/facility_card.dart';

class FacilityRankingScreen extends ConsumerStatefulWidget {
  const FacilityRankingScreen({super.key});

  @override
  ConsumerState<FacilityRankingScreen> createState() => _FacilityRankingScreenState();
}

class _FacilityRankingScreenState extends ConsumerState<FacilityRankingScreen> {
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final triageResult = ref.watch(latestTriageResultProvider);
    final urgency = triageResult?.urgency ?? TriageUrgency.emergency;

    final rankedFacilitiesAsync = ref.watch(rankedFacilitiesProvider(urgency));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('bestFacilitiesTitle', lang)),
        actions: const [
          LanguageToggleButton(isDarkTheme: true),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('ICU Available'),
                  _buildFilterChip('Oxygen Ready'),
                  _buildFilterChip('Cardiology'),
                  _buildFilterChip('Trauma Care'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Facilities List
          Expanded(
            child: rankedFacilitiesAsync.when(
              data: (facilities) {
                // Apply UI filter
                final filtered = facilities.where((f) {
                  if (_activeFilter == 'ICU Available') return f.icuAvailable > 0;
                  if (_activeFilter == 'Oxygen Ready') return f.oxygenAvailable > 0;
                  if (_activeFilter == 'Cardiology') {
                    return f.specialties.any((s) => s.toLowerCase().contains('cardiology'));
                  }
                  if (_activeFilter == 'Trauma Care') {
                    return f.specialties.any((s) => s.toLowerCase().contains('trauma'));
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No facilities match the selected filter.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final facility = filtered[index];
                    return FacilityCard(
                      facility: facility,
                      onRequestBed: () {
                        ref.read(selectedFacilityProvider.notifier).state = facility;
                        context.push('/bed-reservation');
                      },
                      onTap: () {
                        ref.read(selectedFacilityProvider.notifier).state = facility;
                        context.push('/bed-reservation');
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _activeFilter == label;
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
        onSelected: (selected) {
          if (selected) {
            setState(() => _activeFilter = label);
          }
        },
      ),
    );
  }
}
