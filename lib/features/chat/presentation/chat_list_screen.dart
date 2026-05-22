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
            const Text('Chats'),
            Text(
              'Member: ${SeedData.memberName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: !_ready
          ? const LoadingOverlay(message: 'Connecting to Firebase…')
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
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final c = list[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppThemeData.trainerPrimary,
                              child: Text(
                                c.title.isNotEmpty ? c.title[0] : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(c.title),
                            subtitle: Text(
                              c.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: c.unreadCount > 0
                                ? CircleAvatar(
                                    radius: 10,
                                    backgroundColor:
                                        AppThemeData.trainerPrimary,
                                    child: Text(
                                      '${c.unreadCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                : Text(
                                    AppDateUtils.formatChatTime(
                                      c.lastMessageAt,
                                    ),
                                  ),
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
