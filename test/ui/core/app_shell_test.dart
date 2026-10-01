import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/config/format_config.dart';
import 'package:vgc_daily_tracker/routing/router.dart';
import 'package:vgc_daily_tracker/routing/routes.dart';
import 'package:vgc_daily_tracker/ui/core/app_shell.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';

import '../../../testing/app.dart';

void main() {
  late GoRouter router;

  setUp(() => router = createRouter());
  tearDown(() => router.dispose());

  Future<void> pumpShell(WidgetTester tester, {FormatConfig? format}) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: providersFake(format: format),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the tracker header', (tester) async {
    await pumpShell(tester);

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text('🎮 VGC Daily Practice Tracker'), findsOneWidget);
    expect(
      find.text('Reg M-C · at least 1 game a day, review every one'),
      findsOneWidget,
    );
  });

  testWidgets('the header names the configured format', (tester) async {
    await pumpShell(
      tester,
      format: const FormatConfig(label: 'Reg Z', sampleTeams: []),
    );

    expect(
      find.text('Reg Z · at least 1 game a day, review every one'),
      findsOneWidget,
    );
  });

  testWidgets('highlights the tab of the current route, even on deep links', (
    tester,
  ) async {
    await pumpShell(tester);
    NavigationBar bar() => tester.widget(find.byType(NavigationBar));
    expect(bar().selectedIndex, 0);

    router.go(Routes.progress);
    await tester.pumpAndSettle();

    expect(bar().selectedIndex, 3);
  });

  testWidgets('caps the content width at 640 on wide screens', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpShell(tester);

    expect(tester.getSize(find.byType(RoutineScreen)).width, 640);
  });
}
