import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    await ref.read(authServiceProvider).loginTrainer();
    await ref.read(chatServiceProvider).connect(SeedData.trainerId, true);
    if (mounted) context.go('/home');
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports, size: 72, color: AppThemeData.trainerPrimary),
              const SizedBox(height: 24),
              Text(
                'Trainer Console',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                SeedData.trainerName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              if (_loading)
                const LoadingOverlay()
              else
                FilledButton(
                  onPressed: _login,
                  child: const Text('Mock Login'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
