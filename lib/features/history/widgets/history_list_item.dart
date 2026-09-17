import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/history_entry.dart';
import '../../../domain/fee_grids.dart';
import '../../../domain/format.dart';
import '../../../domain/models/mode.dart';

final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

class HistoryListItem extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onDelete;

  const HistoryListItem({super.key, required this.entry, required this.onDelete});

  String get _subtitle {
    final label = modeLabels[entry.mode]!;
    if (entry.mode == Mode.transfert && entry.destination != null) {
      return '$label · ${destinationLabels[entry.destination]}';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  entry.mode == Mode.retrait ? Icons.calculate_outlined : Icons.send_outlined,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatAriary(entry.amount),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(_subtitle, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      _dateFormat.format(entry.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (entry.savings > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '-${formatAriary(entry.savings)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('économisés', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
