import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainner_app/app_shared.dart';

class ChatThreadScreen extends ConsumerStatefulWidget {
  const ChatThreadScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

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
    await chat.getMessages(widget.conversationId);
    await chat.markRead(widget.conversationId, user.id);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send([String? text]) async {
    final user = ref.read(authServiceProvider).currentUser;
    final body = (text ?? _ctrl.text).trim();
    if (user == null || body.isEmpty) return;
    await ref.read(chatServiceProvider).sendMessage(
          conversationId: widget.conversationId,
          senderId: user.id,
          senderName: user.name,
          isTrainer: true,
          content: body,
        );
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatServiceProvider);
    final user = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(SeedData.memberName),
            const Text('Member', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFEEF1F6),
              child: RefreshIndicator(
                onRefresh: () => chat.refreshMessages(widget.conversationId),
                child: StreamBuilder<List<Message>>(
                  stream: chat.messagesStream(widget.conversationId),
                  builder: (context, snap) {
                    final messages = snap.data ?? [];
                    if (messages.isEmpty) {
                      return ListView(
                        children: const [
                          EmptyStateWidget(
                            message: 'Start coaching DK',
                            icon: Icons.chat_outlined,
                            primary: AppThemeData.trainerPrimary,
                          ),
                        ],
                      );
                    }
                    return StreamBuilder<String?>(
                      stream: chat.typingStream(widget.conversationId),
                      builder: (context, typingSnap) {
                        return ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: messages.length +
                              (typingSnap.data != null ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (i == messages.length) {
                              return const TypingIndicator(
                                label: 'Member is typing…',
                              );
                            }
                            final m = messages[i];
                            return ChatBubble(
                              message: m,
                              isMemberBubble: !m.isTrainer,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          ChatComposer(
            controller: _ctrl,
            primary: AppThemeData.trainerPrimary,
            hint: 'Reply to member…',
            onSend: () => _send(),
            onChanged: user == null
                ? null
                : (_) => chat.sendTyping(
                      widget.conversationId,
                      user.id,
                      true,
                    ),
          ),
        ],
      ),
    );
  }
}
