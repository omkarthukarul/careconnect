import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../providers/patient_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/patient/patient_card.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final patientsAsync = ref.watch(patientListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('patients', lang)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => context.push('/register-patient'),
          ),
          const LanguageToggleButton(isDarkTheme: true),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by patient name, ID, or mobile...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryTeal),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(patientListProvider.notifier).search('');
                        },
                      )
                    : null,
                isDense: true,
              ),
              onChanged: (val) {
                ref.read(patientListProvider.notifier).search(val);
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Patients List
          Expanded(
            child: patientsAsync.when(
              data: (patients) {
                if (patients.isEmpty) {
                  return const Center(child: Text('No registered patients found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final p = patients[index];
                    return PatientCard(
                      patient: p,
                      onTap: () {
                        ref.read(selectedPatientProvider.notifier).state = p;
                        context.push('/clinical-intake');
                      },
                      onTriageTap: () {
                        ref.read(selectedPatientProvider.notifier).state = p;
                        context.push('/clinical-intake');
                      },
                      onHistoryTap: () {
                        ref.read(selectedPatientProvider.notifier).state = p;
                        context.push('/patient-history');
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/register-patient'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(AppStrings.get('registerPatient', lang)),
      ),
    );
  }
}
