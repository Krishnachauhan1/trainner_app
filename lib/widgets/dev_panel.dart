import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/service_providers.dart';
import '../utils/app_logger.dart';
import 'app_theme.dart';

class DevPanelFab extends ConsumerWidget {
  const DevPanelFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.small(
      heroTag: 'dev_panel',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const DevPanelSheet(),
      ),
      child: const Icon(Icons.bug_report_outlined),
    );
  }
}

class DevPanelSheet extends ConsumerWidget {
  const DevPanelSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envConfigProvider);
    final boot = ref.watch(appBootstrapProvider);
    final logs = AppLogger.instance.last20;
    final chatLogs = AppLogger.instance.chatLogs;
    final rtcLogs = AppLogger.instance.rtcLogs;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Material(
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.all(AppThemeData.spacing * 2),
          children: [
            Text('Dev Panel', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('App: ${boot.appName} v${env.appVersion}'),
            Text('Token server: ${env.tokenServerUrl}'),
            Text('Chat relay: ${env.chatRelayUrl}'),
            Text('HMS template: ${env.hmsTemplateId}'),
            const Divider(),
            Text('Last 20 logs', style: Theme.of(context).textTheme.titleLarge),
            ...logs.map((l) => Text(l, style: const TextStyle(fontSize: 11))),
            const Divider(),
            Text('RTC logs', style: Theme.of(context).textTheme.titleLarge),
            ...rtcLogs.map((l) => Text(l, style: const TextStyle(fontSize: 11))),
            const Divider(),
            Text('Chat logs', style: Theme.of(context).textTheme.titleLarge),
            ...chatLogs.map((l) => Text(l, style: const TextStyle(fontSize: 11))),
          ],
        ),
      ),
    );
  }
}
