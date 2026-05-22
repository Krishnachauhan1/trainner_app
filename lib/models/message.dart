import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

enum MessageStatus { sending, sent, read }

enum MessageType { text, image, system }

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    required bool isTrainer,
    required String content,
    required MessageType type,
    required MessageStatus status,
    required DateTime createdAt,
    String? imageUrl,
    @Default(false) bool isTyping,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
