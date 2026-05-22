import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

import '../../../core/firebase_startup.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureChat());
  }

  Future<void> _ensureChat() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;
    await ref.read(chatServiceProvider).connect(user.id, true);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseOk = ref.watch(firebaseConnectedProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Trainer Home')),
      floatingActionButton: const DevPanelFab(),
      body: Column(
        children: [
          if (!firebaseOk) const FirestoreOfflineBanner(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _Tile('Members', Icons.people, () => context.push('/members')),
                  _Tile('Chats', Icons.chat, () => context.push('/chats')),
                  _Tile('Requests', Icons.inbox, () => context.push('/requests')),
                  _Tile(
                    'Sessions',
                    Icons.history,
                    () => context.push('/sessions'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppThemeData.trainerPrimary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
