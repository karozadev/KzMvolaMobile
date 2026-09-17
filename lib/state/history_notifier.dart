import 'package:flutter/foundation.dart';

import '../data/history_entry.dart';
import '../data/history_repository.dart';
import '../domain/models/calculation_result.dart';
import '../domain/models/mode.dart';

class HistoryNotifier extends ChangeNotifier {
  final HistoryRepository _repository;
  List<HistoryEntry> _entries = [];
  bool _loaded = false;

  HistoryNotifier({HistoryRepository? repository})
    : _repository = repository ?? HistoryRepository() {
    _load();
  }

  List<HistoryEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  Future<void> _load() async {
    _entries = await _repository.loadAll();
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _loaded = true;
    notifyListeners();
  }

  Future<void> add({
    required Mode mode,
    required TransferDestination? destination,
    required CalculationResult result,
  }) async {
    final entry = HistoryEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      mode: mode,
      destination: destination,
      amount: result.amount,
      directPossible: result.direct.possible,
      directFee: result.direct.fee ?? 0,
      optimizedFee: result.optimized.totalFee,
      operations: result.optimized.operations,
      savings: result.savings,
    );
    _entries = [entry, ..._entries];
    notifyListeners();
    await _repository.saveAll(_entries);
  }

  Future<void> removeById(String id) async {
    _entries = _entries.where((e) => e.id != id).toList();
    notifyListeners();
    await _repository.saveAll(_entries);
  }

  Future<void> clear() async {
    _entries = [];
    notifyListeners();
    await _repository.saveAll(_entries);
  }
}
