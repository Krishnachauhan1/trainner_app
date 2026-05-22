import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/room_meta.dart';
import '../services/auth_service.dart';
import '../services/call_service.dart';
import '../services/chat_service.dart';
import '../services/firebase_chat_service.dart';
import '../services/firebase_log_service.dart';
import '../services/firebase_scheduler_service.dart';
import '../services/hive_persistence.dart';
import '../services/log_service.dart';
import '../services/scheduler_service.dart';
import '../utils/date_utils.dart';
import '../utils/env_config.dart';
import '../utils/seed_data.dart';

final envConfigProvider = Provider<EnvConfig>((ref) => const EnvConfig());

typedef AppBootstrap = ({
  String appName,
  bool isTrainerApp,
});

final appBootstrapProvider = Provider<AppBootstrap>(
  (ref) => throw UnimplementedError('Override in app main'),
);

final hivePersistenceProvider = Provider<HivePersistence>((ref) {
  final boot = ref.watch(appBootstrapProvider);
  return HivePersistence(boot.appName);
});

final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService(ref.watch(hivePersistenceProvider));
});

final chatServiceProvider = Provider<ChatService>((ref) {
  final env = ref.watch(envConfigProvider);
  final persist = ref.watch(hivePersistenceProvider);
  if (env.useFirebase) {
    final chat = FirebaseChatService(persist);
    ref.onDispose(chat.disconnect);
    return chat;
  }
  final chat = LocalChatService(persist, env);
  ref.onDispose(chat.disconnect);
  return chat;
});

final schedulerServiceProvider = Provider<SchedulerService>((ref) {
  final env = ref.watch(envConfigProvider);
  final chat = ref.watch(chatServiceProvider);
  final persist = ref.watch(hivePersistenceProvider);
  if (env.useFirebase) {
    final svc = FirebaseSchedulerService(chat, persist);
    ref.onDispose(svc.dispose);
    return svc;
  }
  return LocalSchedulerService(
    persist,
    (request, meta) async {
      final date = AppDateUtils.formatSlot(request.slotStart);
      await chat.sendSystemMessage(
        SeedData.conversationIdFor(request.trainerId),
        'Call approved for $date.',
      );
      await persist.saveRoomMeta(meta.roomId, meta.toJson());
    },
  );
});

final logServiceProvider = Provider<LogService>((ref) {
  final env = ref.watch(envConfigProvider);
  if (env.useFirebase) {
    final svc = FirebaseLogService();
    ref.onDispose(svc.dispose);
    return svc;
  }
  return LocalLogService(ref.watch(hivePersistenceProvider));
});

final callServiceProvider = Provider<HmsCallService>((ref) {
  final svc = HmsCallService(ref.watch(envConfigProvider));
  ref.onDispose(svc.dispose);
  return svc;
});

final currentUserProvider = StreamProvider((ref) async* {
  final auth = ref.watch(authServiceProvider);
  yield await auth.loadPersistedUser();
});

final roomMetaProvider = StateProvider<RoomMeta?>((ref) => null);
