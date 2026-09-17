import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/data/history_entry.dart';
import 'package:kzmvola_mobile/data/history_repository.dart';
import 'package:kzmvola_mobile/domain/models/mode.dart';
import 'package:kzmvola_mobile/domain/models/operation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  HistoryEntry buildEntry(String id) => HistoryEntry(
    id: id,
    createdAt: DateTime(2026, 1, 1),
    mode: Mode.retrait,
    destination: null,
    amount: 265000,
    directPossible: true,
    directFee: 4700,
    optimizedFee: 3000,
    operations: const [Operation(amount: 265000, fee: 3000)],
    savings: 1700,
  );

  test('renvoie une liste vide quand rien n\'est stocké', () async {
    final repo = HistoryRepository();
    expect(await repo.loadAll(), isEmpty);
  });

  test('round-trip : sauvegarde puis relecture préserve les entrées', () async {
    final repo = HistoryRepository();
    final entries = [buildEntry('1'), buildEntry('2')];

    await repo.saveAll(entries);
    final loaded = await repo.loadAll();

    expect(loaded.length, 2);
    expect(loaded.map((e) => e.id), ['1', '2']);
    expect(loaded.first.amount, 265000);
    expect(loaded.first.savings, 1700);
    expect(loaded.first.operations.first.fee, 3000);
  });

  test('sauvegarder une liste vide efface le stockage', () async {
    final repo = HistoryRepository();
    await repo.saveAll([buildEntry('1')]);
    await repo.saveAll([]);

    expect(await repo.loadAll(), isEmpty);
  });
}
