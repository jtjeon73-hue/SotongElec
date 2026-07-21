import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routing/app_router.dart';
import '../core/storage/study_progress_controller.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';

class SotongElecApp extends StatelessWidget {
  const SotongElecApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.watch<StudyProgressController>().darkMode;
    return MaterialApp.router(
      title: '${AppConstants.appName} · ${AppConstants.appSubtitle}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
