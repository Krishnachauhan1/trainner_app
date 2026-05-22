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

  Future<void> _send() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null || _ctrl.text.trim().isEmpty) return;
    await ref.read(chatServiceProvider).sendMessage(
          conversationId: widget.conversationId,
          senderId: user.id,
          senderName: user.name,
          isTrainer: true,
          content: _ctrl.text.trim(),
        );
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(SeedData.memberName)),
      body: Column(
        children: [
          Expanded(
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
                          message: 'No messages yet. Start the conversation.',
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    controller: _scroll,
                    itemCount: messages.length,
                    itemBuilder: (_, i) => ChatBubble(
                      message: messages[i],
                      isMemberBubble: !messages[i].isTrainer,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Reply…',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
