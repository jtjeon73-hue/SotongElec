import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/storage/study_progress_controller.dart';
import 'core/storage/study_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final storage = SharedPrefsStudyStorage();
  final progress = StudyProgressController(storage);
  await progress.init();

  runApp(
    ChangeNotifierProvider<StudyProgressController>.value(
      value: progress,
      child: const SotongElecApp(),
    ),
  );
}
