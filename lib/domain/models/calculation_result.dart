import 'operation.dart';

class DirectResult {
  final bool possible;
  final int amount;
  final int? fee;

  const DirectResult({required this.possible, required this.amount, required this.fee});
}

class OptimizedResult {
  final List<Operation> operations;
  final int totalFee;
  final int totalAmount;

  const OptimizedResult({
    required this.operations,
    required this.totalFee,
    required this.totalAmount,
  });
}

class CalculationResult {
  final int amount;
  final DirectResult direct;
  final OptimizedResult optimized;
  final int savings;

  const CalculationResult({
    required this.amount,
    required this.direct,
    required this.optimized,
    required this.savings,
  });
}
