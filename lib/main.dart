import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'config/dependencies.dart';
import 'routing/router.dart';
import 'ui/core/theme/app_theme.dart';

void main() {
  runApp(VgcApp(providers: providersRemote()));
}

class VgcApp extends StatefulWidget {
  const VgcApp({required this.providers, super.key});

  /// App dependencies: [providersRemote] in production, fakes in tests.
  final List<SingleChildWidget> providers;

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
    return MultiProvider(
      providers: widget.providers,
      child: MaterialApp.router(
        title: 'VGC Daily Tracker',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
