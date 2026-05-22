/// Firestore collection paths shared by Guru & Trainer apps.
class FirestorePaths {
  static const conversations = 'wtf_conversations';
  static String messages(String conversationId) =>
      '$conversations/$conversationId/messages';
  static String typing(String conversationId) =>
      '$conversations/$conversationId/typing';

  static const callRequests = 'wtf_call_requests';
  static const sessionLogs = 'wtf_session_logs';
}
