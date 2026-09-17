// Outil de génération des images sources de l'icône de l'app (pas un test
// de comportement). Exécuté une fois via `flutter test` pour rasteriser le
// logo (`AppLogo`) en PNG haute résolution, puis consommé par
// `flutter_launcher_icons` pour produire les icônes Android/iOS.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/shared/widgets/app_logo.dart';
import 'package:kzmvola_mobile/theme/app_theme.dart';

const _canvasSize = 1024.0;

/// `flutter test` remplace toutes les polices par une police de test factice
/// (glyphes rendus en simples carrés). Sans ça, l'icône Material (tirelire)
/// s'afficherait comme un carré vide. On recharge la vraie police
/// MaterialIcons embarquée par le SDK pour obtenir le vrai glyphe.
Future<void> _loadRealMaterialIconsFont() async {
  final fontData = await rootBundle.load('fonts/MaterialIcons-Regular.otf');
  final fontLoader = FontLoader('MaterialIcons')..addFont(Future.value(fontData));
  await fontLoader.load();
}

Future<void> _captureAndSave(WidgetTester tester, GlobalKey key, String path) async {
  // `toImage()` schedules du vrai travail de rasterisation qui ne progresse
  // pas sous l'horloge simulée de `testWidgets` : il faut l'exécuter via
  // `runAsync`, sans quoi le futur ne se résout jamais (blocage silencieux).
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File(path).writeAsBytes(bytes!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(_loadRealMaterialIconsFont);

  testWidgets('génère assets/icon/icon.png (fond dégradé + tirelire)', (tester) async {
    // La surface de test par défaut (800x600) tronquerait le canevas de
    // 1024x1024 : le SizedBox se ferait resserrer par les contraintes du
    // viewport. On agrandit la surface avant de pomper le widget.
    tester.view.physicalSize = const Size(_canvasSize, _canvasSize);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: const SizedBox(
                width: _canvasSize,
                height: _canvasSize,
                child: AppLogo(size: _canvasSize),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _captureAndSave(tester, key, 'assets/icon/icon.png');
  });

  testWidgets('génère assets/icon/icon_foreground.png (tirelire seule, fond transparent)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(_canvasSize, _canvasSize);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: const SizedBox(
                width: _canvasSize,
                height: _canvasSize,
                child: Center(
                  child: Icon(Icons.savings_rounded, color: Colors.white, size: _canvasSize * 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _captureAndSave(tester, key, 'assets/icon/icon_foreground.png');
  });
}
