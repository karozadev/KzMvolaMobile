import 'package:flutter/material.dart';

import '../../../domain/fee_grids.dart';
import '../../../domain/format.dart';
import '../../../domain/models/calculation_result.dart';

class DirectResultCard extends StatelessWidget {
  final DirectResult direct;
  final OperationWording wording;

  const DirectResultCard({super.key, required this.direct, required this.wording});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wording.directBadge,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(wording.onceLine, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            if (direct.possible)
              Text(
                formatAriary(direct.fee ?? 0),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              )
            else
              Text(
                wording.impossible,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }
}
