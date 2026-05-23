import 'package:flutter/material.dart';

import '../models/message.dart';
import '../utils/date_utils.dart';
import 'app_theme.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.title,
    required this.preview,
    required this.time,
    required this.onTap,
    required this.primary,
    this.unreadCount = 0,
    this.highlight = false,
    this.badgeLabel,
  });

  final String title;
  final String preview;
  final DateTime time;
  final VoidCallback onTap;
  final Color primary;
  final int unreadCount;
  final bool highlight;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: highlight ? primary.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(AppThemeData.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppThemeData.radius),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      highlight ? primary : Colors.grey.shade200,
                  child: Text(
                    title.isNotEmpty ? title[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: highlight ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            AppDateUtils.formatChatTime(time),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: unreadCount > 0
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade600,
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                          if (badgeLabel != null) ...[
                            const SizedBox(width: 8),
                            _Badge(label: badgeLabel!, color: primary),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: primary,
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
