import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/call_request.dart';
import '../models/message.dart';
import '../models/session_log.dart';

class FirestoreMappers {
  static Map<String, dynamic> messageToMap(Message m) => {
        'id': m.id,
        'conversationId': m.conversationId,
        'senderId': m.senderId,
        'senderName': m.senderName,
        'isTrainer': m.isTrainer,
        'content': m.content,
        'type': m.type.name,
        'status': m.status.name,
        'createdAt': Timestamp.fromDate(m.createdAt),
        'imageUrl': m.imageUrl,
      };

  static Message messageFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Message(
      id: doc.id,
      conversationId: data['conversationId'] as String,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      isTrainer: data['isTrainer'] as bool? ?? false,
      content: data['content'] as String,
      type: MessageType.values.byName(data['type'] as String),
      status: MessageStatus.values.byName(data['status'] as String),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] as String?,
    );
  }

  static Map<String, dynamic> callRequestToMap(CallRequest r) => {
        'id': r.id,
        'memberId': r.memberId,
        'memberName': r.memberName,
        'trainerId': r.trainerId,
        'slotStart': Timestamp.fromDate(r.slotStart),
        'slotEnd': Timestamp.fromDate(r.slotEnd),
        'note': r.note,
        'status': r.status.name,
        'createdAt': Timestamp.fromDate(r.createdAt),
        'declineReason': r.declineReason,
        'roomId': r.roomId,
      };

  static CallRequest callRequestFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return CallRequest(
      id: doc.id,
      memberId: d['memberId'] as String,
      memberName: d['memberName'] as String,
      trainerId: d['trainerId'] as String,
      slotStart: (d['slotStart'] as Timestamp).toDate(),
      slotEnd: (d['slotEnd'] as Timestamp).toDate(),
      note: d['note'] as String? ?? '',
      status: CallRequestStatus.values.byName(d['status'] as String),
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      declineReason: d['declineReason'] as String?,
      roomId: d['roomId'] as String?,
    );
  }

  static Map<String, dynamic> sessionLogToMap(SessionLog l) => {
        'id': l.id,
        'memberId': l.memberId,
        'memberName': l.memberName,
        'trainerId': l.trainerId,
        'trainerName': l.trainerName,
        'roomId': l.roomId,
        'startedAt': Timestamp.fromDate(l.startedAt),
        'endedAt': Timestamp.fromDate(l.endedAt),
        'durationSeconds': l.durationSeconds,
        'notes': l.notes,
        'memberRating': l.memberRating,
        'trainerRating': l.trainerRating,
      };

  static SessionLog sessionLogFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return SessionLog(
      id: doc.id,
      memberId: d['memberId'] as String,
      memberName: d['memberName'] as String,
      trainerId: d['trainerId'] as String,
      trainerName: d['trainerName'] as String,
      roomId: d['roomId'] as String,
      startedAt: (d['startedAt'] as Timestamp).toDate(),
      endedAt: (d['endedAt'] as Timestamp).toDate(),
      durationSeconds: d['durationSeconds'] as int,
      notes: d['notes'] as String?,
      memberRating: d['memberRating'] as int? ?? 0,
      trainerRating: d['trainerRating'] as int? ?? 0,
    );
  }
}
