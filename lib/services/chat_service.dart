import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/message.dart';
import '../utils/app_logger.dart';
import '../utils/env_config.dart';
import '../utils/seed_data.dart';

abstract class ChatService {
  Stream<List<ConversationSummary>> get conversationsStream;
  Stream<List<Message>> messagesStream(String conversationId);
  Stream<String?> typingStream(String conversationId);
  Future<void> connect(
    String userId,
    bool isTrainer, {
    String? trainerId,
  });
  Future<void> disconnect();
  Future<List<ConversationSummary>> getConversations();
  Future<List<Message>> getMessages(String conversationId);
  Future<void> refreshMessages(String conversationId);
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required bool isTrainer,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  });
  Future<void> markRead(String conversationId, String readerId);
  Future<void> sendTyping(String conversationId, String userId, bool typing);
  Future<void> simulateTrainerReply(String conversationId);
  Future<void> sendSystemMessage(String conversationId, String content);
}

class ConversationSummary {
  ConversationSummary({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.isTrainer,
  });

  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isTrainer;
}

class LocalChatService implements ChatService {
  LocalChatService(this._persist, this._env);

  final ChatPersistence _persist;
  final EnvConfig _env;
  final _uuid = const Uuid();
  final _random = Random();

  WebSocketChannel? _channel;
  final _conversationsCtrl =
      StreamController<List<ConversationSummary>>.broadcast();
  final _messagesCtrls = <String, StreamController<List<Message>>>{};
  final _typingCtrls = <String, StreamController<String?>>{};
  final _messagesByConv = <String, List<Message>>{};
  String? _userId;
  bool _isTrainer = false;
  String? _memberTrainerId;

  @override
  Stream<List<ConversationSummary>> get conversationsStream =>
      _conversationsCtrl.stream;

  @override
  Stream<List<Message>> messagesStream(String conversationId) {
    _messagesCtrls.putIfAbsent(
      conversationId,
      () => StreamController<List<Message>>.broadcast(),
    );
    return _messagesCtrls[conversationId]!.stream;
  }

  @override
  Stream<String?> typingStream(String conversationId) {
    _typingCtrls.putIfAbsent(
      conversationId,
      () => StreamController<String?>.broadcast(),
    );
    return _typingCtrls[conversationId]!.stream;
  }

  List<Message> _messagesFor(String conversationId) =>
      _messagesByConv[conversationId] ?? [];

