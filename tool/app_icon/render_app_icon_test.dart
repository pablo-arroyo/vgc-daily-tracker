// Renders the app icon sources into assets/icon/. Not part of `flutter test`
// (it lives outside test/); run it after changing the design:
//
//   flutter test tool/app_icon/render_app_icon_test.dart
//   dart run flutter_launcher_icons
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _indigo = Color(0xFF5B5BD6); // the app's light-theme accent
const _deepIndigo = Color(0xFF3F3FB0);
const _page = Color(0xFFF7F7FB); // the app's light background

enum IconShape {
  /// Edge-to-edge indigo square: iOS, web and Windows round or frame it.
  fullBleed,

  /// macOS: a rounded indigo square with Apple's transparent margin.
  macos,

  /// Android adaptive foreground: the art alone, inside the safe zone.
  foreground,
}

/// A calendar page with a check mark: "a game a day, reviewed".
class AppIconPainter extends CustomPainter {
  const AppIconPainter(this.shape);

  final IconShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    switch (shape) {
      case IconShape.fullBleed:
        canvas.drawRect(Offset.zero & size, Paint()..color = _indigo);
        _art(canvas, s, scale: 0.62);
      case IconShape.macos:
        // Apple's template: an 824 px rounded square centered in 1024.
        final tile = Rect.fromCenter(
          center: size.center(Offset.zero),
          width: s * 824 / 1024,
          height: s * 824 / 1024,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(tile, Radius.circular(s * 185 / 1024)),
          Paint()..color = _indigo,
        );
        _art(canvas, s, scale: 0.50);
      case IconShape.foreground:
        // Adaptive icons may crop to the middle 66 %.
        _art(canvas, s, scale: 0.44);
    }
  }

  void _art(Canvas canvas, double s, {required double scale}) {
    final w = s * scale;
    final page = Rect.fromCenter(
      center: Offset(s / 2, s / 2 + w * 0.04),
      width: w,
      height: w * 0.92,
    );
    final radius = Radius.circular(w * 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(page, radius),
      Paint()..color = _page,
    );
    // The binding band across the top of the page.
    final band = Rect.fromLTWH(page.left, page.top, page.width, w * 0.24);
    canvas.drawRRect(
      RRect.fromRectAndCorners(band, topLeft: radius, topRight: radius),
      Paint()..color = _deepIndigo,
    );
    // Two rings poking above the page.
    final ring = Paint()..color = _page;
    for (final x in [0.3, 0.7]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(page.left + page.width * x, page.top),
            width: w * 0.09,
            height: w * 0.22,
          ),
          Radius.circular(w * 0.045),
        ),
        ring,
      );
    }
    // The check mark.
    final check = Path()
      ..moveTo(page.left + w * 0.26, page.top + w * 0.56)
      ..lineTo(page.left + w * 0.44, page.top + w * 0.72)
      ..lineTo(page.left + w * 0.76, page.top + w * 0.38);
    canvas.drawPath(
      check,
      Paint()
        ..color = _indigo
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.11
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(AppIconPainter oldDelegate) => oldDelegate.shape != shape;
}

void main() {
  const size = 1024.0;
  final files = {
    IconShape.fullBleed: 'assets/icon/app_icon.png',
    IconShape.macos: 'assets/icon/app_icon_macos.png',
    IconShape.foreground: 'assets/icon/app_icon_foreground.png',
  };

  for (final MapEntry(key: shape, value: path) in files.entries) {
    testWidgets('renders $path', (tester) async {
      tester.view.physicalSize = const Size(size, size);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        Center(
          child: RepaintBoundary(
            key: boundary,
            child: CustomPaint(
              size: const Size(size, size),
              painter: AppIconPainter(shape),
            ),
          ),
        ),
      );

      await tester.runAsync(() async {
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await render.toImage();
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File(path).writeAsBytesSync(png!.buffer.asUint8List());
      });

      expect(File(path).existsSync(), isTrue);
    });
  }
}
