import 'package:flutter/material.dart';

import '../../../domain/fee_grids.dart';
import '../../../domain/models/mode.dart';

/// Sélecteur de mode sur mesure : coins légèrement arrondis (cohérents avec
/// les cartes et le champ de saisie), sans bordure ni forme pilule.
class ModeSelector extends StatelessWidget {
  final Mode value;
  final ValueChanged<Mode> onChanged;

  const ModeSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: colorScheme.surfaceContainerLow,
        child: Row(
          children: Mode.values.map((mode) {
            final selected = mode == value;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  color: selected ? colorScheme.primaryContainer : Colors.transparent,
                  child: Text(
                    modeLabels[mode]!,
                    style: textTheme.titleMedium?.copyWith(
                      color: selected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
