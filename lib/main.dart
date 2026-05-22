import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainner_app/app_shared.dart';
import 'package:trainner_app/firebase_options.dart';

import 'app.dart';
import 'core/firebase_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final startup = await resolveStartupEnv();
  await initHiveForApp('trainer_app');

  runApp(
    ProviderScope(
      overrides: [
        appBootstrapProvider.overrideWithValue(
          (appName: 'trainer_app', isTrainerApp: true),
        ),
        envConfigProvider.overrideWithValue(startup.env),
        firebaseConnectedProvider.overrideWith((ref) => startup.firebaseOk),
      ],
      child: const TrainerApp(),
    ),
  );
}
