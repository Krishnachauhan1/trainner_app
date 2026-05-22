import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

class CallRoomScreen extends ConsumerWidget {
  const CallRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callServiceProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<CallState>(
                stream: call.stateStream,
                initialData: call.state,
                builder: (_, snap) {
                  if (snap.data == CallState.reconnecting) {
                    return const LoadingOverlay(message: 'Reconnecting…');
                  }
                  return StreamBuilder<List<CallParticipant>>(
                    stream: call.participantsStream,
                    builder: (_, pSnap) {
                      final peers = pSnap.data ?? [];
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: peers.isEmpty ? 1 : peers.length,
                        itemBuilder: (_, i) {
                          final p = peers.isEmpty
                              ? CallParticipant(
                                  peerId: 'local',
                                  name: SeedData.trainerName,
                                  isLocal: true,
                                )
                              : peers[i];
                          return Center(
                            child: Text(
                              p.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.mic),
                  onPressed: call.toggleMute,
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.videocam),
                  onPressed: call.toggleVideo,
                ),
                IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.call_end),
                  onPressed: () async {
                    final started = call.callStartedAt ?? DateTime.now();
                    await call.leaveRoom();
                    await ref.read(logServiceProvider).createFromCall(
                          memberId: SeedData.memberId,
                          memberName: SeedData.memberName,
                          trainerId: SeedData.trainerId,
                          trainerName: SeedData.trainerName,
                          roomId: ref.read(roomMetaProvider)?.roomId ?? 'room',
                          startedAt: started,
                          endedAt: DateTime.now(),
                          trainerRating: 5,
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Session saved to your logs.'),
                        ),
                      );
                      context.go('/home');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
