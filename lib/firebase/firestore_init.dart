import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_logger.dart';
import '../utils/env_config.dart';

/// Call once after [Firebase.initializeApp].
Future<void> initFirestore(EnvConfig env) async {
  final db = FirebaseFirestore.instance;

  db.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  if (env.useFirestoreEmulator) {
    final host = env.firestoreEmulatorHost;
    db.useFirestoreEmulator(host, env.firestoreEmulatorPort);
    AppLogger.instance.log(
      LogCategory.general,
      'Firestore emulator $host:${env.firestoreEmulatorPort}',
    );
  }

  // Probe connection (dev only) — logs result to Dev Panel.
  if (kDebugMode && env.useFirebase && !env.useFirestoreEmulator) {
    try {
      await db
          .collection('_ping')
          .doc('probe')
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 15));
      AppLogger.instance.log(LogCategory.general, 'Firestore server reachable');
    } catch (e) {
      AppLogger.instance.log(
        LogCategory.general,
        'Firestore unreachable: $e — check SHA-1, Firestore enabled, emulator internet',
      );
    }
  }
}

/// Android emulator → 10.0.2.2 ; iOS simulator / desktop → localhost
String defaultFirestoreEmulatorHost() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return '10.0.2.2';
  }
  return 'localhost';
}