  @override
  Future<void> connect(
    String userId,
    bool isTrainer, {
    String? trainerId,
  }) async {
    _userId = userId;
    _isTrainer = isTrainer;
    _memberTrainerId = trainerId ?? SeedData.trainerId;
    final convIds = isTrainer
        ? [SeedData.conversationIdFor(SeedData.trainerId)]
        : SeedData.trainers.map((t) => SeedData.conversationIdFor(t.id));
    for (final id in convIds) {
      _messagesByConv[id] = await _persist.getMessages(id);
    }
    await _emitAll();
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_env.chatRelayUrl));
      _channel!.stream.listen(_onRelayMessage, onError: (_) {}, onDone: () {});
      _channel!.sink.add(jsonEncode({
        'type': 'join',
        'userId': userId,
        'isTrainer': isTrainer,
      }));
      AppLogger.instance.log(LogCategory.chat, 'Relay connected');
    } catch (e) {
      AppLogger.instance.log(LogCategory.chat, 'Relay offline: $e');
    }
  }

  void _onRelayMessage(dynamic data) {
    try {
      final map = jsonDecode(data as String) as Map<String, dynamic>;
      final type = map['type'] as String?;
      if (type == 'message') {
        final msg = Message.fromJson(map['payload'] as Map<String, dynamic>);
        _upsertMessage(msg);
      } else if (type == 'typing') {
        final convId = map['conversationId'] as String;
        _typingCtrls[convId]?.add(map['userId'] as String?);
      } else if (type == 'read') {
        _markAllRead(map['conversationId'] as String, map['readerId'] as String);
      }
    } catch (e) {
      AppLogger.instance.log(LogCategory.chat, 'Relay parse error: $e');
    }
  }

  void _relay(Map<String, dynamic> payload) {
    try {
      _channel?.sink.add(jsonEncode(payload));
    } catch (_) {}
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  @override
  Future<List<ConversationSummary>> getConversations() async {
    await _emitConversations();
    return _buildSummaries();
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    final messages = await _persist.getMessages(conversationId);
    _messagesByConv[conversationId] = messages;
    _messagesCtrls[conversationId]?.add(messages);
    return messages;
  }

  @override
  Future<void> refreshMessages(String conversationId) async {
    final messages = await _persist.getMessages(conversationId);
    _messagesByConv[conversationId] = messages;
    await _persist.saveMessages(conversationId, messages);
    _messagesCtrls[conversationId]?.add(messages);
    AppLogger.instance.log(LogCategory.chat, 'Refreshed history');
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required bool isTrainer,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    var msg = Message(
      id: _uuid.v4(),
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      isTrainer: isTrainer,
      content: content,
      type: type,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );
    await _upsertMessage(msg);
    await Future<void>.delayed(Duration(milliseconds: 200 + _random.nextInt(200)));
    msg = msg.copyWith(status: MessageStatus.sent);
    await _upsertMessage(msg);
    _relay({'type': 'message', 'payload': msg.toJson()});
    if (!_isTrainer && !isTrainer) {
      unawaited(simulateTrainerReply(conversationId));
    }
    return msg;
  }

  @override
  Future<void> markRead(String conversationId, String readerId) async {
    await _markAllRead(conversationId, readerId);
    _relay({
      'type': 'read',
      'conversationId': conversationId,
      'readerId': readerId,
    });
  }

  Future<void> _markAllRead(String conversationId, String readerId) async {
    final messages = _messagesFor(conversationId)
        .map((m) {
          if (m.senderId != readerId && m.status != MessageStatus.read) {
            return m.copyWith(status: MessageStatus.read);
          }
          return m;
        })
        .toList();
    _messagesByConv[conversationId] = messages;
    await _persist.saveMessages(conversationId, messages);
    _messagesCtrls[conversationId]?.add(messages);
    await _emitConversations();
  }

  @override
  Future<void> sendTyping(String conversationId, String userId, bool typing) async {
    if (typing) {
      _typingCtrls[conversationId]?.add(userId);
      _relay({
        'type': 'typing',
        'conversationId': conversationId,
        'userId': userId,
      });
      Future<void>.delayed(
        Duration(milliseconds: 400 + _random.nextInt(400)),
        () => _typingCtrls[conversationId]?.add(null),
      );
    }
  }

  @override
  Future<void> simulateTrainerReply(String conversationId) async {
    final trainer = SeedData.trainers.firstWhere(
      (t) => SeedData.conversationIdFor(t.id) == conversationId,
      orElse: () => SeedData.trainer,
    );
    await sendTyping(conversationId, trainer.id, true);
    await Future<void>.delayed(
      Duration(milliseconds: 400 + _random.nextInt(400)),
    );
    const replies = [
      'Great progress today!',
      'Remember to hydrate.',
      'Let me know if you need form checks.',
      'See you on the call!',
    ];
    await sendMessage(
      conversationId: conversationId,
      senderId: trainer.id,
      senderName: trainer.name,
      isTrainer: true,
      content: replies[_random.nextInt(replies.length)],
    );
    _typingCtrls[conversationId]?.add(null);
  }

  @override
  Future<void> sendSystemMessage(String conversationId, String content) =>
      sendMessage(
        conversationId: conversationId,
        senderId: 'system',
        senderName: 'System',
        isTrainer: true,
        content: content,
        type: MessageType.system,
      );

  Future<void> _upsertMessage(Message msg) async {
    final convId = msg.conversationId;
    final list = List<Message>.from(_messagesFor(convId));
    final idx = list.indexWhere((m) => m.id == msg.id);
    if (idx >= 0) {
      list[idx] = msg;
    } else {
      list.add(msg);
    }
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _messagesByConv[convId] = list;
    await _persist.saveMessages(convId, list);
    _messagesCtrls[convId]?.add(list);
    await _emitConversations();
  }

  Future<void> _emitAll() async {
    await _emitConversations();
    for (final entry in _messagesByConv.entries) {
      _messagesCtrls[entry.key]?.add(entry.value);
    }
  }

  Future<void> _emitConversations() async {
    _conversationsCtrl.add(_buildSummaries());
  }

  List<ConversationSummary> _buildSummaries() {
    if (_isTrainer) {
      return [
        _summaryFor(
          SeedData.conversationIdFor(SeedData.trainerId),
          SeedData.memberName,
        ),
      ];
    }
    return SeedData.trainers.map((t) {
      final convId = SeedData.conversationIdFor(t.id);
      return _summaryFor(convId, t.name, isPrimary: t.id == _memberTrainerId);
    }).toList();
  }

  ConversationSummary _summaryFor(
    String convId,
    String title, {
    bool isPrimary = false,
  }) {
    final convMessages = _messagesFor(convId);
    final last = convMessages.isEmpty
        ? null
        : convMessages.reduce(
            (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
          );
    final unread = convMessages
        .where((m) =>
            m.status != MessageStatus.read &&
            m.senderId != (_userId ?? '') &&
            !m.isTyping)
        .length;
    final preview = last?.content ??
        (isPrimary ? 'Your coach — tap to chat' : 'Tap to start conversation');
    return ConversationSummary(
      id: convId,
      title: title,
      lastMessage: preview,
      lastMessageAt: last?.createdAt ?? DateTime.now(),
      unreadCount: unread,
      isTrainer: false,
    );
  }
}

abstract class ChatPersistence {
  Future<List<Message>> getMessages(String conversationId);
  Future<void> saveMessages(String conversationId, List<Message> messages);
}
