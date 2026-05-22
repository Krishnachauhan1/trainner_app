import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

class CallPreviewScreen extends ConsumerStatefulWidget {
  const CallPreviewScreen({super.key});

  @override
  ConsumerState<CallPreviewScreen> createState() => _CallPreviewScreenState();
}

class _CallPreviewScreenState extends ConsumerState<CallPreviewScreen> {
  bool _loading = false;

  Future<void> _join() async {
    setState(() => _loading = true);
    try {
      final user = ref.read(authServiceProvider).currentUser!;
      final meta = ref.read(roomMetaProvider)!;
      final call = ref.read(callServiceProvider);
      await call.requestPermissions();
      final token = await call.fetchAuthToken(
        userId: user.id,
        role: UserRole.trainer,
        roomId: meta.roomId,
      );
      await call.startPreview(userName: user.name, authToken: token);
      await call.joinRoom(userName: user.name, authToken: token, meta: meta);
      if (mounted) context.push('/call/live');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-join')),
      body: _loading
          ? const LoadingOverlay()
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ready to join? Check mic and camera.',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _join,
                    child: const Text('Join as trainer'),
                  ),
                ],
              ),
            ),
    );
  }
}
