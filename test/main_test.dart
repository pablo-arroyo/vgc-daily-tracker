import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/main.dart';

void main() {
  testWidgets('VgcApp builds a MaterialApp titled VGC Daily Tracker', (
    tester,
  ) async {
    await tester.pumpWidget(const VgcApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'VGC Daily Tracker');
  });
}
