import '../domain/models/mode.dart';
import '../domain/models/operation.dart';

class HistoryEntry {
  final String id;
  final DateTime createdAt;
  final Mode mode;
  final TransferDestination? destination;
  final int amount;
  final bool directPossible;
  final int directFee;
  final int optimizedFee;
  final List<Operation> operations;
  final int savings;

  const HistoryEntry({
    required this.id,
    required this.createdAt,
    required this.mode,
    required this.destination,
    required this.amount,
    required this.directPossible,
    required this.directFee,
    required this.optimizedFee,
    required this.operations,
    required this.savings,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'mode': mode.name,
    'destination': destination?.name,
    'amount': amount,
    'directPossible': directPossible,
    'directFee': directFee,
    'optimizedFee': optimizedFee,
    'operations': operations.map((op) => op.toJson()).toList(),
    'savings': savings,
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    mode: Mode.values.byName(json['mode'] as String),
    destination: json['destination'] == null
        ? null
        : TransferDestination.values.byName(json['destination'] as String),
    amount: json['amount'] as int,
    directPossible: json['directPossible'] as bool,
    directFee: json['directFee'] as int,
    optimizedFee: json['optimizedFee'] as int,
    operations: (json['operations'] as List)
        .map((op) => Operation.fromJson(op as Map<String, dynamic>))
        .toList(),
    savings: json['savings'] as int,
  );
}
