import 'models/calculation_result.dart';
import 'models/fee_models.dart';
import 'models/operation.dart';

/// Montant minimum couvert par une grille (borne basse du premier palier).
int gridMin(FeeGrid grid) => grid.tiers.first.min;

/// Montant maximum couvert par une grille (borne haute du dernier palier).
int gridMax(FeeGrid grid) => grid.tiers.last.max;

/// Sommets de tous les paliers d'une grille, utilisés comme « dénominations »
/// candidates pour tester les fractionnements. Triés par ordre croissant.
/// Tous les barèmes MVola ont des sommets multiples de 1 000 Ar : l'espace
/// d'états exploré par `_bestDecomposition` reste borné à ~ montant / 1 000.
List<int> _splitBreakpoints(FeeGrid grid) => grid.tiers.map((t) => t.max).toList();

/// Renvoie le frais MVola applicable à un montant pour une grille donnée, ou
/// `null` si le montant dépasse le plafond couvert par la grille.
int? getFeeForAmount(FeeGrid grid, int amount) {
  if (amount <= 0) return 0;
  if (amount > gridMax(grid)) return null;

  for (final tier in grid.tiers) {
    if (amount >= tier.min && amount <= tier.max) return tier.fee;
  }
  // Sous le premier palier (montant < borne minimale) : aucun frais.
  return 0;
}

/// Calcule le coût d'une opération effectuée en une seule transaction.
DirectResult calculateDirect(FeeGrid grid, int amount) {
  final fee = getFeeForAmount(grid, amount);
  return DirectResult(possible: fee != null, amount: amount, fee: fee);
}

class _SplitState {
  final num fee;
  final List<Operation> operations;

  const _SplitState({required this.fee, required this.operations});
}

/// Calcule, par programmation dynamique mémoïsée, la meilleure décomposition
/// de `target` en une somme de sommets de palier (+ un reliquat direct) qui
/// minimise le total des frais MVola.
///
/// Implémentation itérative (pile explicite, pas de récursion native) pour
/// ne jamais risquer de dépassement de pile d'appel, même sur de gros
/// montants. Comme tous les sommets de palier sont des multiples de 1 000 Ar,
/// tous les montants intermédiaires rencontrés partagent le même reste
/// modulo 1 000 que `target` : le nombre d'états distincts est donc borné par
/// `target / 1 000` (~20 000 états au maximum pour 20 000 000 Ar), ce qui
/// reste largement gérable en performance.
_SplitState _bestDecomposition(FeeGrid grid, int target) {
  final min = gridMin(grid);
  final breakpoints = _splitBreakpoints(grid);
  final memo = <int, _SplitState>{};
  final stack = <int>[target];

  while (stack.isNotEmpty) {
    final amount = stack.last;

    if (amount <= 0) {
      memo[amount] = const _SplitState(fee: 0, operations: []);
      stack.removeLast();
      continue;
    }
    if (memo.containsKey(amount)) {
      stack.removeLast();
      continue;
    }

    final candidates = breakpoints.where((bp) => bp <= amount).toList();
    final missing = candidates
        .map((bp) => amount - bp)
        .where((rest) => rest > 0 && !memo.containsKey(rest))
        .toList();

    if (missing.isNotEmpty) {
      // Les dépendances (montants restants) ne sont pas encore résolues :
      // on les empile et on retraite `amount` une fois qu'elles le seront.
      stack.addAll(missing);
      continue;
    }

    // Cas de base : effectuer tout `amount` en une seule fois (si couvert par le barème).
    num bestFee = double.infinity;
    List<Operation> bestOperations = const [];
    final isUnsplittableRemainder = amount != target && amount < min;
    final directFee = isUnsplittableRemainder ? null : getFeeForAmount(grid, amount);
    if (directFee != null) {
      bestFee = directFee;
      bestOperations = [Operation(amount: amount, fee: directFee)];
    }

    // Cas récursif : prélever un sommet de palier puis compléter avec le reste optimal.
    for (final bp in candidates) {
      final chunkFee = getFeeForAmount(grid, bp)!;
      final rest = amount - bp;
      final restResult = rest > 0 ? memo[rest]! : const _SplitState(fee: 0, operations: []);
      final totalFee = chunkFee + restResult.fee;
      if (totalFee < bestFee) {
        bestFee = totalFee;
        bestOperations = [Operation(amount: bp, fee: chunkFee), ...restResult.operations];
      }
    }

    memo[amount] = _SplitState(fee: bestFee, operations: bestOperations);
    stack.removeLast();
  }

  return memo[target]!;
}

/// Recherche, parmi toutes les décompositions possibles en sommets de palier
/// de la grille (+ un reliquat), celle qui minimise la somme des frais MVola
/// pour `amount`.
OptimizedResult calculateOptimizedSplit(FeeGrid grid, int amount) {
  if (amount <= 0) {
    return const OptimizedResult(operations: [], totalFee: 0, totalAmount: 0);
  }

  final result = _bestDecomposition(grid, amount);

  if (!result.fee.isFinite) {
    // Aucune décomposition valide trouvée (ne devrait pas arriver en
    // pratique grâce au chaînage d'opérations au sommet le plus haut).
    return const OptimizedResult(operations: [], totalFee: 0, totalAmount: 0);
  }

  return OptimizedResult(
    operations: result.operations,
    totalFee: result.fee.toInt(),
    totalAmount: result.operations.fold(0, (sum, op) => sum + op.amount),
  );
}

/// Compare l'option directe et l'option optimisée pour un montant et une grille donnés.
CalculationResult calculateMvolaFees(FeeGrid grid, int amount) {
  final direct = calculateDirect(grid, amount);
  final optimized = calculateOptimizedSplit(grid, amount);

  final num directFee = direct.possible ? (direct.fee ?? 0) : double.infinity;
  final savings = direct.possible
      ? (directFee - optimized.totalFee).clamp(0, double.infinity).toInt()
      : 0;

  return CalculationResult(amount: amount, direct: direct, optimized: optimized, savings: savings);
}
