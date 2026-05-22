class EnvConfig {
  const EnvConfig({
    this.tokenServerUrl = 'http://localhost:3000',
    this.chatRelayUrl = 'ws://localhost:3000/chat',
    this.hmsTemplateId = 'your-template-id',
    this.appVersion = '1.0.0',
    this.useFirebase = true,
    this.useLocalRelay = false,
    this.useFirestoreEmulator = false,
    this.firestoreEmulatorHost = '10.0.2.2',
    this.firestoreEmulatorPort = 8080,
  });

  final String tokenServerUrl;
  final String chatRelayUrl;
  final String hmsTemplateId;
  final String appVersion;

  /// When true, chat / scheduler / logs sync via Cloud Firestore.
  final bool useFirebase;

  /// Fallback WebSocket relay (token_server) when Firebase is off.
  final bool useLocalRelay;

  /// Local Firestore emulator (firebase emulators:start --only firestore).
  final bool useFirestoreEmulator;
  final String firestoreEmulatorHost;
  final int firestoreEmulatorPort;

  static EnvConfig fromMap(Map<String, String> map) => EnvConfig(
        tokenServerUrl: map['TOKEN_SERVER_URL'] ?? 'http://localhost:3000',
        chatRelayUrl: map['CHAT_RELAY_URL'] ?? 'ws://localhost:3000/chat',
        hmsTemplateId: map['HMS_TEMPLATE_ID'] ?? 'your-template-id',
        appVersion: map['APP_VERSION'] ?? '1.0.0',
        useFirebase: map['USE_FIREBASE'] != 'false',
        useLocalRelay: map['USE_LOCAL_RELAY'] == 'true',
        useFirestoreEmulator: map['USE_FIRESTORE_EMULATOR'] == 'true',
        firestoreEmulatorHost:
            map['FIRESTORE_EMULATOR_HOST'] ?? '10.0.2.2',
        firestoreEmulatorPort:
            int.tryParse(map['FIRESTORE_EMULATOR_PORT'] ?? '') ?? 8080,
      );
}
