import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/domain/fee_grids.dart';
import 'package:kzmvola_mobile/domain/format.dart';
import 'package:kzmvola_mobile/domain/models/mode.dart';
import 'package:kzmvola_mobile/domain/mvola_fee_calculator.dart';
import 'package:kzmvola_mobile/state/calculator_view_model.dart';

void main() {
  final retraitMax = gridMax(feeGrids['retrait']!);

  group('CalculatorViewModel', () {
    test("part d'un état vide, en mode retrait", () {
      final vm = CalculatorViewModel();
      expect(vm.mode, Mode.retrait);
      expect(vm.rawInput, '');
      expect(vm.amount, 0);
      expect(vm.result, isNull);
      expect(vm.maxAmount, retraitMax);
    });

    test('normalise la saisie et calcule le résultat', () {
      final vm = CalculatorViewModel();
      vm.onAmountChanged('265000');

      expect(vm.rawInput, formatNumber(265000));
      expect(vm.amount, 265000);
      expect(vm.result?.direct.fee, 4700);
      expect(vm.result!.savings, greaterThan(0));
    });

    test('recalcule avec le bon barème après changement de mode, sans réinitialiser le montant', () {
      final vm = CalculatorViewModel();
      vm.onAmountChanged('25000');
      expect(vm.result?.direct.fee, 650); // retrait

      vm.setMode(Mode.transfert);
      expect(vm.mode, Mode.transfert);
      expect(vm.amount, 25000);
      expect(vm.result?.direct.fee, 250); // transfert vers abonné MVola
      expect(vm.config.wording.itemNoun, 'Envoi');
    });

    test('change de destination de transfert et de plafond', () {
      final vm = CalculatorViewModel();
      vm.setMode(Mode.transfert);
      vm.setDestination(TransferDestination.nonAbonne);

      expect(vm.destination, TransferDestination.nonAbonne);
      expect(vm.maxAmount, 5000000);
    });

    test('signale un dépassement de plafond et supprime le résultat', () {
      final vm = CalculatorViewModel();
      vm.onAmountChanged('${retraitMax + 1}');

      expect(vm.isOverLimit, true);
      expect(vm.result, isNull);
    });

    test('remet à zéro le montant via reset', () {
      final vm = CalculatorViewModel();
      vm.onAmountChanged('42000');
      vm.reset();

      expect(vm.rawInput, '');
      expect(vm.amount, 0);
      expect(vm.result, isNull);
    });
  });
}
