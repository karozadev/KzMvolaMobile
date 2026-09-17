import 'package:flutter/material.dart';

import '../../../domain/format.dart';

class HistorySummaryCard extends StatelessWidget {
  final int totalSavings;
  final int count;

  const HistorySummaryCard({super.key, required this.totalSavings, required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.tertiary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.savings_rounded, color: colorScheme.onPrimary),
              ),
              const SizedBox(width: 12),
              Text(
                'Total économisé',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formatAriary(totalSavings),
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count > 1 ? 'grâce à $count calculs enregistrés' : 'grâce à 1 calcul enregistré',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
