import 'package:flutter/material.dart';

import '../models/message.dart';
import 'app_theme.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMemberBubble,
    this.memberColor = AppThemeData.guruPrimary,
    this.trainerColor = AppThemeData.trainerPrimary,
  });

  final Message message;
  final bool isMemberBubble;
  final Color memberColor;
  final Color trainerColor;

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final color = isMemberBubble ? memberColor : trainerColor;
    final align =
        isMemberBubble ? Alignment.centerRight : Alignment.centerLeft;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMemberBubble ? 16 : 4),
      bottomRight: Radius.circular(isMemberBubble ? 4 : 16),
    );

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: AppThemeData.spacing * 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.imageUrl!,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _statusLabel(message.status),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _statusIcon(message.status),
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(MessageStatus s) => switch (s) {
        MessageStatus.sending => 'Sending',
        MessageStatus.sent => 'Sent',
        MessageStatus.read => 'Read',
      };

  IconData _statusIcon(MessageStatus s) => switch (s) {
        MessageStatus.sending => Icons.schedule,
        MessageStatus.sent => Icons.check,
        MessageStatus.read => Icons.done_all,
      };
}
