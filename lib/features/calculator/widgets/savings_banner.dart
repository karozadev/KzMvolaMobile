import 'package:flutter/material.dart';

import '../../../domain/format.dart';

class SavingsBanner extends StatelessWidget {
  final int savings;
  final int directFee;
  final String suffix;

  const SavingsBanner({
    super.key,
    required this.savings,
    required this.directFee,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final percent = directFee > 0 ? (savings / directFee * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.savings_outlined, color: colorScheme.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '-${formatAriary(savings)} $suffix'
              '${percent > 0 ? ' (-$percent %)' : ''}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
