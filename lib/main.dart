import 'dart:io';

import 'package:defacto/ui/screens/main/Loading_screen.dart';
import 'package:defacto/ui/screens/main/about.dart';
import 'package:defacto/ui/screens/main/configuration.dart';
import 'package:defacto/ui/screens/main/logs.dart';
import 'package:defacto/ui/screens/main/routing.dart';
import 'package:defacto/ui/screens/main/settings.dart';
import 'package:defacto/ui/screens/skeleton/skeleton_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'config/theme.dart';
import 'states/global/theme_mode_state.dart';

/// Try using const constructors as much as possible!

void main() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  final Directory tmpDir = await getTemporaryDirectory();
  await Hive.initFlutter(tmpDir.toString());
  await Hive.openBox('prefs');

  runApp(
    ProviderScope(
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const <Locale>[
          Locale('en'),
          Locale('de'),
        ],
        fallbackLocale: const Locale('en'),
        useFallbackTranslations: true,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState currentTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Bepass',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentTheme.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/': (context) => const SkeletonScreen(),
        '/configuration': (context) => const ConfigurationScreen(),
        '/routingAndRules': (context) => const RoutingScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/logs': (context) => const LogsScreen(),
        '/about': (context) => const AboutScreen(),
      },
      onGenerateRoute: (settings) {
        // If the route is not found, just get moved to the skeleton screen
        return MaterialPageRoute(builder: (context) => const LoadingScreen());
      },
    );
  }
}
