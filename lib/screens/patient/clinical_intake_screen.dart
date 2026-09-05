import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/vitals_model.dart';
import '../../providers/patient_provider.dart';
import '../../providers/triage_provider.dart';
import '../../widgets/common/language_toggle_button.dart';

class ClinicalIntakeScreen extends ConsumerStatefulWidget {
  const ClinicalIntakeScreen({super.key});

  @override
  ConsumerState<ClinicalIntakeScreen> createState() => _ClinicalIntakeScreenState();
}

class _ClinicalIntakeScreenState extends ConsumerState<ClinicalIntakeScreen> {
  final _heartRateController = TextEditingController(text: '76');
  final _systolicController = TextEditingController(text: '120');
  final _diastolicController = TextEditingController(text: '80');
  final _spo2Controller = TextEditingController(text: '98');
  final _temperatureController = TextEditingController(text: '98.6');
  final _respiratoryRateController = TextEditingController(text: '16');
  final _notesController = TextEditingController();

  ConsciousnessLevel _consciousness = ConsciousnessLevel.alert;

  final Set<String> _selectedSymptoms = {'Chest Pain'};

  final List<Map<String, String>> _symptomOptions = [
    {'key': 'chestPain', 'en': 'Chest Pain'},
    {'key': 'breathlessness', 'en': 'Breathlessness'},
    {'key': 'fever', 'en': 'Fever'},
    {'key': 'trauma', 'en': 'Trauma'},
    {'key': 'weakness', 'en': 'Weakness'},
    {'key': 'bleeding', 'en': 'Bleeding'},
    {'key': 'otherSymptom', 'en': 'Other'},
  ];

