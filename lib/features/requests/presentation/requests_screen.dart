import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(schedulerServiceProvider).getRequests(trainerId: SeedData.trainerId);
  }

  Future<void> _approve(CallRequest r) async {
    final env = ref.read(envConfigProvider);
    final updated = await ref.read(schedulerServiceProvider).approve(
          r.id,
          templateId: env.hmsTemplateId,
        );
    ref.read(roomMetaProvider.notifier).state = RoomMeta(
      roomId: updated.roomId!,
      templateId: env.hmsTemplateId,
      memberId: r.memberId,
      trainerId: r.trainerId,
      memberRole: UserRole.member,
      scheduledAt: r.slotStart,
      callRequestId: r.id,
    );
  }

  Future<void> _decline(CallRequest r) async {
    final reasonCtrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline reason'),
        content: TextField(controller: reasonCtrl, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, reasonCtrl.text),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
    if (reason == null) return;
    await ref.read(schedulerServiceProvider).decline(r.id, reason);
    await ref.read(chatServiceProvider).sendSystemMessage(
          SeedData.conversationIdFor(r.trainerId),
          'Call request declined. Reason: $reason.',
        );
  }

  @override
  Widget build(BuildContext context) {
    final scheduler = ref.watch(schedulerServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body: StreamBuilder<List<CallRequest>>(
        stream: scheduler.requestsStream,
        builder: (_, snap) {
          final list = (snap.data ?? [])
              .where((r) => r.trainerId == SeedData.trainerId)
              .toList();
          if (list.isEmpty) {
            return const EmptyStateWidget(message: 'No pending requests.');
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final r = list[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('${r.memberName} • ${AppDateUtils.formatSlot(r.slotStart)}'),
                  subtitle: Text(r.note.isEmpty ? 'No note' : r.note),
                  trailing: switch (r.status) {
                    CallRequestStatus.pending => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _approve(r),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _decline(r),
                          ),
                        ],
                      ),
                    CallRequestStatus.approved => TextButton(
                        onPressed: () => context.push('/call/preview'),
                        child: const Text('Join'),
                      ),
                    CallRequestStatus.declined => const Text('Declined'),
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
