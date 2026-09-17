import 'models/fee_models.dart';
import 'models/mode.dart';

/// Toutes les grilles proviennent du tarif officiel MVola publié sur
/// https://www.mvola.mg/tarifs/ (barème « Cash Point » pour le retrait,
/// barème « Transfert d'argent » pour les transferts).
const officialTariffUrl = 'https://www.mvola.mg/tarifs/';

// --- Retrait (Cash Point), de 100 à 20 000 000 Ar --------------------------

const _withdrawalTiers = <FeeTier>[
  FeeTier(min: 100, max: 1000, fee: 100),
  FeeTier(min: 1001, max: 5000, fee: 150),
  FeeTier(min: 5001, max: 10000, fee: 275),
  FeeTier(min: 10001, max: 20000, fee: 550),
  FeeTier(min: 20001, max: 25000, fee: 650),
  FeeTier(min: 25001, max: 50000, fee: 1300),
  FeeTier(min: 50001, max: 100000, fee: 1900),
  FeeTier(min: 100001, max: 250000, fee: 3400),
  FeeTier(min: 250001, max: 500000, fee: 4700),
  FeeTier(min: 500001, max: 1000000, fee: 8800),
  FeeTier(min: 1000001, max: 2000000, fee: 14700),
  FeeTier(min: 2000001, max: 3000000, fee: 19600),
  FeeTier(min: 3000001, max: 4000000, fee: 24500),
  FeeTier(min: 4000001, max: 5000000, fee: 29400),
  FeeTier(min: 5000001, max: 6000000, fee: 34300),
  FeeTier(min: 6000001, max: 7000000, fee: 39200),
  FeeTier(min: 7000001, max: 8000000, fee: 44100),
  FeeTier(min: 8000001, max: 9000000, fee: 49000),
  FeeTier(min: 9000001, max: 10000000, fee: 53900),
  FeeTier(min: 10000001, max: 11000000, fee: 59000),
  FeeTier(min: 11000001, max: 12000000, fee: 64000),
  FeeTier(min: 12000001, max: 13000000, fee: 69000),
  FeeTier(min: 13000001, max: 14000000, fee: 74000),
  FeeTier(min: 14000001, max: 15000000, fee: 79000),
  FeeTier(min: 15000001, max: 16000000, fee: 84000),
  FeeTier(min: 16000001, max: 17000000, fee: 89000),
  FeeTier(min: 17000001, max: 18000000, fee: 94000),
  FeeTier(min: 18000001, max: 19000000, fee: 98000),
  FeeTier(min: 19000001, max: 20000000, fee: 100000),
];

// --- Transfert vers un abonné MVola, de 100 à 20 000 000 Ar ----------------

const _transferMvolaTiers = <FeeTier>[
  FeeTier(min: 100, max: 1000, fee: 70),
  FeeTier(min: 1001, max: 5000, fee: 70),
  FeeTier(min: 5001, max: 10000, fee: 150),
  FeeTier(min: 10001, max: 25000, fee: 250),
  FeeTier(min: 25001, max: 50000, fee: 500),
  FeeTier(min: 50001, max: 100000, fee: 1000),
  FeeTier(min: 100001, max: 250000, fee: 1900),
  FeeTier(min: 250001, max: 500000, fee: 1900),
  FeeTier(min: 500001, max: 1000000, fee: 3200),
  FeeTier(min: 1000001, max: 2000000, fee: 3800),
  FeeTier(min: 2000001, max: 3000000, fee: 5000),
  FeeTier(min: 3000001, max: 4000000, fee: 6300),
  FeeTier(min: 4000001, max: 5000000, fee: 7500),
  FeeTier(min: 5000001, max: 6000000, fee: 9400),
  FeeTier(min: 6000001, max: 7000000, fee: 10700),
  FeeTier(min: 7000001, max: 8000000, fee: 12500),
  FeeTier(min: 8000001, max: 9000000, fee: 14400),
  FeeTier(min: 9000001, max: 10000000, fee: 15700),
  FeeTier(min: 10000001, max: 11000000, fee: 17500),
  FeeTier(min: 11000001, max: 12000000, fee: 18800),
  FeeTier(min: 12000001, max: 13000000, fee: 20000),
  FeeTier(min: 13000001, max: 14000000, fee: 21300),
  FeeTier(min: 14000001, max: 15000000, fee: 23200),
  FeeTier(min: 15000001, max: 16000000, fee: 25000),
  FeeTier(min: 16000001, max: 17000000, fee: 26300),
  FeeTier(min: 17000001, max: 18000000, fee: 28200),
  FeeTier(min: 18000001, max: 19000000, fee: 30000),
  FeeTier(min: 19000001, max: 20000000, fee: 31300),
];

