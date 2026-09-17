import 'package:flutter/material.dart';

class ResultActions extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onShare;
  final GlobalKey shareButtonKey;

  const ResultActions({
    super.key,
    required this.onSave,
    required this.onShare,
    required this.shareButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: onSave,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Enregistrer'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            key: shareButtonKey,
            onPressed: onShare,
            icon: const Icon(Icons.share_outlined),
            label: const Text('Partager'),
          ),
        ),
      ],
    );
  }
}
