import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainner_app/app_shared.dart';

import 'core/router/app_router.dart';

class TrainerApp extends ConsumerWidget {
  const TrainerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme =
        AppThemeData(primary: AppThemeData.trainerPrimary, isTrainer: true);
    return MaterialApp.router(
      title: 'Trainer App',
      theme: theme.build(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
