import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

import '../../../core/firebase_startup.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;
    final chat = ref.read(chatServiceProvider);
    await chat.connect(user.id, true);
    await chat.getConversations();
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatServiceProvider);
    final firebaseOk = ref.watch(firebaseConnectedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Messages'),
            Text(
              'Member: ${SeedData.memberName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: !_ready
          ? const LoadingOverlay(
              message: 'Connecting…',
              color: AppThemeData.trainerPrimary,
            )
          : Column(
              children: [
                if (!firebaseOk) const FirestoreOfflineBanner(),
                Expanded(
                  child: StreamBuilder<List<ConversationSummary>>(
                    stream: chat.conversationsStream,
                    initialData: _memberFallback(),
                    builder: (context, snap) {
                      var list = snap.data ?? [];
                      if (list.isEmpty) list = _memberFallback();
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final c = list[i];
                          return ConversationTile(
                            title: c.title,
                            preview: c.lastMessage,
                            time: c.lastMessageAt,
                            primary: AppThemeData.trainerPrimary,
                            unreadCount: c.unreadCount,
                            highlight: true,
                            onTap: () => context.push('/chat/${c.id}'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  List<ConversationSummary> _memberFallback() {
    final convId = SeedData.conversationIdFor(SeedData.trainerId);
    return [
      ConversationSummary(
        id: convId,
        title: SeedData.memberName,
        lastMessage: 'Tap to chat with member',
        lastMessageAt: DateTime.now(),
        unreadCount: 0,
        isTrainer: true,
      ),
    ];
  }
}
