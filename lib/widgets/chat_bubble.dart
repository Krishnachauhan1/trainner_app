import 'package:flutter/material.dart';

import '../models/message.dart';
import 'app_theme.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMemberBubble,
  });

  final Message message;
  final bool isMemberBubble;

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            message.content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final color = isMemberBubble
        ? const Color(0xFF1769E0)
        : const Color(0xFFE50914);
    final align = isMemberBubble ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: AppThemeData.spacing / 2,
          horizontal: AppThemeData.spacing,
        ),
        padding: const EdgeInsets.all(AppThemeData.spacing * 1.5),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null)
              Image.network(message.imageUrl!, height: 120, fit: BoxFit.cover),
            Text(message.content, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _statusLabel(message.status),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(MessageStatus s) => switch (s) {
        MessageStatus.sending => 'Sending…',
        MessageStatus.sent => 'Sent',
        MessageStatus.read => 'Read',
      };
}