  @override
  void dispose() {
    _heartRateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _spo2Controller.dispose();
    _temperatureController.dispose();
    _respiratoryRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyClinicalPreset(String presetName) {
    setState(() {
      if (presetName == 'stemi') {
        _selectedSymptoms.clear();
        _selectedSymptoms.addAll({'Chest Pain', 'Breathlessness'});
        _heartRateController.text = '118';
        _systolicController.text = '175';
        _diastolicController.text = '105';
        _spo2Controller.text = '91.0';
        _temperatureController.text = '98.4';
        _respiratoryRateController.text = '24';
        _consciousness = ConsciousnessLevel.alert;
        _notesController.text = 'Crushing substernal pain radiating to left shoulder, diaphoresis.';
      } else if (presetName == 'hypoxia') {
        _selectedSymptoms.clear();
        _selectedSymptoms.addAll({'Breathlessness', 'Fever', 'Weakness'});
        _heartRateController.text = '126';
        _systolicController.text = '100';
        _diastolicController.text = '65';
        _spo2Controller.text = '84.0'; // Critical Hypoxia < 90
        _temperatureController.text = '102.8';
        _respiratoryRateController.text = '32';
        _consciousness = ConsciousnessLevel.verbal;
        _notesController.text = 'Severe dyspnea, cyanosis around lips, bilateral crepitations.';
      } else if (presetName == 'shock') {
        _selectedSymptoms.clear();
        _selectedSymptoms.addAll({'Trauma', 'Bleeding', 'Weakness'});
        _heartRateController.text = '138';
        _systolicController.text = '78'; // Hypotension < 90
        _diastolicController.text = '48';
        _spo2Controller.text = '92.0';
        _temperatureController.text = '97.2';
        _respiratoryRateController.text = '28';
        _consciousness = ConsciousnessLevel.pain;
        _notesController.text = 'Road traffic accident, open compound pelvic & femoral fracture with hemorrhage.';
      } else {
        // Normal Routine
        _selectedSymptoms.clear();
        _selectedSymptoms.add('Fever');
        _heartRateController.text = '76';
        _systolicController.text = '118';
        _diastolicController.text = '78';
        _spo2Controller.text = '98.5';
        _temperatureController.text = '99.2';
        _respiratoryRateController.text = '16';
        _consciousness = ConsciousnessLevel.alert;
        _notesController.text = 'Mild malaise and intermittent low-grade fever for 2 days.';
      }
    });
  }

  void _runTriage() {
    final selectedPatient = ref.read(selectedPatientProvider);
    final patientId = selectedPatient?.id ?? 'MH-PUN-2026-0842';
    final patientName = selectedPatient?.fullName ?? 'Ramesh Balasaheb Patil';

    final vitals = VitalsModel(
      heartRate: int.tryParse(_heartRateController.text.trim()) ?? 75,
      systolicBP: int.tryParse(_systolicController.text.trim()) ?? 120,
      diastolicBP: int.tryParse(_diastolicController.text.trim()) ?? 80,
      spo2: double.tryParse(_spo2Controller.text.trim()) ?? 98.0,
      temperature: double.tryParse(_temperatureController.text.trim()) ?? 98.6,
      respiratoryRate: int.tryParse(_respiratoryRateController.text.trim()) ?? 16,
      consciousness: _consciousness,
    );

    // Save vitals & symptoms in Riverpod
    ref.read(currentVitalsProvider.notifier).state = vitals;
    ref.read(currentSymptomsProvider.notifier).state = _selectedSymptoms.toList();

    // Execute triage algorithm
    ref.read(triageControllerProvider).runTriage(
          patientId: patientId,
          patientName: patientName,
          clinicalNotes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        );

    context.push('/triage-result');
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final patient = ref.watch(selectedPatientProvider);

    final patientName = patient?.fullName ?? 'Ramesh Balasaheb Patil';
    final patientId = patient?.id ?? 'MH-PUN-2026-0842';
    final patientAge = patient?.age ?? 58;
    final patientGender = patient?.gender ?? 'Male';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('clinicalIntakeTitle', lang)),
        actions: const [
          LanguageToggleButton(isDarkTheme: true),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient Identity Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryTealLight,
                    child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName,
                          style: AppStyles.heading3.copyWith(fontSize: 17),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$patientAge yrs • $patientGender • $patientId',
                          style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTealLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ACTIVE INTAKE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Demo Presets Quick Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SIMULATE CLINICAL SCENARIOS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  '(SIH Demo Presets)',
                  style: TextStyle(fontSize: 11, color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _presetChip('Critical Hypoxia', 'hypoxia', AppColors.emergencyRed),
                  _presetChip('Acute STEMI (Cardiac)', 'stemi', AppColors.emergencyRed),
                  _presetChip('Trauma / Shock', 'shock', AppColors.emergencyRed),
                  _presetChip('Stable OPD Routine', 'normal', AppColors.availableGreen),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Symptoms Selector
            Text(
              AppStrings.get('symptoms', lang),
              style: AppStyles.heading3.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptomOptions.map((sym) {
                final isSelected = _selectedSymptoms.contains(sym['en']);
                final label = AppStrings.get(sym['key']!, lang);

                return FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: AppColors.primaryTealLight,
                  checkmarkColor: AppColors.primaryTeal,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryTealDark : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryTeal : AppColors.borderLight,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(sym['en']!);
                      } else {
                        _selectedSymptoms.remove(sym['en']!);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Vitals Input Section
            Text(
              AppStrings.get('vitals', lang),
              style: AppStyles.heading3.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // SpO2 and Heart Rate Row
            Row(
              children: [
                Expanded(
                  child: _buildVitalInput(
                    label: AppStrings.get('spo2', lang),
                    controller: _spo2Controller,
                    unit: '%',
                    icon: Icons.water_drop_rounded,
                    color: double.tryParse(_spo2Controller.text) != null &&
                            double.parse(_spo2Controller.text) < 90
                        ? AppColors.emergencyRed
                        : AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVitalInput(
                    label: AppStrings.get('heartRate', lang),
                    controller: _heartRateController,
                    unit: 'BPM',
                    icon: Icons.favorite_rounded,
                    color: int.tryParse(_heartRateController.text) != null &&
                            int.parse(_heartRateController.text) > 120
                        ? AppColors.emergencyRed
                        : AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Blood Pressure Row (Systolic / Diastolic)
            Row(
              children: [
                Expanded(
                  child: _buildVitalInput(
                    label: AppStrings.get('systolic', lang),
                    controller: _systolicController,
                    unit: 'mmHg',
                    icon: Icons.speed_rounded,
                    color: int.tryParse(_systolicController.text) != null &&
                            (int.parse(_systolicController.text) < 90 ||
                             int.parse(_systolicController.text) >= 180)
                        ? AppColors.emergencyRed
                        : AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVitalInput(
                    label: AppStrings.get('diastolic', lang),
                    controller: _diastolicController,
                    unit: 'mmHg',
                    icon: Icons.speed_rounded,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Temperature and Respiratory Rate Row
            Row(
              children: [
                Expanded(
                  child: _buildVitalInput(
                    label: AppStrings.get('temperature', lang),
                    controller: _temperatureController,
                    unit: '°F',
                    icon: Icons.thermostat_rounded,
                    color: double.tryParse(_temperatureController.text) != null &&
                            double.parse(_temperatureController.text) >= 102
                        ? AppColors.urgentOrange
                        : AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVitalInput(
                    label: AppStrings.get('respiratoryRate', lang),
                    controller: _respiratoryRateController,
                    unit: '/min',
                    icon: Icons.air_rounded,
                    color: int.tryParse(_respiratoryRateController.text) != null &&
                            int.parse(_respiratoryRateController.text) > 24
                        ? AppColors.emergencyRed
                        : AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Consciousness Level (AVPU)
            Text(
              AppStrings.get('consciousness', lang),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ConsciousnessLevel>(
                  value: _consciousness,
                  isExpanded: true,
                  items: ConsciousnessLevel.values.map((lvl) {
                    return DropdownMenuItem(
                      value: lvl,
                      child: Text(
                        lang.code == 'mr' ? lvl.labelMr : lvl.labelEn,
                        style: TextStyle(
                          color: lvl == ConsciousnessLevel.alert
                              ? AppColors.textPrimary
                              : AppColors.emergencyRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _consciousness = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Clinical Notes
            const Text(
              'Attending MO Clinical Notes',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Add clinical impressions, provisional diagnosis, or field observations...',
              ),
            ),
            const SizedBox(height: 28),

            // Primary RUN TRIAGE Button
            ElevatedButton.icon(
              onPressed: _runTriage,
              icon: const Icon(Icons.bolt_rounded, size: 22),
              label: Text(AppStrings.get('runTriage', lang)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emergencyRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetChip(String label, String code, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(Icons.flash_on_rounded, size: 14, color: color),
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        backgroundColor: color.withOpacity(0.08),
        side: BorderSide(color: color.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () => _applyClinicalPreset(code),
      ),
    );
  }

  Widget _buildVitalInput({
    required String label,
    required TextEditingController controller,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
