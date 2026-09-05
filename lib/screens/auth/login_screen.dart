import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/language_toggle_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: AppConstants.demoMobile);
  final _passwordController = TextEditingController(text: AppConstants.demoPassword);
  UserRole _selectedRole = UserRole.medicalOfficer;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _routeForRole(UserRole role) {
    switch (role) {
      case UserRole.medicalOfficer:
        context.go('/mo-dashboard');
        break;
      case UserRole.hospitalStaff:
        context.go('/hospital-dashboard');
        break;
      case UserRole.ambulanceEMS:
        context.go('/ambulance');
        break;
      case UserRole.patient:
        context.go('/patient-portal');
        break;
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authNotifierProvider.notifier).login(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
        );

    if (success && mounted) {
      _routeForRole(_selectedRole);
    }
  }

  Future<void> _handleDemoLogin() async {
    await ref.read(authNotifierProvider.notifier).demoLogin(_selectedRole);
    if (mounted) {
      _routeForRole(_selectedRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('appName', lang)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Center(child: LanguageToggleButton(isDarkTheme: true)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Emblem & Gov Notice
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTealLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 40,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.get('appName', lang),
                  textAlign: TextAlign.center,
                  style: AppStyles.heading1.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  '“${AppStrings.get('tagline', lang)}”',
                  textAlign: TextAlign.center,
                  style: AppStyles.caption.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),

                // Role Selector Card
                Text(
                  AppStrings.get('selectRole', lang),
                  style: AppStyles.heading3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: UserRole.values.map((role) {
                      final isSelected = _selectedRole == role;
                      final IconData roleIcon;
                      switch (role) {
                        case UserRole.medicalOfficer:
                          roleIcon = Icons.medical_services_rounded;
                          break;
                        case UserRole.hospitalStaff:
                          roleIcon = Icons.local_hospital_rounded;
                          break;
                        case UserRole.ambulanceEMS:
                          roleIcon = Icons.airport_shuttle_rounded;
                          break;
                        case UserRole.patient:
                          roleIcon = Icons.person_rounded;
                          break;
                      }

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRole = role;
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryTealLight : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                roleIcon,
                                color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  lang.code == 'mr' ? role.labelMr : role.labelEn,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.primaryTeal : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Radio<UserRole>(
                                value: role,
                                groupValue: _selectedRole,
                                activeColor: AppColors.primaryTeal,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedRole = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Identifier Field
                Text(
                  AppStrings.get('mobileOrEmail', lang),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryTeal),
                    hintText: 'Enter 10-digit mobile or official email',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter mobile number or email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                Text(
                  AppStrings.get('password', lang),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryTeal),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                if (authState.error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    authState.error!,
                    style: const TextStyle(color: AppColors.emergencyRed, fontSize: 12),
                  ),
                ],

                const SizedBox(height: 24),

                // Primary Login Button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(AppStrings.get('login', lang)),
                ),
                const SizedBox(height: 12),

                // Demo Login Button (Hackathon Fast-Track)
                OutlinedButton.icon(
                  onPressed: authState.isLoading ? null : _handleDemoLogin,
                  icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
                  label: Text('${AppStrings.get('demoLogin', lang)} (${lang.code == 'mr' ? _selectedRole.labelMr : _selectedRole.labelEn})'),
                ),
                const SizedBox(height: 24),

                // Gov Disclaimer
                Text(
                  '${AppConstants.stateDepartment}\nEmergency Triage & Bed Registry Portal',
                  textAlign: TextAlign.center,
                  style: AppStyles.caption.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
