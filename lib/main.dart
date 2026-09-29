import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routing/router.dart';
import 'ui/core/theme/app_theme.dart';

void main() {
  runApp(const VgcApp());
}

class VgcApp extends StatefulWidget {
  const VgcApp({super.key});

  @override
  State<VgcApp> createState() => _VgcAppState();
}

class _VgcAppState extends State<VgcApp> {
  // Created once: building it in build() would reset navigation on rebuild.
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VGC Daily Tracker',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
