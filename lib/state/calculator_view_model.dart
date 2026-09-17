import 'package:flutter/foundation.dart';

import '../domain/fee_grids.dart';
import '../domain/format.dart';
import '../domain/models/calculation_result.dart';
import '../domain/models/mode.dart';
import '../domain/mvola_fee_calculator.dart';

/// Gère le mode d'opération (retrait / transfert), la destination et la
/// saisie du montant, puis déclenche le calcul d'optimisation MVola
/// correspondant. Portage de `useMvolaCalculator` (web), sans la synchro
/// d'état dans l'URL qui n'a pas d'équivalent mobile pertinent.
class CalculatorViewModel extends ChangeNotifier {
  Mode _mode = Mode.retrait;
  TransferDestination _destination = TransferDestination.mvola;
  int _amount = 0;
  String _rawInput = '';

  Mode get mode => _mode;
  TransferDestination get destination => _destination;
  int get amount => _amount;
  String get rawInput => _rawInput;

  OperationConfig get config => resolveOperation(_mode, _destination);
  int get maxAmount => gridMax(config.grid);
  bool get isOverLimit => _amount > maxAmount;

  CalculationResult? get result {
    if (_amount <= 0 || isOverLimit) return null;
    return calculateMvolaFees(config.grid, _amount);
  }

  void setMode(Mode next) {
    if (_mode == next) return;
    _mode = next;
    notifyListeners();
  }

  void setDestination(TransferDestination next) {
    if (_destination == next) return;
    _destination = next;
    notifyListeners();
  }

  void onAmountChanged(String raw) {
    final parsed = parseAmountInput(raw);
    _amount = parsed;
    _rawInput = parsed > 0 ? formatNumber(parsed) : '';
    notifyListeners();
  }

  void reset() {
    _amount = 0;
    _rawInput = '';
    notifyListeners();
  }
}
