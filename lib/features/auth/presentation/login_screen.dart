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
            children: [
              const Spacer(),
              HomeWelcomeHeader(
                title: 'Trainer Console',
                subtitle: SeedData.trainerName,
                primary: AppThemeData.trainerPrimary,
                icon: Icons.sports_rounded,
              ),
              const SizedBox(height: 32),
              Text(
                'Approve calls, chat with members, and review session history.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const Spacer(),
              if (_loading)
                const LoadingOverlay(
                  color: AppThemeData.trainerPrimary,
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _login,
                    child: const Text('Continue as Trainer'),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
