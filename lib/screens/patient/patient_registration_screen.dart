import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/id_generator.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/patient_model.dart';
import '../../providers/patient_provider.dart';
import '../../widgets/common/language_toggle_button.dart';

class PatientRegistrationScreen extends ConsumerStatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  ConsumerState<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends ConsumerState<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _villageController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _abhaController = TextEditingController();
  final _complaintController = TextEditingController();

  String _gender = 'Male';
  String _selectedDistrict = 'Pune';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _villageController.dispose();
    _emergencyController.dispose();
    _abhaController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  void _fillSampleData() {
    setState(() {
      _nameController.text = 'Vitthalrao Pandurang Shinde';
      _ageController.text = '54';
      _gender = 'Male';
      _mobileController.text = '9822941029';
      _villageController.text = 'Shirur Rural';
      _selectedDistrict = 'Pune';
      _emergencyController.text = '9822941030 (Shrikant - Son)';
      _abhaController.text = '91-3849-2049-5511';
      _complaintController.text = 'Severe chest tightness radiating to left jaw, diaphoresis';
    });
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final patientId = IdGenerator.generatePatientId(_selectedDistrict);

    final newPatient = PatientModel(
      id: patientId,
      fullName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 45,
      gender: _gender,
      mobile: _mobileController.text.trim(),
      village: _villageController.text.trim(),
      district: _selectedDistrict,
      emergencyContact: _emergencyController.text.trim(),
      abhaId: _abhaController.text.trim().isNotEmpty ? _abhaController.text.trim() : null,
      registrationDate: DateTime.now(),
      chiefComplaint: _complaintController.text.trim().isNotEmpty ? _complaintController.text.trim() : null,
    );

    await ref.read(patientListProvider.notifier).registerPatient(newPatient);
    ref.read(selectedPatientProvider.notifier).state = newPatient;

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient registered with ID: $patientId'),
          backgroundColor: AppColors.availableGreen,
        ),
      );
      context.push('/clinical-intake');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('patientRegistrationTitle', lang)),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high_rounded),
            tooltip: 'Auto-fill Demo Data',
            onPressed: _fillSampleData,
          ),
          const LanguageToggleButton(isDarkTheme: true),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // GovTech ABHA Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryTealLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, color: AppColors.primaryTeal, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ayushman Bharat Digital Health Mission (ABDM)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          Text(
                            'Generates unique Maharashtra Health Registry ID linked with PHC.',
                            style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Full Name
              Text(
                '${AppStrings.get('fullName', lang)} *',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Ramesh Balasaheb Patil',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryTeal),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter patient name' : null,
              ),
              const SizedBox(height: 16),

              // Age & Gender Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.get('age', lang)} *',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Years'),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.get('gender', lang)} *',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: const InputDecoration(),
                          items: ['Male', 'Female', 'Other'].map((g) {
                            return DropdownMenuItem(value: g, child: Text(g));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _gender = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mobile Number
              Text(
                '${AppStrings.get('mobile', lang)} *',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryTeal),
                  hintText: '10-digit mobile number',
                ),
                validator: (v) => (v == null || v.trim().length < 10) ? 'Enter valid 10-digit mobile' : null,
              ),
              const SizedBox(height: 16),

              // Village & District
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.get('village', lang)} *',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _villageController,
                          decoration: const InputDecoration(hintText: 'Village / Taluka'),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.get('district', lang)} *',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedDistrict,
                          isExpanded: true,
                          decoration: const InputDecoration(),
                          items: AppConstants.maharashtraDistricts.map((d) {
                            return DropdownMenuItem(
                              value: d,
                              child: Text(d, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedDistrict = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Emergency Contact
              Text(
                '${AppStrings.get('emergencyContact', lang)} *',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emergencyController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.contact_emergency_outlined, color: AppColors.emergencyRed),
                  hintText: 'Relative name & phone',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please provide an emergency contact' : null,
              ),
              const SizedBox(height: 16),

              // ABHA ID (Optional)
              Text(
                AppStrings.get('abhaId', lang),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _abhaController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.fingerprint_rounded, color: AppColors.primaryTeal),
                  hintText: '14-digit ABHA Number (e.g. 91-xxxx-xxxx-xxxx)',
                ),
              ),
              const SizedBox(height: 16),

              // Chief Complaint
              const Text(
                'Chief Presenting Complaint',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _complaintController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Describe acute symptoms or reason for emergency presentation...',
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleRegister,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(AppStrings.get('btnRegisterPatient', lang)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
