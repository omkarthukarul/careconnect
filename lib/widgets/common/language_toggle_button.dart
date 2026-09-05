import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../localization/app_language.dart';
import '../../localization/language_provider.dart';

class LanguageToggleButton extends ConsumerWidget {
  final bool isDarkTheme;

  const LanguageToggleButton({super.key, this.isDarkTheme = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);

    return InkWell(
      onTap: () {
        ref.read(languageProvider.notifier).toggleLanguage();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDarkTheme 
              ? Colors.white.withOpacity(0.15) 
              : AppColors.primaryTealLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkTheme ? Colors.white30 : AppColors.primaryTeal.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate_rounded,
              size: 14,
              color: isDarkTheme ? Colors.white : AppColors.primaryTeal,
            ),
            const SizedBox(width: 6),
            Text(
              currentLang == AppLanguage.english ? 'मराठी' : 'English',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDarkTheme ? Colors.white : AppColors.primaryTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
