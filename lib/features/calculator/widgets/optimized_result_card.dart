import 'package:flutter/material.dart';

import '../../../domain/fee_grids.dart';
import '../../../domain/format.dart';
import '../../../domain/models/calculation_result.dart';

class OptimizedResultCard extends StatelessWidget {
  final OptimizedResult optimized;
  final OperationWording wording;

  const OptimizedResultCard({super.key, required this.optimized, required this.wording});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wording.splitBadge,
              style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(wording.splitCount(optimized.operations.length), style: textTheme.bodyMedium),
            const SizedBox(height: 12),
            for (var i = 0; i < optimized.operations.length; i++) ...[
              if (i > 0) const Divider(height: 16),
              Row(
                children: [
                  Text('${wording.itemNoun} ${i + 1}', style: textTheme.bodyMedium),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${formatAriary(optimized.operations[i].amount)} · '
                      '${formatAriary(optimized.operations[i].fee)}',
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              children: [
                Text('Total', style: textTheme.titleMedium),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    formatAriary(optimized.totalFee),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
