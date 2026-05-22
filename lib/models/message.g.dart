// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      isTrainer: json['isTrainer'] as bool,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      status: $enumDecode(_$MessageStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      isTyping: json['isTyping'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'isTrainer': instance.isTrainer,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'isTyping': instance.isTyping,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.read: 'read',
};
