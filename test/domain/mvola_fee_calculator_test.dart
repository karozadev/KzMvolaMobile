import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/domain/fee_grids.dart';
import 'package:kzmvola_mobile/domain/models/fee_models.dart';
import 'package:kzmvola_mobile/domain/mvola_fee_calculator.dart';

void main() {
  final retrait = feeGrids['retrait']!;
  final transfertMvola = feeGrids['transfert-mvola']!;
  final transfertNonAbonne = feeGrids['transfert-non-abonne']!;
  final allGrids = feeGrids.values.toList();

  group('getFeeForAmount', () {
    test('ne facture rien en dessous du premier palier', () {
      for (final grid in allGrids) {
        expect(getFeeForAmount(grid, 0), 0);
        expect(getFeeForAmount(grid, 99), 0);
      }
    });

    test('applique le frais du palier contenant le montant (retrait)', () {
      expect(getFeeForAmount(retrait, 1000), 100);
      expect(getFeeForAmount(retrait, 10000), 275);
      expect(getFeeForAmount(retrait, 265000), 4700);
      expect(getFeeForAmount(retrait, gridMax(retrait)), 100000);
    });

    test('applique le barème « transfert vers un abonné MVola »', () {
      expect(getFeeForAmount(transfertMvola, 5000), 70);
      expect(getFeeForAmount(transfertMvola, 25000), 250);
      expect(getFeeForAmount(transfertMvola, 250000), 1900);
      expect(getFeeForAmount(transfertMvola, 500000), 1900);
      expect(getFeeForAmount(transfertMvola, 1000000), 3200);
      expect(getFeeForAmount(transfertMvola, 20000000), 31300);
    });

    test('applique le barème « transfert vers un non-abonné »', () {
      expect(getFeeForAmount(transfertNonAbonne, 10000), 1400);
      expect(getFeeForAmount(transfertNonAbonne, 250000), 10000);
      expect(getFeeForAmount(transfertNonAbonne, 5000000), 60000);
    });

    test('renvoie null au-delà du plafond de la grille', () {
      expect(getFeeForAmount(retrait, gridMax(retrait) + 1), isNull);
      expect(getFeeForAmount(transfertNonAbonne, 5000001), isNull);
    });

    test('est cohérent aux bornes de chaque palier de chaque grille', () {
      for (final grid in allGrids) {
        for (final tier in grid.tiers) {
          expect(getFeeForAmount(grid, tier.min), tier.fee);
          expect(getFeeForAmount(grid, tier.max), tier.fee);
        }
      }
    });
  });

  group('grilles tarifaires', () {
    test('sont continues, ordonnées et à sommets multiples de 1 000 Ar', () {
      for (final grid in allGrids) {
        expect(gridMin(grid), 100);
        for (var i = 0; i < grid.tiers.length; i++) {
          final tier = grid.tiers[i];
          expect(tier.max, greaterThan(tier.min));
          expect(tier.max % 1000, 0);
          if (i > 0) expect(tier.min, grid.tiers[i - 1].max + 1);
        }
      }
    });
  });

  group('calculateDirect', () {
    test('décrit une opération réalisable en une transaction', () {
      final result = calculateDirect(retrait, 265000);
      expect(result.possible, true);
      expect(result.amount, 265000);
      expect(result.fee, 4700);
    });

    test('marque une opération au-dessus du plafond comme impossible', () {
      final result = calculateDirect(transfertNonAbonne, 8000000);
      expect(result.possible, false);
      expect(result.amount, 8000000);
      expect(result.fee, isNull);
    });
  });

  group('calculateOptimizedSplit', () {
    test('renvoie une décomposition vide pour un montant nul ou négatif', () {
      final result = calculateOptimizedSplit(retrait, 0);
      expect(result.operations, isEmpty);
      expect(result.totalFee, 0);
      expect(result.totalAmount, 0);
    });

    test('ne fractionne pas quand une opération unique est déjà optimale', () {
      final result = calculateOptimizedSplit(retrait, 3000);
      expect(result.operations.length, 1);
      expect(result.operations.first.amount, 3000);
      expect(result.operations.first.fee, 150);
      expect(result.totalFee, 150);
    });

    test('garde des sous-totaux cohérents sur toutes les grilles', () {
      for (final grid in allGrids) {
        for (final amount in [7500, 42000, 265000, 1234000, 4999999]) {
          final result = calculateOptimizedSplit(grid, amount);
          final feeSum = result.operations.fold(0, (s, op) => s + op.fee);
          final amountSum = result.operations.fold(0, (s, op) => s + op.amount);
          expect(feeSum, result.totalFee);
          expect(amountSum, result.totalAmount);
          expect(result.totalAmount, amount);
        }
      }
    });

    test('chaque frais unitaire correspond bien à la grille utilisée', () {
      for (final op in calculateOptimizedSplit(transfertMvola, 1780000).operations) {
        expect(op.fee, getFeeForAmount(transfertMvola, op.amount));
      }
    });

    test("n'émet jamais d'opération sous le minimum de 100 Ar", () {
      for (final grid in allGrids) {
        for (final amount in [100150, 250099, 1000050]) {
          for (final op in calculateOptimizedSplit(grid, amount).operations) {
            expect(op.amount, greaterThanOrEqualTo(gridMin(grid)));
          }
        }
      }
    });
  });

  group('calculateMvolaFees', () {
    test("l'optimisation ne coûte jamais plus cher que l'opération directe", () {
      const largeSamples = [500000, 999999, 1500000, 2400001, 4999999, 12345678, 19999999];
      for (final FeeGrid grid in allGrids) {
        final amounts = <int>[];
        for (var a = 500; a <= 320000; a += 1111) {
          amounts.add(a);
        }
        for (final a in largeSamples) {
          if (a <= gridMax(grid)) amounts.add(a);
        }

        for (final amount in amounts) {
          final result = calculateMvolaFees(grid, amount);
          if (result.direct.possible) {
            expect(result.optimized.totalFee, lessThanOrEqualTo(result.direct.fee ?? 0));
            expect(
              result.savings,
              ((result.direct.fee ?? 0) - result.optimized.totalFee).clamp(0, 1 << 62),
            );
          }
          expect(result.savings, greaterThanOrEqualTo(0));
        }
      }
    });

    test('expose une économie réelle sur un retrait de 265 000 Ar', () {
      final result = calculateMvolaFees(retrait, 265000);
      expect(result.savings, greaterThan(0));
      expect(result.savings, (result.direct.fee ?? 0) - result.optimized.totalFee);
    });

    test('trouve un fractionnement gagnant pour un transfert « non-abonné » de 300 000 Ar', () {
      // 300 000 direct = 15 000 ; 250 000 (10 000) + 50 000 (3 800) = 13 800.
      final result = calculateMvolaFees(transfertNonAbonne, 300000);
      expect(result.direct.fee, 15000);
      expect(result.optimized.totalFee, lessThan(15000));
      expect(result.savings, greaterThan(0));
    });

    test('au-delà du plafond : opération directe impossible, aucune économie', () {
      final result = calculateMvolaFees(transfertNonAbonne, 8000000);
      expect(result.direct.possible, false);
      expect(result.savings, 0);
    });
  });
}
