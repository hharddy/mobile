import 'package:defacto/enums/app_pages.dart';
import 'package:defacto/states/global/global_state.dart';
import 'package:defacto/ui/screens/main/about.dart';
import 'package:defacto/ui/screens/main/configuration.dart';
import 'package:defacto/ui/screens/main/logs.dart';
import 'package:defacto/ui/screens/main/routing.dart';
import 'package:defacto/ui/screens/main/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class SkeletonScreen extends ConsumerWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPage currentPage = ref.watch(globalStateProvider).activePage;

    Widget getPageWidget(AppPage page) {
      switch (page) {
        case AppPage.configuration:
          return const ConfigurationScreen();
        case AppPage.routingAndRules:
          return const RoutingScreen();
        case AppPage.settings:
          return const SettingsScreen();
        case AppPage.logs:
          return const LogsScreen();
        case AppPage.about:
          return const AboutScreen();
        // Add more cases for additional pages
        default:
          return const ConfigurationScreen();
      }
    }

    return getPageWidget(currentPage);
  }
}
