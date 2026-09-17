import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/history_notifier.dart';
import 'widgets/empty_history_view.dart';
import 'widgets/history_list_item.dart';
import 'widgets/history_summary_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider l\'historique ?'),
        content: const Text('Tous les calculs enregistrés seront définitivement supprimés.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Vider')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<HistoryNotifier>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryNotifier>();
    final entries = history.entries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (entries.isNotEmpty)
            IconButton(
              onPressed: () => _confirmClear(context),
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Vider l\'historique',
            ),
        ],
      ),
      body: SafeArea(
        child: entries.isEmpty
            ? const EmptyHistoryView()
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: entries.length + 1,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return HistorySummaryCard(
                      totalSavings: entries.fold(0, (sum, e) => sum + e.savings),
                      count: entries.length,
                    );
                  }
                  final entry = entries[index - 1];
                  return HistoryListItem(
                    entry: entry,
                    onDelete: () => context.read<HistoryNotifier>().removeById(entry.id),
                  );
                },
              ),
      ),
    );
  }
}
