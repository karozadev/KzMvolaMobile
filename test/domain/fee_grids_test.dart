import 'package:flutter_test/flutter_test.dart';
import 'package:kzmvola_mobile/domain/fee_grids.dart';
import 'package:kzmvola_mobile/domain/models/mode.dart';
import 'package:kzmvola_mobile/domain/mvola_fee_calculator.dart';

void main() {
  group('resolveOperation', () {
    test('renvoie la grille retrait et les formulations de retrait', () {
      final config = resolveOperation(Mode.retrait, TransferDestination.mvola);
      expect(config.grid.id, 'retrait');
      expect(config.wording.amountLabel.toLowerCase(), contains('retirer'));
      expect(config.wording.itemNoun, 'Retrait');
      expect(gridMax(config.grid), 20000000);
    });

    test('sélectionne la grille de transfert selon la destination', () {
      expect(
        resolveOperation(Mode.transfert, TransferDestination.mvola).grid.id,
        'transfert-mvola',
      );
      expect(
        resolveOperation(Mode.transfert, TransferDestination.autreOperateur).grid.id,
        'transfert-autre-operateur',
      );
      expect(
        resolveOperation(Mode.transfert, TransferDestination.nonAbonne).grid.id,
        'transfert-non-abonne',
      );
    });

    test('utilise les formulations de transfert quel que soit le destinataire', () {
      for (final destination in TransferDestination.values) {
        final config = resolveOperation(Mode.transfert, destination);
        expect(config.wording.amountLabel.toLowerCase(), contains('transférer'));
        expect(config.wording.itemNoun, 'Envoi');
        expect(config.gridCaption, contains(destinationLabels[destination]));
      }
    });

    test('plafonne les transferts hors abonné MVola à 5 000 000 Ar', () {
      expect(
        gridMax(resolveOperation(Mode.transfert, TransferDestination.autreOperateur).grid),
        5000000,
      );
      expect(
        gridMax(resolveOperation(Mode.transfert, TransferDestination.nonAbonne).grid),
        5000000,
      );
      expect(gridMax(resolveOperation(Mode.transfert, TransferDestination.mvola).grid), 20000000);
    });

    test('expose exactement deux modes', () {
      expect(Mode.values, [Mode.retrait, Mode.transfert]);
    });
  });
}