// --- Transfert vers/depuis un autre opérateur Mobile Money, jusqu'à 5 M ----

const _transferOtherOperatorTiers = <FeeTier>[
  FeeTier(min: 100, max: 1000, fee: 200),
  FeeTier(min: 1001, max: 5000, fee: 250),
  FeeTier(min: 5001, max: 10000, fee: 500),
  FeeTier(min: 10001, max: 25000, fee: 1000),
  FeeTier(min: 25001, max: 50000, fee: 1500),
  FeeTier(min: 50001, max: 100000, fee: 2000),
  FeeTier(min: 100001, max: 250000, fee: 3500),
  FeeTier(min: 250001, max: 500000, fee: 5000),
  FeeTier(min: 500001, max: 1000000, fee: 8500),
  FeeTier(min: 1000001, max: 2000000, fee: 12000),
  FeeTier(min: 2000001, max: 3000000, fee: 14500),
  FeeTier(min: 3000001, max: 4000000, fee: 19500),
  FeeTier(min: 4000001, max: 5000000, fee: 24000),
];

// --- Transfert vers un non-abonné Mobile Money, jusqu'à 5 M ----------------

const _transferNonSubscriberTiers = <FeeTier>[
  FeeTier(min: 100, max: 1000, fee: 750),
  FeeTier(min: 1001, max: 5000, fee: 750),
  FeeTier(min: 5001, max: 10000, fee: 1400),
  FeeTier(min: 10001, max: 25000, fee: 1800),
  FeeTier(min: 25001, max: 50000, fee: 3800),
  FeeTier(min: 50001, max: 100000, fee: 4800),
  FeeTier(min: 100001, max: 250000, fee: 10000),
  FeeTier(min: 250001, max: 500000, fee: 15000),
  FeeTier(min: 500001, max: 1000000, fee: 20000),
  FeeTier(min: 1000001, max: 2000000, fee: 30000),
  FeeTier(min: 2000001, max: 3000000, fee: 40000),
  FeeTier(min: 3000001, max: 4000000, fee: 50000),
  FeeTier(min: 4000001, max: 5000000, fee: 60000),
];

/// Libellés courts des onglets de mode.
const modeLabels = <Mode, String>{Mode.retrait: 'Retrait', Mode.transfert: 'Transfert'};

/// Libellés des destinations de transfert (sélecteur + pied de page).
const destinationLabels = <TransferDestination, String>{
  TransferDestination.mvola: 'Vers un abonné MVola',
  TransferDestination.autreOperateur: 'Vers/depuis un autre opérateur',
  TransferDestination.nonAbonne: 'Vers un non-abonné Mobile Money',
};

/// Formulations qui varient selon le type d'opération affiché.
class OperationWording {
  /// Étiquette du champ de saisie.
  final String amountLabel;

  /// Badge de la carte « option directe ».
  final String directBadge;

  /// Badge de la carte « option fractionnée ».
  final String splitBadge;

  /// Ligne décrivant l'opération en une fois.
  final String onceLine;

  /// Préfixe de chaque ligne de la décomposition (« Retrait 1 · … »).
  final String itemNoun;

  /// Phrase indiquant le nombre d'opérations de la décomposition.
  final String Function(int n) splitCount;

