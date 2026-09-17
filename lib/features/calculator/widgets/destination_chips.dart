import 'package:flutter/material.dart';

import '../../../domain/fee_grids.dart';
import '../../../domain/models/mode.dart';

class DestinationChips extends StatelessWidget {
  final TransferDestination value;
  final ValueChanged<TransferDestination> onChanged;

  const DestinationChips({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TransferDestination.values.map((destination) {
        return ChoiceChip(
          label: Text(destinationLabels[destination]!),
          selected: value == destination,
          onSelected: (_) => onChanged(destination),
        );
      }).toList(),
    );
  }
}
