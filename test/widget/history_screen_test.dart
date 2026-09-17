import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/domain/fee_grids.dart';
import 'package:kzmvola_mobile/domain/models/mode.dart';
import 'package:kzmvola_mobile/domain/mvola_fee_calculator.dart';
import 'package:kzmvola_mobile/features/history/history_screen.dart';
import 'package:kzmvola_mobile/state/history_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness(HistoryNotifier notifier) {
  return ChangeNotifierProvider<HistoryNotifier>.value(
    value: notifier,
    child: const MaterialApp(home: HistoryScreen()),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('affiche un état vide sans entrée', (tester) async {
    final notifier = HistoryNotifier();
    await tester.pumpWidget(_harness(notifier));
    await tester.pumpAndSettle();

    expect(find.text('Aucun calcul enregistré pour l\'instant.'), findsOneWidget);
  });

  testWidgets('affiche une entrée ajoutée et permet de la supprimer', (tester) async {
    final notifier = HistoryNotifier();
    await tester.pumpWidget(_harness(notifier));
    await tester.pumpAndSettle();

    final grid = feeGrids['retrait']!;
    await notifier.add(
      mode: Mode.retrait,
      destination: null,
      result: calculateMvolaFees(grid, 265000),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('265'), findsWidgets);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Aucun calcul enregistré pour l\'instant.'), findsOneWidget);
  });

  testWidgets('vider l\'historique demande confirmation puis supprime tout', (tester) async {
    final notifier = HistoryNotifier();
    await tester.pumpWidget(_harness(notifier));
    await tester.pumpAndSettle();

    final grid = feeGrids['retrait']!;
    await notifier.add(
      mode: Mode.retrait,
      destination: null,
      result: calculateMvolaFees(grid, 265000),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_sweep_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vider'));
    await tester.pumpAndSettle();

    expect(find.text('Aucun calcul enregistré pour l\'instant.'), findsOneWidget);
  });
}
