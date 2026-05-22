import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainner_app/app_shared.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  SessionLogFilter _filter = SessionLogFilter.all;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    ref.read(logServiceProvider).getLogs(
          trainerId: SeedData.trainerId,
          filter: _filter,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SegmentedButton<SessionLogFilter>(
            segments: const [
              ButtonSegment(value: SessionLogFilter.all, label: Text('All')),
              ButtonSegment(
                value: SessionLogFilter.last7Days,
                label: Text('7 days'),
              ),
              ButtonSegment(
                value: SessionLogFilter.thisMonth,
                label: Text('Month'),
              ),
            ],
            selected: {_filter},
            onSelectionChanged: (s) {
              setState(() => _filter = s.first);
              _load();
            },
          ),
        ),
      ),
      body: StreamBuilder<List<SessionLog>>(
        stream: ref.watch(logServiceProvider).logsStream,
        builder: (_, snap) {
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const EmptyStateWidget(message: 'No sessions logged.');
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final l = list[i];
              return ListTile(
                title: Text('${l.memberName} • ${l.durationSeconds ~/ 60} min'),
                subtitle: Text(AppDateUtils.formatSlot(l.startedAt)),
              );
            },
          );
        },
      ),
    );
  }
}
