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
      appBar: AppBar(title: const Text('Trainer Console')),
      floatingActionButton: const DevPanelFab(),
      body: Column(
        children: [
          if (!firebaseOk) const FirestoreOfflineBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                HomeWelcomeHeader(
                  title: SeedData.trainerName,
                  subtitle: 'Manage members, chats & calls',
                  primary: AppThemeData.trainerPrimary,
                  icon: Icons.sports_martial_arts_rounded,
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  children: [
                    _DashboardTile(
                      label: 'Members',
                      icon: Icons.people_rounded,
                      onTap: () => context.push('/members'),
                    ),
                    _DashboardTile(
                      label: 'Chats',
                      icon: Icons.chat_rounded,
                      onTap: () => context.push('/chats'),
                    ),
                    _DashboardTile(
                      label: 'Requests',
                      icon: Icons.inbox_rounded,
                      onTap: () => context.push('/requests'),
                    ),
                    _DashboardTile(
                      label: 'Sessions',
                      icon: Icons.history_rounded,
                      onTap: () => context.push('/sessions'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppThemeData.trainerPrimary,
                      AppThemeData.trainerPrimary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
