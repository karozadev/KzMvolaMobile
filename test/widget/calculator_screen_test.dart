import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/features/calculator/calculator_screen.dart';
import 'package:kzmvola_mobile/state/history_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness() {
  return MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => HistoryNotifier())],
    child: const MaterialApp(home: CalculatorScreen()),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('affiche les cartes de résultat et l\'économie pour un montant valide', (
    tester,
  ) async {
    // Le contenu de l'écran dépasse la hauteur d'un viewport de test par
    // défaut ; on agrandit la surface pour que le ListView construise aussi
    // la bannière d'économie, hors écran sinon.
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_harness());

    await tester.enterText(find.byType(TextField), '265000');
    await tester.pump();

    expect(find.text('Retrait direct'), findsOneWidget);
    expect(find.text('Retrait fractionné'), findsOneWidget);
    expect(find.textContaining('économisés'), findsOneWidget);
  });

  testWidgets('passer en mode Transfert affiche les chips de destination et change le libellé', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());

    await tester.tap(find.text('Transfert'));
    await tester.pump();

    expect(find.text('Vers un abonné MVola'), findsOneWidget);
    expect(find.text('Montant total à transférer'), findsOneWidget);
  });

  testWidgets('un montant au-delà du plafond affiche une erreur et aucune carte', (tester) async {
    await tester.pumpWidget(_harness());

    await tester.enterText(find.byType(TextField), '99999999');
    await tester.pump();

    expect(find.textContaining('Plafond dépassé'), findsOneWidget);
    expect(find.text('Retrait direct'), findsNothing);
  });
}
