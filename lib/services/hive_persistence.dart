import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/call_request.dart';
import '../models/message.dart';
import '../models/session_log.dart';
import '../models/user.dart';
import 'auth_service.dart';
import 'chat_service.dart';
import 'log_service.dart';
import 'scheduler_service.dart';

class HivePersistence
    implements
        AuthPersistence,
        ChatPersistence,
        SchedulerPersistence,
        LogPersistence {
  HivePersistence(this._prefix);

  final String _prefix;

  Box<String> get _box => Hive.box<String>('${_prefix}_store');

  @override
  Future<User?> getUser() async {
    final raw = _box.get('user');
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveUser(User user) async {
    await _box.put('user', jsonEncode(user.toJson()));
  }

  @override
  Future<void> clearUser() async {
    await _box.delete('user');
  }

  @override
  Future<bool> isOnboardingComplete() async =>
      _box.get('onboarding') == 'true';

  @override
  Future<void> setOnboardingComplete(bool value) async {
    await _box.put('onboarding', value.toString());
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    final raw = _box.get('messages_$conversationId');
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveMessages(
    String conversationId,
    List<Message> messages,
  ) async {
    await _box.put(
      'messages_$conversationId',
      jsonEncode(messages.map((m) => m.toJson()).toList()),
    );
  }

  @override
  Future<List<CallRequest>> getRequests() async {
    final raw = _box.get('requests');
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => CallRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveRequests(List<CallRequest> requests) async {
    await _box.put(
      'requests',
      jsonEncode(requests.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<List<SessionLog>> getLogs() async {
    final raw = _box.get('logs');
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => SessionLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveLogs(List<SessionLog> logs) async {
    await _box.put(
      'logs',
      jsonEncode(logs.map((l) => l.toJson()).toList()),
    );
  }

  Future<void> saveRoomMeta(String id, Map<String, dynamic> json) async {
    await _box.put('room_$id', jsonEncode(json));
  }
}

Future<void> initHiveForApp(String appName) async {
  await Hive.initFlutter();
  if (!Hive.isBoxOpen('${appName}_store')) {
    await Hive.openBox<String>('${appName}_store');
  }
}
