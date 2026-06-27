import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/app/theme/app_theme.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/feature_flags/feature_flag_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/controllers/auth_controller.dart';

class LexMasteryApp extends ConsumerStatefulWidget {
  const LexMasteryApp({super.key});

  @override
  ConsumerState<LexMasteryApp> createState() => _LexMasteryAppState();
}

class _LexMasteryAppState extends ConsumerState<LexMasteryApp> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(authControllerProvider.notifier).restoreSession();
      await ref.read(featureFlagControllerProvider.notifier).load();
      await ref.read(syncControllerProvider.notifier).hydrate();
      await ref.read(analyticsControllerProvider.notifier).hydrate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'LexMastery AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
