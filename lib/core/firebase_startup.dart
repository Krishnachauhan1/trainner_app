import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainner_app/utils/env_config.dart';

/// Debug SHA-1 for Firebase Console (project gymapp-d73bc).
const kFirebaseDebugSha1 =
    '6E:FB:F4:ED:5C:7E:56:FB:A2:FB:B0:38:90:71:11:27:08:7E:50:BD';

/// Set in [main] after [resolveStartupEnv].
final firebaseConnectedProvider = StateProvider<bool>((ref) => true);

Future<void> _initFirestore() async {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

Future<bool> isFirestoreReachable() async {
  try {
    await FirebaseFirestore.instance
        .collection('_connectivity_probe')
        .doc('ping')
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 12));
    return true;
  } catch (e) {
    debugPrint('[Firebase] Firestore unreachable: $e');
    return false;
  }
}

/// Tries Firebase chat; falls back to Hive + WebSocket relay when offline.
Future<({EnvConfig env, bool firebaseOk})> resolveStartupEnv() async {
  const firebaseEnv = EnvConfig(appVersion: '1.0.0', useFirebase: true);
  await _initFirestore();
  final ok = await isFirestoreReachable();
  if (ok) {
    return (env: firebaseEnv, firebaseOk: true);
  }
  final relayHost = defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : 'localhost';
  return (
    env: EnvConfig(
      appVersion: '1.0.0',
      useFirebase: false,
      useLocalRelay: true,
      tokenServerUrl: 'http://$relayHost:3000',
      chatRelayUrl: 'ws://$relayHost:3000/chat',
    ),
    firebaseOk: false,
  );
}
