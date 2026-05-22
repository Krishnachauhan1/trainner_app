import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../firebase/firestore_mappers.dart';
import '../firebase/firestore_paths.dart';
import '../models/message.dart';
import '../utils/app_logger.dart';
import '../utils/seed_data.dart';
import 'chat_service.dart';

/// Real-time chat via Cloud Firestore (Guru ↔ Trainer connectivity).
class FirebaseChatService implements ChatService {
  FirebaseChatService(this._persist);

  final ChatPersistence _persist;
  final _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();
  final _random = Random();

  final _conversationsCtrl =
      StreamController<List<ConversationSummary>>.broadcast();
  final _messagesCtrls = <String, StreamController<List<Message>>>{};
  final _typingCtrls = <String, StreamController<String?>>{};
  final _subs = <StreamSubscription<dynamic>>[];

  final _messagesByConv = <String, List<Message>>{};
  String? _userId;
  bool _isTrainer = false;
  String? _memberTrainerId;

  CollectionReference<Map<String, dynamic>> _messagesRef(String convId) =>
      _db.collection(FirestorePaths.messages(convId));

  List<Message> _messagesFor(String conversationId) =>
      _messagesByConv[conversationId] ?? [];

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

  List<String> get _conversationIds => _isTrainer
      ? [SeedData.conversationIdFor(SeedData.trainerId)]
      : SeedData.trainers.map((t) => SeedData.conversationIdFor(t.id)).toList();

  @override
  Future<void> connect(
    String userId,
    bool isTrainer, {
    String? trainerId,
  }) async {
    await disconnect();
    _userId = userId;
    _isTrainer = isTrainer;
    _memberTrainerId = trainerId ?? SeedData.trainerId;

    for (final convId in _conversationIds) {
      _messagesByConv[convId] = await _persist.getMessages(convId);
      final sub = _messagesRef(convId)
          .orderBy('createdAt')
          .snapshots()
          .listen((snap) => _onMessagesSnapshot(convId, snap));
      _subs.add(sub);

      final typingSub = _db
          .collection(FirestorePaths.typing(convId))
          .snapshots()
          .listen((snap) {
        String? typer;
        for (final doc in snap.docs) {
          if (doc.id != userId) {
            typer = doc.id;
            break;
          }
        }
        _typingCtrls[convId]?.add(typer);
      });
      _subs.add(typingSub);
    }

    await _emitConversations();
    AppLogger.instance.log(LogCategory.chat, 'Firebase connected');
  }

  void _onMessagesSnapshot(
    String convId,
    QuerySnapshot<Map<String, dynamic>> snap,
  ) {
    final messages = snap.docs.map(FirestoreMappers.messageFromDoc).toList();
    _messagesByConv[convId] = messages;
    unawaited(_persist.saveMessages(convId, messages));
    _messagesCtrls[convId]?.add(messages);
    unawaited(_emitConversations());
  }

  @override
  Future<void> disconnect() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
  }

  @override
  Future<List<ConversationSummary>> getConversations() async {
    await _emitConversations();
    return _buildSummaries();
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    final snap = await _messagesRef(conversationId)
        .orderBy('createdAt')
        .get();
    final messages = snap.docs.map(FirestoreMappers.messageFromDoc).toList();
    _messagesByConv[conversationId] = messages;
    await _persist.saveMessages(conversationId, messages);
    _messagesCtrls[conversationId]?.add(messages);
    return messages;
  }

  @override
  Future<void> refreshMessages(String conversationId) async =>
      getMessages(conversationId);

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
    final id = _uuid.v4();
    var msg = Message(
      id: id,
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

    await _messagesRef(conversationId)
        .doc(id)
        .set(FirestoreMappers.messageToMap(msg));

    await Future<void>.delayed(Duration(milliseconds: 200 + _random.nextInt(200)));
    msg = msg.copyWith(status: MessageStatus.sent);
    await _messagesRef(conversationId).doc(id).update({
      'status': MessageStatus.sent.name,
    });

    return msg;
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

  @override
  Future<void> markRead(String conversationId, String readerId) async {
    final batch = _db.batch();
    for (final m in _messagesFor(conversationId)) {
      if (m.senderId != readerId && m.status != MessageStatus.read) {
        batch.update(_messagesRef(conversationId).doc(m.id), {
          'status': MessageStatus.read.name,
        });
      }
    }
    await batch.commit();
  }

  @override
  Future<void> sendTyping(
    String conversationId,
    String userId,
    bool typing,
  ) async {
    final ref = _db
        .collection(FirestorePaths.typing(conversationId))
        .doc(userId);
    if (typing) {
      await ref.set({'at': FieldValue.serverTimestamp()});
      Future<void>.delayed(
        Duration(milliseconds: 400 + _random.nextInt(400)),
        () => ref.delete(),
      );
    } else {
      await ref.delete();
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
    await sendTyping(conversationId, trainer.id, false);
  }

  Future<void> _emitConversations() async {
    _conversationsCtrl.add(_buildSummaries());
  }

  List<ConversationSummary> _buildSummaries() {
    if (_isTrainer) {
      return [_summaryFor(SeedData.conversationIdFor(SeedData.trainerId), SeedData.memberName)];
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