  /// Message affiché quand le montant dépasse le plafond.
  final String impossible;

  /// Suffixe de la bannière d'économie.
  final String savingsSuffix;

  const OperationWording({
    required this.amountLabel,
    required this.directBadge,
    required this.splitBadge,
    required this.onceLine,
    required this.itemNoun,
    required this.splitCount,
    required this.impossible,
    required this.savingsSuffix,
  });
}

final _retraitWording = OperationWording(
  amountLabel: 'Montant total à retirer',
  directBadge: 'Retrait direct',
  splitBadge: 'Retrait fractionné',
  onceLine: 'Retirer en une fois',
  itemNoun: 'Retrait',
  splitCount: (n) => 'Retrait fractionné en $n opérations',
  impossible: 'Retrait impossible en une seule transaction (plafond dépassé).',
  savingsSuffix: 'économisés vs. retrait direct',
);

final _transfertWording = OperationWording(
  amountLabel: 'Montant total à transférer',
  directBadge: 'Transfert direct',
  splitBadge: 'Transfert fractionné',
  onceLine: 'Envoyer en une fois',
  itemNoun: 'Envoi',
  splitCount: (n) => 'Transfert fractionné en $n envois',
  impossible: 'Transfert impossible en une seule transaction (plafond dépassé).',
  savingsSuffix: 'économisés vs. transfert direct',
);

class OperationConfig {
  final FeeGrid grid;
  final OperationWording wording;

  /// Sous-titre affiché dans l'en-tête.
  final String heroSubtitle;

  /// Précision affichée sous les cartes / dans le pied de page.
  final String gridCaption;

  const OperationConfig({
    required this.grid,
    required this.wording,
    required this.heroSubtitle,
    required this.gridCaption,
  });
}

const _retraitGrid = FeeGrid(id: 'retrait', tiers: _withdrawalTiers);
const _transfertMvolaGrid = FeeGrid(id: 'transfert-mvola', tiers: _transferMvolaTiers);
const _transfertAutreOperateurGrid = FeeGrid(
  id: 'transfert-autre-operateur',
  tiers: _transferOtherOperatorTiers,
);
const _transfertNonAbonneGrid = FeeGrid(
  id: 'transfert-non-abonne',
  tiers: _transferNonSubscriberTiers,
);

/// Grilles exposées pour les tests et la documentation.
const feeGrids = <String, FeeGrid>{
  'retrait': _retraitGrid,
  'transfert-mvola': _transfertMvolaGrid,
  'transfert-autre-operateur': _transfertAutreOperateurGrid,
  'transfert-non-abonne': _transfertNonAbonneGrid,
};

const _retraitSubtitle =
    'Comparez le retrait direct et le retrait fractionné pour payer le moins de frais possible.';
const _transfertSubtitle =
    'Comparez le transfert direct et le transfert fractionné pour savoir en combien d\'envois payer le moins de frais.';

FeeGrid _transferGridFor(TransferDestination destination) {
  switch (destination) {
    case TransferDestination.mvola:
      return _transfertMvolaGrid;
    case TransferDestination.autreOperateur:
      return _transfertAutreOperateurGrid;
    case TransferDestination.nonAbonne:
      return _transfertNonAbonneGrid;
  }
}

/// Résout la configuration (grille + formulations) pour un mode et une destination.
OperationConfig resolveOperation(Mode mode, TransferDestination destination) {
  if (mode == Mode.retrait) {
    return OperationConfig(
      grid: _retraitGrid,
      wording: _retraitWording,
      heroSubtitle: _retraitSubtitle,
      gridCaption: 'Grille tarifaire MVola Cash Point · Madagascar',
    );
  }
  return OperationConfig(
    grid: _transferGridFor(destination),
    wording: _transfertWording,
    heroSubtitle: _transfertSubtitle,
    gridCaption:
        'Grille tarifaire MVola Transfert d\'argent · ${destinationLabels[destination]}',
  );
}
