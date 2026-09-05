import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_language.dart';
import 'app_strings.dart';

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english);

  void setLanguage(AppLanguage language) {
    state = language;
  }

  void toggleLanguage() {
    state = state == AppLanguage.english ? AppLanguage.marathi : AppLanguage.english;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

/// Extension on WidgetRef to easily retrieve localized strings
extension LocalizedRef on WidgetRef {
  String tr(String key) {
    final lang = watch(languageProvider);
    return AppStrings.get(key, lang);
  }
}
