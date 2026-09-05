import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'localization/app_language.dart';
import 'localization/language_provider.dart';
import 'routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: CareConnectApp(),
    ),
  );
}

class CareConnectApp extends ConsumerWidget {
  const CareConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final currentLang = ref.watch(languageProvider);

    return MaterialApp.router(
      title: currentLang == AppLanguage.marathi
          ? AppConstants.appNameMarathi
          : AppConstants.appNameEnglish,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      locale: Locale(currentLang.code),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('mr', 'IN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
